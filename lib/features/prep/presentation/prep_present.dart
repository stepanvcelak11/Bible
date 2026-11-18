part of 'prep_screen.dart';

// --- Prezentace (kázání) a zkušební kázání ----------------------------------

const _ink = Color(0xFFF3E6CC);
const _line = Color(0x2EF3E6CC);

/// Výchozí rámečky bloků obrazovky podle automatického rozvržení – z nich
/// se vychází, když si kazatel obrazovku poprvé upravuje ručně.
Map<int, PrepFrame> defaultFrames(List<PrepBlock> blocks, PrepLayout layout) {
  final rows = prepRows(blocks, layout);
  final out = <int, PrepFrame>{};
  const pad = 0.03, gap = 0.02;
  final band = (1 - 2 * pad) / rows.length;
  for (final (i, r) in rows.indexed) {
    final top = pad + i * band;
    void column(List<PrepBlock> list, double x, double w) {
      final h = band / list.length;
      for (final (j, b) in list.indexed) {
        out[b.id] = PrepFrame(x, top + j * h, w, h - gap);
      }
    }

    if (r.left.isNotEmpty && r.right.isNotEmpty) {
      column(r.left, pad, 0.5 - pad - gap / 2);
      column(r.right, 0.5 + gap / 2, 0.5 - pad - gap / 2);
    } else {
      column([...r.left, ...r.right], pad, 1 - 2 * pad);
    }
  }
  return out;
}

/// Prezentační režim: velké písmo, listování po obrazovkách, postupné
/// odkrývání bloků po klepnutích a stopky. Ve zkušebním režimu (úpravy)
/// jde každý blok přesunout, zvětšit a nastavit, kdy se objeví.
class PrepPresentScreen extends ConsumerStatefulWidget {
  const PrepPresentScreen({
    super.key,
    required this.prepId,
    this.rehearsal = false,
  });

  final int prepId;

  /// Otevřít rovnou ve zkušebním režimu s úpravami obrazovky.
  final bool rehearsal;

  @override
  ConsumerState<PrepPresentScreen> createState() => _PrepPresentScreenState();
}

class _PrepPresentScreenState extends ConsumerState<PrepPresentScreen> {
  final _watch = Stopwatch()..start();
  late final Timer _tick;
  double _scale = 1;
  int _page = 0;

  /// Kolik klepnutí na této obrazovce už proběhlo (bloky s `step` ≤ tomu
  /// jsou vidět).
  int _step = 0;
  late bool _editing = widget.rehearsal;
  int? _selected;

  /// Rámečky během tažení (uloží se po puštění).
  final _drafts = <int, PrepFrame>{};

  late var _layout =
      PrepLayout.values.asNameMap()[ref
          .read(appPreferencesProvider)
          .prepLayout] ??
      PrepLayout.stacked;
  late var _mode = ref.read(appPreferencesProvider).prepSlideMode == 'sections'
      ? PrepSlideMode.sections
      : PrepSlideMode.custom;

  /// Ukazovat rámečky oblastí pro klepnutí (vlevo zpět, vpravo dál).
  late var _zones = ref.read(appPreferencesProvider).prepTapZones;

  /// Popisky oblastí („Zpět“, „Dál“) se po přechodu na obrazovku ukážou
  /// jen na chvíli; rámečky zůstávají.
  int _labelsPage = -1;
  Duration _labelsSince = Duration.zero;

  /// Podíl šířky obrazovky, kterým se listuje zpět (zbytek = dál).
  static const _backShare = 0.3;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  PrepController get _controller => ref.read(prepProvider.notifier);

  /// Hodnoty klepnutí, na která se na obrazovce něco objeví.
  static List<int> _steps(List<PrepBlock> slide) =>
      ({for (final b in slide) b.step}..remove(0)).toList()..sort();

  void _next(List<List<PrepBlock>> slides) {
    if (_page > 0) {
      final later = _steps(slides[_page - 1]).where((s) => s > _step);
      if (later.isNotEmpty) {
        setState(() => _step = later.first);
        return;
      }
    }
    if (_page < slides.length) {
      setState(() {
        _page++;
        _step = 0;
        _selected = null;
      });
    }
  }

