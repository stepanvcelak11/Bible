import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../guide/presentation/whats_new_sheet.dart';

import '../../core/l10n/strings_cs.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/readable_width.dart';
import '../../domain/entities/bible_entities.dart';
import '../../domain/services/versification.dart';
import '../journal/presentation/journal_screen.dart';
import '../study/presentation/study_hub_screen.dart';
import '../reader/application/reader_state.dart';
import '../reader/application/reading_position_controller.dart';
import '../reader/presentation/reader_screen.dart';
import '../search/presentation/search_screen.dart';
import '../today/presentation/today_screen.dart';
import '../translations/application/translation_controller.dart';

enum AppTab { today, bible, study, search, journal }

class ShellTabController extends Notifier<AppTab> {
  @override
  AppTab build() =>
      ref.read(appPreferencesProvider).splitView ? AppTab.study : AppTab.today;

  /// V rozdělené obrazovce je Bible vidět stále – vybírá se jen sekce
  /// ve druhém panelu.
  void select(AppTab tab) {
    if (tab == AppTab.bible && ref.read(splitViewProvider)) return;
    state = tab;
  }
}

/// Rozdělená obrazovka: Bible a vedle (na telefonu pod ní) další sekce.
class SplitViewController extends Notifier<bool> {
  @override
  bool build() => ref.read(appPreferencesProvider).splitView;

  void set(bool value) {
    if (value == state) return;
    ref.read(appPreferencesProvider).setSplitView(value);
    state = value;
    final tabs = ref.read(shellTabProvider.notifier);
    if (value && ref.read(shellTabProvider) == AppTab.bible) {
      tabs.select(AppTab.study);
    } else if (!value) {
      tabs.select(AppTab.bible);
    }
  }

  void toggle() => set(!state);
}

final splitViewProvider = NotifierProvider<SplitViewController, bool>(
  SplitViewController.new,
);

final shellTabProvider = NotifierProvider<ShellTabController, AppTab>(
  ShellTabController.new,
);

/// Otevře čtečku na daném verši (z hledání, deníku, map, souvislostí…).
///
/// [from] = číslování, ve kterém je [target] zapsaný; výchozí je kanonické
/// (hebrejské – ČEP, B21, ČSP). Čtečka ho převede na číslování hlavního
/// překladu (BKR čísluje např. žalmy jinak).
void openReaderAt(
  BuildContext context,
  WidgetRef ref,
  VerseRef target, {
  VerseScheme from = VerseScheme.hebrew,
}) {
  final primaryId = ref.read(translationControllerProvider).primaryId;
  target = Versification.convert(target, from, schemeOf(primaryId));
  ref.read(readingPositionProvider.notifier).jumpTo(target);
  ref.read(controlsVisibleProvider.notifier).show();
  if (ref.read(splitViewProvider)) {
    // Bible je vidět vedle – stránka ve druhém panelu zůstane otevřená,
    // zavřou se jen vyskakovací okna a listy.
    Navigator.of(context).popUntil((route) => route is! PopupRoute);
    return;
  }
  ref.read(shellTabProvider.notifier).select(AppTab.bible);
  Navigator.of(context).popUntil((route) => route.isFirst);
}

