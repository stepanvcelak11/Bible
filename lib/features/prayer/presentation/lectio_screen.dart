import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../content/application/content_providers.dart';
import '../../settings/application/reader_settings_controller.dart';
import '../../translations/application/translation_controller.dart';
import '../application/prayer_controller.dart';

/// Úryvky vhodné k lectio divina (kanonické číslování).
const lectioPassages = [
  (Passage(19, 23, 0, 0), 'Hospodin je můj pastýř'),
  (Passage(40, 11, 28, 30), 'Pojďte ke mně, kdo jste unavení'),
  (Passage(23, 43, 1, 7), 'Neboj se, vykoupil jsem tě'),
  (Passage(43, 15, 1, 11), 'Zůstaňte ve mně'),
  (Passage(42, 15, 11, 24), 'Otec běží naproti'),
  (Passage(19, 139, 1, 12), 'Zkoumáš mě a znáš mě'),
  (Passage(42, 10, 38, 42), 'Marie u Ježíšových nohou'),
  (Passage(45, 8, 31, 39), 'Nic nás neodloučí od Boží lásky'),
  (Passage(50, 4, 4, 9), 'Radujte se a nemějte starost'),
  (Passage(41, 4, 35, 41), 'Utišení bouře'),
  (Passage(43, 21, 15, 19), 'Miluješ mě?'),
  (Passage(19, 131, 0, 0), 'Ztišil jsem svou duši'),
];

void openLectio(BuildContext context, {Passage? passage}) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => LectioScreen(passage: passage)));

/// Lectio divina s průvodcem: čti – rozjímej – modli se – ztiš se.
/// Na konci se dá rozjímání uložit do deníku jako zamyšlení.
class LectioScreen extends ConsumerStatefulWidget {
  const LectioScreen({super.key, this.passage});

  final Passage? passage;

  @override
  ConsumerState<LectioScreen> createState() => _LectioScreenState();
}

class _LectioScreenState extends ConsumerState<LectioScreen> {
  final _page = PageController();
  final _meditation = TextEditingController();
  final _prayer = TextEditingController();
  Passage? _passage;
  int _step = 0;
  int? _word;
  bool _addPrayer = false;

  static const _steps = 5; // výběr + 4 kroky

  @override
  void initState() {
    super.initState();
    _passage = widget.passage;
    if (_passage != null) _step = 1;
  }

  @override
  void dispose() {
    _page.dispose();
    _meditation.dispose();
    _prayer.dispose();
    super.dispose();
  }

  void _go(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _page.animateToPage(
      step - (widget.passage == null ? 0 : 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _save(List<Verse> verses) async {
    final p = _passage!;
    final books = ref.read(booksProvider);
    final label = p.label(books[p.bookId - 1].abbreviation);
    final word = _word == null
        ? null
        : verses.where((v) => v.number == _word).firstOrNull;
    final body = [
      '${S.reflectionPrefix}${S.lectio} – $label',
      if (word != null) '${S.lectioQ1}\n(v. ${word.number}) ${word.text}',
      if (_meditation.text.trim().isNotEmpty)
        '${S.lectioQ2}\n${_meditation.text.trim()}',
      if (_prayer.text.trim().isNotEmpty)
        '${S.lectioQ3}\n${_prayer.text.trim()}',
    ].join('\n\n');
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    await ref
        .read(userDataRepositoryProvider)
        .saveNote(ref: word?.ref ?? p.start, body: body);
    if (_addPrayer && _prayer.text.trim().isNotEmpty) {
      ref.read(prayerProvider.notifier).add(_prayer.text.trim());
    }
    navigator.pop();
    messenger.showSnackBar(const SnackBar(content: Text(S.reflectionSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final verses = _passage == null
        ? null
        : ref.watch(passageTextProvider((translationId, _passage!))).value;
    final pages = [
      if (widget.passage == null)
        _Choose(
          onPick: (p) {
            setState(() {
              _passage = p;
              _word = null;
            });
            _go(1);
          },
        ),
      _StepPage(
        index: 1,
        title: S.lectioRead,
        latin: 'Lectio',
        hint: S.lectioReadHint,
        child: _PassageText(
          verses: verses,
          selected: _word,
          onTap: (n) => setState(() => _word = _word == n ? null : n),
        ),
        next: () => _go(2),
      ),
      _StepPage(
        index: 2,
        title: S.lectioMeditate,
        latin: 'Meditatio',
        hint: S.lectioMeditateHint,
        next: () => _go(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_word != null && verses != null)
              _Chosen(
                text:
                    verses.where((v) => v.number == _word).firstOrNull?.text ??
                    '',
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _meditation,
              minLines: 3,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: S.lectioQ2,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      _StepPage(
        index: 3,
        title: S.lectioPray,
        latin: 'Oratio',
        hint: S.lectioPrayHint,
        next: () => _go(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _prayer,
              minLines: 4,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: S.lectioQ3,
                border: OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _addPrayer,
              onChanged: (v) => setState(() => _addPrayer = v ?? false),
              title: const Text(S.lectioAddPrayer),
            ),
          ],
        ),
      ),
      _StepPage(
        index: 4,
        title: S.lectioRest,
        latin: 'Contemplatio',
        hint: S.lectioRestHint,
        nextLabel: S.lectioSave,
        next: verses == null ? null : () => _save(verses),
        secondary: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(S.lectioFinish),
        ),
        child: _Breathing(active: _step == 4),
      ),
    ];
    final first = widget.passage == null ? 0 : 1;
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.lectio),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: (_step - first + 1) / (_steps - first)),
              duration: const Duration(milliseconds: 380),
              builder: (context, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 3,
                color: AppPalette.of(context).gold,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ),
        body: PopScope(
          canPop: _step <= first,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _go(_step - 1);
          },
          child: PageView(
            controller: _page,
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        ),
      ),
    );
  }
}

/// Výběr úryvku (a krátké vysvětlení, co lectio divina je).
class _Choose extends ConsumerWidget {
  const _Choose({required this.onPick});