  void _prev(List<List<PrepBlock>> slides) {
    if (_page > 0) {
      final earlier = [0, ..._steps(slides[_page - 1])].where((s) => s < _step);
      if (earlier.isNotEmpty) {
        setState(() => _step = earlier.last);
        return;
      }
    }
    if (_page > 0) {
      setState(() {
        _page--;
        _selected = null;
        // Zpět na předchozí obrazovku = celá, jak skončila.
        final steps = _page == 0 ? const <int>[] : _steps(slides[_page - 1]);
        _step = steps.isEmpty ? 0 : steps.last;
      });
    }
  }

  /// Uloží rámečky celé obrazovky (všechny bloky dostanou ruční místo).
  void _commit(List<PrepBlock> slide, Map<int, PrepFrame> frames) {
    _controller.updateBlocks(widget.prepId, [
      for (final b in slide)
        if (frames[b.id] case final f?)
          b.copyWith(frame: () => f, frameKey: prepSlideKey(slide)),
    ]);
  }

  /// Rámečky obrazovky: uložené, rozpracované, jinak výchozí.
  Map<int, PrepFrame> _frames(List<PrepBlock> slide) {
    final defaults = defaultFrames(slide, _layout);
    final key = prepSlideKey(slide);
    return {
      for (final b in slide)
        b.id:
            _drafts[b.id] ??
            (prepHasFrame(b, key) ? b.frame! : null) ??
            defaults[b.id]!,
    };
  }

  void _updateSelected(List<PrepBlock> slide, PrepBlock Function(PrepBlock) f) {
    final b = slide.where((x) => x.id == _selected).firstOrNull;
    if (b == null) return;
    _controller.updateBlock(widget.prepId, f(b));
  }

  /// Obrazovka i s přehledem: jen poslední krok (vše odkryté).
  void _jump(List<List<PrepBlock>> slides, int page) => setState(() {
    _page = page;
    _selected = null;
    final steps = page == 0 ? const <int>[] : _steps(slides[page - 1]);
    _step = _editing || steps.isEmpty ? 0 : steps.last;
  });

  bool _showZoneLabels() {
    if (_labelsPage != _page) {
      _labelsPage = _page;
      _labelsSince = _watch.elapsed;
    }
    return _watch.elapsed - _labelsSince < const Duration(seconds: 4);
  }