/// Hlavní obrazovka: pět sekcí a plovoucí navigace dole.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  /// Sekce se sestaví až při první návštěvě (pak zůstávají v paměti).
  final _visited = <AppTab>{};

  /// Navigace druhého panelu rozdělené obrazovky (stránky ze Studia se
  /// otevírají v něm, Bible zůstává vedle).
  final _paneNavigator = GlobalKey<NavigatorState>();
  late double _ratio = ref.read(appPreferencesProvider).splitRatio;

  @override
  void initState() {
    super.initState();
    // Po velké aktualizaci jednou ukázat přehled novinek.
    final prefs = ref.read(appPreferencesProvider);
    if (prefs.whatsNewSeen < whatsNewVersion) {
      prefs.setWhatsNewSeen(whatsNewVersion);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showWhatsNew(context);
      });
    }
  }

  Widget _page(AppTab tab) => switch (tab) {
    AppTab.today => const ReadableWidth(maxWidth: 1240, child: TodayScreen()),
    AppTab.bible => const ReaderScreen(),
    AppTab.study => const StudyHubScreen(),
    AppTab.search => const ReadableWidth(maxWidth: 960, child: SearchScreen()),
    AppTab.journal => const ReadableWidth(
      maxWidth: 960,
      child: JournalScreen(),
    ),
  };

  void _select(AppTab t) {
    HapticFeedback.selectionClick();
    if (ref.read(splitViewProvider)) {
      if (t == AppTab.bible) {
        // „Bible“ v rozdělené obrazovce = Bible přes celou obrazovku.
        ref.read(splitViewProvider.notifier).set(false);
        return;
      }
      _paneNavigator.currentState?.popUntil((r) => r.isFirst);
    }
    if (t == AppTab.bible) {
      ref.read(controlsVisibleProvider.notifier).show();
    }
    ref.read(shellTabProvider.notifier).select(t);
  }

  /// Stránky sekcí kromě Bible (druhý panel rozdělené obrazovky).
  Widget _panePages() => Consumer(
    builder: (context, ref, _) {
      final tab = ref.watch(shellTabProvider);
      return Stack(
        children: [
          for (final t in AppTab.values)
            if (t != AppTab.bible && _visited.contains(t))
              Offstage(
                offstage: t != tab,
                child: TickerMode(enabled: t == tab, child: _page(t)),
              ),
        ],
      );
    },
  );

  /// Panel s vlastními rozměry: obrazovky v něm se chovají jako na
  /// displeji velikosti panelu (telefon vs. tablet).
  Widget _pane(
    BuildContext context,
    Size size, {
    required Widget child,
    bool removeTop = false,
    bool removeBottom = false,
    bool removeLeft = false,
    bool removeRight = false,
  }) {
    final mq = MediaQuery.of(context);
    EdgeInsets cut(EdgeInsets e) => e.copyWith(
      top: removeTop ? 0 : null,
      bottom: removeBottom ? 0 : null,
      left: removeLeft ? 0 : null,
      right: removeRight ? 0 : null,
    );
    return SizedBox.fromSize(
      size: size,
      child: MediaQuery(
        data: mq.copyWith(
          size: size,
          padding: cut(mq.padding),
          viewPadding: cut(mq.viewPadding),
        ),
        child: ClipRect(child: child),
      ),
    );
  }

  Widget _splitBody(BuildContext context, {required bool sideBySide}) {
    return LayoutBuilder(
      builder: (context, c) {
        const handle = 20.0;
        final total = sideBySide ? c.maxWidth : c.maxHeight;
        final first = ((total - handle) * _ratio).roundToDouble();
        final second = total - handle - first;
        // Na tabletu je druhý panel vlevo (u boční navigace) a Bible
        // vpravo, na telefonu Bible nahoře.
        final reader = _pane(
          context,
          sideBySide ? Size(first, c.maxHeight) : Size(c.maxWidth, first),
          removeLeft: sideBySide,
          removeBottom: !sideBySide,
          child: const ReaderScreen(),
        );
        final pane = _pane(
          context,
          sideBySide ? Size(second, c.maxHeight) : Size(c.maxWidth, second),
          removeRight: sideBySide,
          removeTop: !sideBySide,
          child: HeroControllerScope.none(
            child: Navigator(
              key: _paneNavigator,
              onGenerateRoute: (_) => PageRouteBuilder<void>(
                pageBuilder: (_, _, _) => _panePages(),
              ),
            ),
          ),
        );
        final divider = _SplitHandle(
          vertical: sideBySide,
          onDrag: (delta) => setState(() {
            // Vodorovně leží Bible vpravo – tažení doleva ji zvětší.
            final d = sideBySide ? -delta : delta;
            _ratio = (_ratio + d / (total - handle)).clamp(0.3, 0.7);
          }),
          onDragEnd: () =>
              ref.read(appPreferencesProvider).setSplitRatio(_ratio),
          onClose: () => ref.read(splitViewProvider.notifier).set(false),
        );
        return sideBySide
            ? Row(children: [pane, divider, reader])
            : Column(children: [reader, divider, pane]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(shellTabProvider);
    final split = ref.watch(splitViewProvider);
    _visited.add(tab);
    if (split) _visited.add(AppTab.bible);
    final controlsVisible = ref.watch(controlsVisibleProvider);
    final hasSelection = ref.watch(
      verseSelectionProvider.select((s) => !s.isEmpty),
    );
    final hideNav =
        !split && tab == AppTab.bible && (!controlsVisible || hasSelection);
    final pages = Stack(
      children: [
        for (final t in AppTab.values)
          if (_visited.contains(t))
            Offstage(
              offstage: t != tab,
              child: TickerMode(enabled: t == tab, child: _page(t)),
            ),
      ],
    );

    // Tablet / telefon na šířku: navigace v boční liště.
    if (isWide(context)) {
      final hideRail = !split && tab == AppTab.bible && !controlsVisible;
      return Scaffold(
        body: Row(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.centerLeft,
              child: hideRail
                  ? const SizedBox(height: double.infinity)
                  : _SideRail(
                      current: tab,
                      split: split,
                      onSelect: _select,
                      onToggleSplit: ref
                          .read(splitViewProvider.notifier)
                          .toggle,
                    ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeLeft: !hideRail,
                child: split
                    ? Builder(
                        builder: (context) =>
                            _splitBody(context, sideBySide: true),
                      )
                    : pages,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: split
                ? Padding(
                    // Místo pro plovoucí navigaci pod druhým panelem.
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom + 62,
                    ),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      child: Builder(
                        builder: (context) =>
                            _splitBody(context, sideBySide: false),
                      ),
                    ),
                  )
                : pages,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: hideNav ? const Offset(0, 1.4) : Offset.zero,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: _NavBar(current: tab, split: split, onSelect: _select),
            ),
          ),
        ],
      ),
    );
  }
}