  final void Function(Passage) onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final today = verseOfDay(DateTime.now());
    final items = [
      (
        Passage(today.bookId, today.chapter, today.verse, today.verse),
        S.verseOfDay,
      ),
      ...lectioPassages,
    ];
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.paddingOf(context).bottom + 24,
      ),
      children: [
        Text(S.lectioIntro, style: theme.textTheme.bodyLarge),
        const SizedBox(height: 16),
        for (final (i, (title, latin, icon)) in [
          (S.lectioRead, 'Lectio', Icons.menu_book_outlined),
          (S.lectioMeditate, 'Meditatio', Icons.psychology_alt_outlined),
          (S.lectioPray, 'Oratio', Icons.volunteer_activism_outlined),
          (S.lectioRest, 'Contemplatio', Icons.spa_outlined),
        ].indexed)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: palette.gold.withValues(alpha: 0.14),
              child: Icon(icon, size: 18, color: palette.gold),
            ),
            title: Text('${i + 1}. $title'),
            subtitle: Text(latin),
          ),
        const SizedBox(height: 12),
        Text(
          S.lectioChoose,
          style: theme.textTheme.labelLarge?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 8),
        for (final (p, title) in items)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(title),
              subtitle: Text(p.label(books[p.bookId - 1].abbreviation)),
              trailing: Icon(Icons.chevron_right, color: palette.muted),
              onTap: () => onPick(p),
            ),
          ),
      ],
    );
  }
}

class _StepPage extends StatelessWidget {
  const _StepPage({
    required this.index,
    required this.title,
    required this.latin,
    required this.hint,
    required this.child,
    required this.next,
    this.nextLabel,
    this.secondary,
  });

  final int index;
  final String title;
  final String latin;
  final String hint;
  final Widget child;
  final VoidCallback? next;
  final String? nextLabel;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            children: [
              Text(
                '$index / 4 · ${latin.toUpperCase()}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.gold,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                hint,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: palette.muted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              child,
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Row(
              children: [
                ?secondary,
                const Spacer(),
                FilledButton.icon(
                  onPressed: next,
                  icon: Icon(
                    nextLabel == null
                        ? Icons.arrow_forward
                        : Icons.bookmark_add,
                  ),
                  label: Text(nextLabel ?? S.lectioNext),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Text úryvku; klepnutím se vybere verš, který čtenáře zastavil.
class _PassageText extends ConsumerWidget {
  const _PassageText({
    required this.verses,
    required this.selected,
    required this.onTap,
  });

  final List<Verse>? verses;
  final int? selected;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = verses;
    if (list == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final settings = ref.watch(readerSettingsProvider);
    final colors = ReaderColors.of(context);
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final v in list)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onTap(v.number),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: v.number == selected
                    ? palette.gold.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${v.number} ',
                      style: TextStyle(
                        fontSize: settings.fontSize * 0.6,
                        color: colors.verseNumber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: v.text),
                  ],
                ),
                style: TextStyle(
                  fontFamily: settings.readingFont.family,
                  fontSize: settings.fontSize,
                  height: settings.lineHeight,
                  color: colors.text,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Chosen extends StatelessWidget {
  const _Chosen({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: palette.gold, width: 3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: appFontFamily,
          fontSize: 18,
          height: 1.5,
          fontStyle: FontStyle.italic,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// Ztišení: dýchající kruh (4 s nádech, 6 s výdech) a odpočet dvou minut.
class _Breathing extends StatefulWidget {
  const _Breathing({required this.active});

  final bool active;

  @override
  State<_Breathing> createState() => _BreathingState();
}

class _BreathingState extends State<_Breathing>
    with SingleTickerProviderStateMixin {
  static const _total = Duration(minutes: 2);
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  Timer? _timer;
  Duration _left = _total;

  @override
  void initState() {
    super.initState();
    // Stránka kroku se poprvé sestaví, až když je krok aktivní.
    if (widget.active) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _start();
      });
    }
  }

  @override
  void didUpdateWidget(_Breathing old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) _start();
    if (!widget.active && old.active) _stop();
  }

  void _start() {
    if (!MediaQuery.disableAnimationsOf(context)) _c.repeat();
    _left = _total;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _left -= const Duration(seconds: 1));
      if (_left <= Duration.zero) _stop();
    });
  }

  void _stop() {
    _timer?.cancel();
    _c.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final done = _left <= Duration.zero;
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              // 0–0,4 nádech, 0,4–1 výdech.
              final t = _c.value;
              final k = t < 0.4
                  ? Curves.easeInOut.transform(t / 0.4)
                  : 1 - Curves.easeInOut.transform((t - 0.4) / 0.6);
              final size = 120 + 90 * k;
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size + 40,
                      height: size + 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            palette.gold.withValues(alpha: 0.18),
                            palette.gold.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.gold.withValues(alpha: 0.12 + 0.12 * k),
                        border: Border.all(
                          color: palette.gold.withValues(alpha: 0.6),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        done
                            ? S.lectioAmen
                            : !_c.isAnimating
                            ? ''
                            : t < 0.4
                            ? S.lectioIn
                            : S.lectioOut,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: palette.gold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Text(
          done
              ? S.lectioRestDone
              : '${_left.inMinutes}:${(_left.inSeconds % 60).toString().padLeft(2, '0')}',
          style: theme.textTheme.titleLarge?.copyWith(
            color: palette.muted,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(
            S.lectioRestPrayer,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: appFontFamily,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