  KeyEventResult _onKey(KeyEvent e, List<List<PrepBlock>> slides) {
    if (_editing || e is KeyUpEvent) return KeyEventResult.ignored;
    final k = e.logicalKey;
    if (const [
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.pageDown,
      LogicalKeyboardKey.space,
      LogicalKeyboardKey.enter,
    ].contains(k)) {
      _next(slides);
      return KeyEventResult.handled;
    }
    if (const [
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.pageUp,
      LogicalKeyboardKey.backspace,
    ].contains(k)) {
      _prev(slides);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Future<void> _overview(Prep prep, List<List<PrepBlock>> slides) async {
    final page = await showDialog<int>(
      context: context,
      builder: (c) => Dialog.fullscreen(
        backgroundColor: const Color(0xFF15120F),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        S.prepOverview,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      color: _ink,
                      tooltip: S.close,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(c).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: slides.length + 1,
                  itemBuilder: (c, i) {
                    final current = i == _page;
                    return InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.of(c).pop(i),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1A15),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: current
                                      ? const Color(0xFFE8C77E)
                                      : _line,
                                  width: current ? 2 : 1,
                                ),
                              ),
                              child: IgnorePointer(
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: MediaQuery(
                                    data: MediaQuery.of(c)
                                        .copyWith(size: const Size(1000, 625)),
                                    child: SizedBox(
                                      width: 1000,
                                      height: 625,
                                      child: _content(
                                        prep,
                                        i == 0
                                            ? const <PrepBlock>[]
                                            : slides[i - 1],
                                        page: i,
                                        step: 99,
                                        preview: true,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6, left: 2),
                            child: Text(
                              i == 0
                                  ? '${i + 1}. ${S.prepOverviewTitle}'
                                  : '${i + 1}. ${_slideName(slides[i - 1])}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: current
                                    ? const Color(0xFFE8C77E)
                                    : _ink.withValues(alpha: 0.8),
                                fontSize: 13,
                                fontWeight: current
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (page != null && mounted) _jump(slides, page);
  }

  String _slideName(List<PrepBlock> slide) {
    final b = slide.first;
    if (b.passage case final p?) return passageLabel(ref, p);
    final t = b.text.trim().split('\n').first;
    return t.isEmpty ? b.kind.label : t;
  }

  /// Obsah jedné obrazovky (i pro náhled v přehledu).
  Widget _content(
    Prep prep,
    List<PrepBlock> slide, {
    required int page,
    required int step,
    bool preview = false,
  }) {
    final editing = _editing && !preview;
    final key = prepSlideKey(slide);
    final free =
        page > 0 && (editing || slide.every((b) => prepHasFrame(b, key)));
    if (page == 0) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: _Slide(
              title: prep.title.isEmpty ? S.prepUntitled : prep.title,
              subtitle: prep.passages.isEmpty
                  ? prep.kind.label
                  : prep.passages.map((p) => passageLabel(ref, p)).join(' · '),
              scale: preview ? 1 : _scale,
              big: true,
            ),
          ),
        ),
      );
    }
    if (free) {
      return _FreeCanvas(
        slide: slide,
        frames: preview
            ? {
                for (final b in slide)
                  b.id:
                      (prepHasFrame(b, key) ? b.frame : null) ??
                      defaultFrames(slide, _layout)[b.id]!,
              }
            : _frames(slide),
        step: step,
        scale: preview ? 1 : _scale,
        editing: editing,
        selected: preview ? null : _selected,
        onSelect: (id) => setState(() => _selected = id),
        onDrag: (id, f) => setState(() => _drafts[id] = f),
        onDragEnd: () {
          final frames = _frames(slide);
          _drafts.clear();
          _commit(slide, frames);
        },
      );
    }
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _layout == PrepLayout.stacked ? 900 : 1400,
          ),
          child: _GroupSlide(
            blocks: slide,
            layout: _layout,
            scale: preview ? 1 : _scale,
            step: step,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prep = ref.watch(
      prepProvider.select(
        (l) => l.where((p) => p.id == widget.prepId).firstOrNull,
      ),
    );
    if (prep == null) return const Scaffold();
    final blocks = prep.blocks
        .where((b) => b.text.trim().isNotEmpty || b.passage != null)
        .toList();
    final slides = prepSlides(blocks, _mode);
    final count = slides.length + 1;
    if (_page >= count) _page = count - 1;
    final slide = _page == 0 ? const <PrepBlock>[] : slides[_page - 1];
    final e = _watch.elapsed;
    final time =
        '${e.inMinutes}:${(e.inSeconds % 60).toString().padLeft(2, '0')}';
    final selected = slide.where((b) => b.id == _selected).firstOrNull;

    // Zpět vrací délku kázání (editor pak nabídne zapsat, kde se kázalo).
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(_watch.elapsed);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF15120F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: _ink,
          titleSpacing: 0,
          title: Text(
            _editing
                ? '${S.prepRehearsal} · ${_page + 1}/$count'
                : '$time  ·  ${_page + 1}/$count',
            style: const TextStyle(
              color: _ink,
              fontSize: 17,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          actions: [
            IconButton(
              tooltip: S.prepOverview,
              icon: const Icon(Icons.grid_view_rounded),
              onPressed: () => _overview(prep, slides),
            ),
            IconButton(
              tooltip: _editing ? S.prepEditDone : S.prepEditScreen,
              isSelected: _editing,
              icon: Icon(
                _editing ? Icons.check : Icons.design_services_outlined,
              ),
              onPressed: () => setState(() {
                _editing = !_editing;
                _selected = null;
              }),
            ),
            PopupMenuButton<Object>(
              tooltip: S.prepLayout,
              icon: const Icon(Icons.dashboard_customize_outlined),
              onSelected: (v) {
                final prefs = ref.read(appPreferencesProvider);
                setState(() {
                  switch (v) {
                    case final PrepSlideMode m:
                      _mode = m;
                      _page = 0;
                      _step = 0;
                      prefs.setPrepSlideMode(m.name);
                    case final PrepLayout l:
                      _layout = l;
                      prefs.setPrepLayout(l.name);
                    case 'zones':
                      _zones = !_zones;
                      prefs.setPrepTapZones(_zones);
                  }
                });
              },
              itemBuilder: (_) => [
                const PopupMenuItem<Object>(
                  enabled: false,
                  child: Text(S.prepSlideMode),
                ),
                for (final (m, title) in const [
                  (PrepSlideMode.custom, S.prepSlideCustom),
                  (PrepSlideMode.sections, S.prepSlideSections),
                ])
                  CheckedPopupMenuItem<Object>(
                    value: m,
                    checked: _mode == m,
                    child: Text(title),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem<Object>(
                  enabled: false,
                  child: Text(S.prepLayout),
                ),
                for (final l in PrepLayout.values)
                  CheckedPopupMenuItem<Object>(
                    value: l,
                    checked: _layout == l,
                    child: Text(l.label),
                  ),
                const PopupMenuDivider(),
                CheckedPopupMenuItem<Object>(
                  value: 'zones',
                  checked: _zones,
                  child: const Text(S.prepTapZones),
                ),
              ],
            ),
            if (!_editing) ...[
              IconButton(
                tooltip: S.smallerText,
                icon: const Icon(Icons.text_decrease),
                onPressed: () =>
                    setState(() => _scale = (_scale - 0.15).clamp(0.6, 2.0)),
              ),
              IconButton(
                tooltip: S.largerText,
                icon: const Icon(Icons.text_increase),
                onPressed: () =>
                    setState(() => _scale = (_scale + 0.15).clamp(0.6, 2.0)),
              ),
            ],
          ],
        ),
        bottomNavigationBar: _editing
            ? _EditBar(
                selected: selected,
                canPrev: _page > 0,
                canNext: _page < count - 1,
                onPrev: () => _prev(slides),
                onNext: () => setState(() {
                  if (_page < count - 1) {
                    _page++;
                    _step = 0;
                    _selected = null;
                  }
                }),
                onReset: _page == 0
                    ? null
                    : () {
                        _drafts.clear();
                        _controller.updateBlocks(widget.prepId, [
                          for (final b in slide)
                            b.copyWith(frame: () => null, frameKey: ''),
                        ]);
                      },
                onStep: (d) => _updateSelected(
                  slide,
                  (b) => b.copyWith(step: (b.step + d).clamp(0, 20)),
                ),
                onZoom: (d) => _updateSelected(
                  slide,
                  (b) => b.copyWith(zoom: (b.zoom + d).clamp(0.4, 3.0)),
                ),
                onFullWidth: () {
                  final frames = _frames(slide);
                  final f = frames[_selected]!;
                  frames[_selected!] = PrepFrame(0.03, f.y, 0.94, f.h);
                  _commit(slide, frames);
                },
                onTranslations: selected?.passage == null
                    ? null
                    : () => showPrepTranslations(
                        context,
                        ref,
                        widget.prepId,
                        selected!,
                      ),
              )
            : null,
        body: Focus(
          autofocus: true,
          onKeyEvent: (_, e) => _onKey(e, slides),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: _editing
                ? (_) => setState(() => _selected = null)
                : (d) {
                    final w = MediaQuery.sizeOf(context).width;
                    d.localPosition.dx > w * _backShare
                        ? _next(slides)
                        : _prev(slides);
                  },
            onHorizontalDragEnd: _editing
                ? null
                : (d) {
                    final v = d.primaryVelocity ?? 0;
                    if (v < -200) _next(slides);
                    if (v > 200) _prev(slides);
                  },
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(_page),
                      child: _content(prep, slide, page: _page, step: _step),
                    ),
                  ),
                ),
                if (_zones && !_editing)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: _TapZones(
                        backShare: _backShare,
                        showLabels: _showZoneLabels(),
                        canBack: _page > 0,
                        canNext:
                            _page < count - 1 ||
                            (_page > 0 && _steps(slide).any((s) => s > _step)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rámečky oblastí pro klepnutí: vlevo zpět, vpravo dál – nenápadné,
/// aby nerušily text, ale aby bylo vidět, kam klepnout.
class _TapZones extends StatelessWidget {
  const _TapZones({
    required this.backShare,
    required this.canBack,
    required this.canNext,
    required this.showLabels,
  });

  final double backShare;
  final bool canBack, canNext;

  /// Ukázat popisky (jen chvíli po přechodu na obrazovku).
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    Widget zone(IconData icon, String label, bool active, bool left) =>
        Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _ink.withValues(alpha: active ? 0.14 : 0.06),
              width: 1.5,
            ),
          ),
          alignment: left ? Alignment.bottomLeft : Alignment.bottomRight,
          padding: const EdgeInsets.all(6),
          // Tmavý podklad, aby popisek nepřekrýval text pod sebou.
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 600),
            opacity: showLabels ? 1 : 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFF15120F).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Opacity(
                  opacity: active ? 0.55 : 0.2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (left) Icon(icon, color: _ink, size: 20),
                      Text(
                        label,
                        style: const TextStyle(color: _ink, fontSize: 13),
                      ),
                      if (!left) Icon(icon, color: _ink, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: (backShare * 100).round(),
          child: zone(Icons.chevron_left, S.prepBack, canBack, true),
        ),
        Expanded(
          flex: ((1 - backShare) * 100).round(),
          child: zone(Icons.chevron_right, S.prepForward, canNext, false),
        ),
      ],
    );
  }
}