const _navItems = [
  (AppTab.today, Icons.wb_sunny_outlined, Icons.wb_sunny, S.tabToday),
  (AppTab.bible, Icons.menu_book_outlined, Icons.menu_book, S.tabBible),
  (AppTab.study, Icons.school_outlined, Icons.school, S.tabStudy),
  (AppTab.search, Icons.search, Icons.search, S.tabSearch),
  (AppTab.journal, Icons.bookmarks_outlined, Icons.bookmarks, S.tabJournal),
];

/// Boční navigace pro široký displej.
class _SideRail extends StatelessWidget {
  const _SideRail({
    required this.current,
    required this.split,
    required this.onSelect,
    required this.onToggleSplit,
  });

  final AppTab current;
  final bool split;
  final ValueChanged<AppTab> onSelect;
  final VoidCallback onToggleSplit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final insets = MediaQuery.paddingOf(context);
    return Container(
      width: 88 + insets.left,
      padding: EdgeInsets.only(
        left: insets.left,
        top: insets.top + 16,
        bottom: insets.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.72),
        border: Border(right: BorderSide(color: palette.cardBorder)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.heroStart, palette.heroEnd],
              ),
            ),
            child: Icon(Icons.auto_stories, color: palette.onHero, size: 22),
          ),
          for (final (tab, icon, activeIcon, label) in _navItems)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                height: 62,
                child: _NavItem(
                  icon: tab == current ? activeIcon : icon,
                  label: label,
                  selected: tab == current || (split && tab == AppTab.bible),
                  onTap: () => onSelect(tab),
                ),
              ),
            ),
          const Spacer(),
          SizedBox(
            height: 62,
            child: _NavItem(
              icon: split ? Icons.fullscreen : Icons.vertical_split_outlined,
              label: split ? S.splitOff : S.splitOn,
              selected: false,
              onTap: onToggleSplit,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.current,
    required this.onSelect,
    this.split = false,
  });

  final AppTab current;
  final bool split;
  final ValueChanged<AppTab> onSelect;

  static const _items = _navItems;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        14,
        0,
        14,
        bottom > 0 ? bottom : (split ? 6 : 12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: split ? 52 : 64,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow.withValues(
                alpha: 0.86,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: palette.cardBorder),
            ),
            child: Row(
              children: [
                for (final (tab, icon, activeIcon, label) in _items)
                  Expanded(
                    child: _NavItem(
                      icon: tab == current ? activeIcon : icon,
                      label: label,
                      selected:
                          tab == current || (split && tab == AppTab.bible),
                      onTap: () => onSelect(tab),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = selected ? theme.colorScheme.primary : palette.muted;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? palette.gold.withValues(alpha: 0.16)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Předěl rozdělené obrazovky: tažením se mění poměr, křížek rozdělení
/// zruší.
class _SplitHandle extends StatelessWidget {
  const _SplitHandle({
    required this.vertical,
    required this.onDrag,
    required this.onDragEnd,
    required this.onClose,
  });

  /// Svislý předěl (panely vedle sebe).
  final bool vertical;
  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final theme = Theme.of(context);
    final grip = Container(
      width: vertical ? 4 : 44,
      height: vertical ? 44 : 4,
      decoration: BoxDecoration(
        color: palette.muted.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
    return MouseRegion(
      cursor: vertical
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: vertical ? (d) => onDrag(d.delta.dx) : null,
        onHorizontalDragEnd: vertical ? (_) => onDragEnd() : null,
        onVerticalDragUpdate: vertical ? null : (d) => onDrag(d.delta.dy),
        onVerticalDragEnd: vertical ? null : (_) => onDragEnd(),
        child: Container(
          width: vertical ? 20 : double.infinity,
          height: vertical ? double.infinity : 20,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            border: vertical
                ? Border.symmetric(
                    vertical: BorderSide(color: palette.cardBorder),
                  )
                : Border.symmetric(
                    horizontal: BorderSide(color: palette.cardBorder),
                  ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              grip,
              // Křížek na konci předělu – mimo text obou panelů.
              Positioned(
                right: vertical ? null : 12,
                top: vertical ? 12 : null,
                child: Material(
                  color: theme.colorScheme.surfaceContainerHigh,
                  shape: CircleBorder(
                    side: BorderSide(color: palette.cardBorder),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onClose,
                    child: Tooltip(
                      message: S.splitOff,
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: Icon(
                          Icons.close,
                          size: 13,
                          color: palette.muted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