/// Spodní lišta zkušebního režimu: přechod mezi obrazovkami a úpravy
/// vybraného bloku (kdy se objeví, velikost písma, šířka, překlady).
class _EditBar extends StatelessWidget {
  const _EditBar({
    required this.selected,
    required this.canPrev,
    required this.canNext,
    required this.onPrev,
    required this.onNext,
    required this.onReset,
    required this.onStep,
    required this.onZoom,
    required this.onFullWidth,
    required this.onTranslations,
  });

  final PrepBlock? selected;
  final bool canPrev, canNext;
  final VoidCallback onPrev, onNext, onFullWidth;
  final VoidCallback? onReset, onTranslations;
  final ValueChanged<int> onStep;
  final ValueChanged<double> onZoom;

  @override
  Widget build(BuildContext context) {
    final b = selected;
    const label = TextStyle(color: _ink, fontSize: 13);
    Widget small(IconData icon, String tip, VoidCallback? onTap) => IconButton(
      tooltip: tip,
      visualDensity: VisualDensity.compact,
      color: _ink,
      disabledColor: _ink.withValues(alpha: 0.3),
      icon: Icon(icon, size: 20),
      onPressed: onTap,
    );
    return Material(
      color: const Color(0xFF221D18),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (b == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    S.prepEditHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _ink, fontSize: 13, height: 1.3),
                  ),
                )
              else
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 2,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.touch_app_outlined,
                          size: 18,
                          color: _ink,
                        ),
                        const SizedBox(width: 4),
                        const Text(S.prepAppears, style: label),
                        small(
                          Icons.remove,
                          S.prepStepEarlier,
                          b.step > 0 ? () => onStep(-1) : null,
                        ),
                        Text(
                          b.step == 0 ? S.prepStepNow : S.prepStepAt(b.step),
                          style: label.copyWith(fontWeight: FontWeight.w700),
                        ),
                        small(Icons.add, S.prepStepLater, () => onStep(1)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.format_size, size: 18, color: _ink),
                        small(Icons.remove, S.smallerText, () => onZoom(-0.1)),
                        Text('${(b.zoom * 100).round()} %', style: label),
                        small(Icons.add, S.largerText, () => onZoom(0.1)),
                      ],
                    ),
                    small(
                      Icons.width_full_outlined,
                      S.prepFullWidth,
                      onFullWidth,
                    ),
                    if (onTranslations != null)
                      small(
                        Icons.translate,
                        S.prepTranslationsTitle,
                        onTranslations,
                      ),
                  ],
                ),
              Row(
                children: [
                  small(
                    Icons.chevron_left,
                    S.prepPrevScreen,
                    canPrev ? onPrev : null,
                  ),
                  Expanded(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: _ink),
                      onPressed: onReset,
                      icon: const Icon(
                        Icons.auto_awesome_mosaic_outlined,
                        size: 18,
                      ),
                      label: const Text(S.prepResetScreen),
                    ),
                  ),
                  small(
                    Icons.chevron_right,
                    S.prepNextScreen,
                    canNext ? onNext : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Obrazovka s ručně rozmístěnými bloky. Při úpravách jde blok táhnout,
/// měnit mu velikost úchytem v rohu a vybrat ho klepnutím.
class _FreeCanvas extends StatelessWidget {
  const _FreeCanvas({
    required this.slide,
    required this.frames,
    required this.step,
    required this.scale,
    required this.editing,
    required this.selected,
    required this.onSelect,
    required this.onDrag,
    required this.onDragEnd,
  });

  final List<PrepBlock> slide;
  final Map<int, PrepFrame> frames;
  final int step;
  final double scale;
  final bool editing;
  final int? selected;
  final ValueChanged<int> onSelect;
  final void Function(int id, PrepFrame frame) onDrag;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth, h = c.maxHeight;
          return Stack(
            children: [
              if (editing)
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: _line),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              // Vybraný blok navrchu (kdyby se bloky překrývaly).
              for (final b in [
                ...slide.where((b) => b.id != selected),
                ...slide.where((b) => b.id == selected),
              ])
                if (frames[b.id] case final f?)
                  Positioned(
                    key: ValueKey(b.id),
                    left: f.x * w,
                    top: f.y * h,
                    width: f.w * w,
                    height: f.h * h,
                    child: _FreeBox(
                      block: b,
                      frame: f,
                      area: Size(w, h),
                      scale: scale,
                      visible: editing || b.step <= step,
                      editing: editing,
                      selected: selected == b.id,
                      onSelect: () => onSelect(b.id),
                      onDrag: (nf) => onDrag(b.id, nf),
                      onDragEnd: onDragEnd,
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}

class _FreeBox extends StatelessWidget {
  const _FreeBox({
    required this.block,
    required this.frame,
    required this.area,
    required this.scale,
    required this.visible,
    required this.editing,
    required this.selected,
    required this.onSelect,
    required this.onDrag,
    required this.onDragEnd,
  });

  final PrepBlock block;
  final PrepFrame frame;
  final Size area;
  final double scale;
  final bool visible, editing, selected;
  final VoidCallback onSelect;
  final ValueChanged<PrepFrame> onDrag;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFE8C77E);
    final content = ClipRect(
      child: SingleChildScrollView(
        physics: editing ? const NeverScrollableScrollPhysics() : null,
        padding: const EdgeInsets.all(10),
        child: _BlockSlide(block: block, scale: scale * block.zoom * 0.8),
      ),
    );
    final box = AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: visible ? 1 : 0,
      child: content,
    );
    if (!editing) return box;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onSelect,
      onPanStart: (_) => onSelect(),
      onPanUpdate: (d) => onDrag(
        frame.moved(d.delta.dx / area.width, d.delta.dy / area.height),
      ),
      onPanEnd: (_) => onDragEnd(),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: selected
                    ? gold.withValues(alpha: 0.08)
                    : Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: selected ? gold : _ink.withValues(alpha: 0.3),
                  width: selected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned.fill(child: content),
          // Na kolikáté klepnutí se blok objeví.
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: block.step == 0 ? _ink.withValues(alpha: 0.18) : gold,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                block.step == 0 ? S.prepStepNow : S.prepStepAt(block.step),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: block.step == 0 ? _ink : const Color(0xFF15120F),
                ),
              ),
            ),
          ),
          // Úchyt pro změnu velikosti.
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (_) => onSelect(),
              onPanUpdate: (d) => onDrag(
                frame.resized(
                  d.delta.dx / area.width,
                  d.delta.dy / area.height,
                ),
              ),
              onPanEnd: (_) => onDragEnd(),
              child: Container(
                width: 30,
                height: 30,
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.open_in_full,
                  size: 18,
                  color: selected ? gold : _ink.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({
    required this.title,
    this.subtitle,
    this.body,
    required this.scale,
    this.big = false,
    this.color = const Color(0xFFE8C77E),
    this.marks = const [],
  });

  final String title;
  final String? subtitle;
  final String? body;
  final double scale;
  final bool big;
  final Color color;

  /// Slova textu, která se zvýrazní (bez diakritiky, malými písmeny).
  final List<String> marks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: big ? _ink : color,
            fontSize: (big ? 40 : 22) * scale,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        if (subtitle case final s?)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              s,
              style: TextStyle(color: color, fontSize: 20 * scale),
            ),
          ),
        if (body case final b?)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text.rich(
              TextSpan(children: markedSpans(b, marks)),
              style: TextStyle(
                color: _ink,
                fontSize: 28 * scale,
                height: 1.45,
                fontFamily: appFontFamily,
              ),
            ),
          ),
      ],
    );
  }
}

final _wordRe = RegExp(r'[\p{L}\p{N}]+', unicode: true);

/// Porovnávací tvar slova pro zvýraznění (malými písmeny, bez diakritiky).
String markKey(String word) => foldCzech(word.toLowerCase());

/// Text rozdělený na úseky, zvýrazněná slova zlatě a tučně.
List<TextSpan> markedSpans(
  String text,
  List<String> marks, {
  TextStyle style = const TextStyle(
    color: Color(0xFFF2C95C),
    fontWeight: FontWeight.w700,
    backgroundColor: Color(0x33E8C77E),
  ),
}) {
  if (marks.isEmpty) return [TextSpan(text: text)];
  final set = marks.toSet();
  final out = <TextSpan>[];
  var last = 0;
  for (final m in _wordRe.allMatches(text)) {
    if (!set.contains(markKey(m[0]!))) continue;
    if (m.start > last) out.add(TextSpan(text: text.substring(last, m.start)));
    out.add(TextSpan(text: m[0], style: style));
    last = m.end;
  }
  if (last < text.length) out.add(TextSpan(text: text.substring(last)));
  return out;
}

/// Jedna obrazovka kázání v automatickém rozvržení: jeden blok, nebo
/// několik – pod sebou nebo ve dvou sloupcích (menším písmem, oddělené
/// tenkou čarou). Bloky, které ještě nepřišly na řadu, mají místo
/// připravené, ale nejsou vidět.
class _GroupSlide extends StatelessWidget {
  const _GroupSlide({
    required this.blocks,
    required this.layout,
    required this.scale,
    required this.step,
  });

  final List<PrepBlock> blocks;
  final PrepLayout layout;
  final double scale;
  final int step;

  @override
  Widget build(BuildContext context) {
    final rows = prepRows(blocks, layout);
    final wide = MediaQuery.sizeOf(context).width >= 520;
    // Výška obsahu v blocích (sloupce vedle sebe se nesčítají).
    final tall = rows.fold<int>(
      0,
      (n, r) =>
          n +
          (wide && r.right.isNotEmpty && r.left.isNotEmpty
              ? math.max(r.left.length, r.right.length)
              : r.left.length + r.right.length),
    );
    final s = scale * (tall <= 1 ? 1 : (tall == 2 ? 0.85 : 0.75));
    Widget one(PrepBlock b) => AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: b.step <= step ? 1 : 0,
      child: _BlockSlide(block: b, scale: s * b.zoom),
    );
    Widget column(List<PrepBlock> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, b) in list.indexed) ...[
          if (i > 0)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 22),
              color: _line,
            ),
          one(b),
        ],
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (i, r) in rows.indexed) ...[
          if (i > 0)
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(vertical: 22),
              color: _line,
            ),
          if (wide && r.left.isNotEmpty && r.right.isNotEmpty)
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: column(r.left)),
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    color: _line,
                  ),
                  Expanded(child: column(r.right)),
                ],
              ),
            )
          else
            column([...r.left, ...r.right]),
        ],
      ],
    );
  }
}

class _BlockSlide extends ConsumerWidget {
  const _BlockSlide({required this.block, required this.scale});

  final PrepBlock block;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = block;
    final color = Color.lerp(_blockColor(b.kind), Colors.white, 0.35)!;
    if (b.passage case final p?) {
      final translations = prepTranslations(ref, b);
      Widget one(Translation t) {
        final verses = ref.watch(passageTextProvider((t.id, p))).value;
        return _Slide(
          title: '${passageLabel(ref, p)} · ${t.abbreviation}',
          body: verses?.map((v) => v.text.replaceAll('\n', ' ')).join(' '),
          scale: scale,
          color: color,
          marks: b.marks,
        );
      }

      final comment = b.text.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                b.text,
                style: TextStyle(
                  color: _ink.withValues(alpha: 0.85),
                  fontSize: 22 * scale,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
      return LayoutBuilder(
        builder: (context, c) {
          final side =
              b.parallel &&
              translations.length > 1 &&
              c.maxWidth >= 300.0 * translations.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (side)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (i, t) in translations.indexed) ...[
                        if (i > 0)
                          Container(
                            width: 1,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            color: _line,
                          ),
                        Expanded(child: one(t)),
                      ],
                    ],
                  ),
                )
              else
                for (final (i, t) in translations.indexed) ...[
                  if (i > 0) const SizedBox(height: 18),
                  one(t),
                ],
              ?comment,
            ],
          );
        },
      );
    }
    if (b.kind == PrepBlockKind.heading) {
      return _Slide(
        title: b.text,
        body: b.body.isEmpty ? null : b.body,
        scale: scale,
        big: true,
        color: color,
      );
    }
    return _Slide(
      title: b.kind.label,
      body: b.text,
      scale: scale,
      color: color,
    );
  }
}
