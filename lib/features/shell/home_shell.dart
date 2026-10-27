import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings_cs.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/bible_entities.dart';
import '../journal/presentation/journal_screen.dart';
import '../maps/presentation/maps_screen.dart';
import '../reader/application/reader_state.dart';
import '../reader/application/reading_position_controller.dart';
import '../reader/presentation/reader_screen.dart';
import '../search/presentation/search_screen.dart';
import '../today/presentation/today_screen.dart';

enum AppTab { today, bible, search, maps, journal }

class ShellTabController extends Notifier<AppTab> {
  @override
  AppTab build() => AppTab.today;

  void select(AppTab tab) => state = tab;
}

final shellTabProvider = NotifierProvider<ShellTabController, AppTab>(
  ShellTabController.new,
);

/// Otevře čtečku na daném verši (z hledání, deníku, map, souvislostí…).
void openReaderAt(BuildContext context, WidgetRef ref, VerseRef target) {
  ref.read(readingPositionProvider.notifier).jumpTo(target);
  ref.read(controlsVisibleProvider.notifier).show();
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

  Widget _page(AppTab tab) => switch (tab) {
    AppTab.today => const TodayScreen(),
    AppTab.bible => const ReaderScreen(),
    AppTab.search => const SearchScreen(),
    AppTab.maps => const MapsScreen(),
    AppTab.journal => const JournalScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final tab = ref.watch(shellTabProvider);
    _visited.add(tab);
    final controlsVisible = ref.watch(controlsVisibleProvider);
    final hasSelection = ref.watch(
      verseSelectionProvider.select((s) => !s.isEmpty),
    );
    final hideNav = tab == AppTab.bible && (!controlsVisible || hasSelection);

    return Scaffold(
      body: Stack(
        children: [
          for (final t in AppTab.values)
            if (_visited.contains(t))
              Offstage(
                offstage: t != tab,
                child: TickerMode(enabled: t == tab, child: _page(t)),
              ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSlide(
              offset: hideNav ? const Offset(0, 1.4) : Offset.zero,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: _NavBar(
                current: tab,
                onSelect: (t) {
                  HapticFeedback.selectionClick();
                  if (t == AppTab.bible) {
                    ref.read(controlsVisibleProvider.notifier).show();
                  }
                  ref.read(shellTabProvider.notifier).select(t);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.current, required this.onSelect});

  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  static const _items = [
    (AppTab.today, Icons.wb_sunny_outlined, Icons.wb_sunny, S.tabToday),
    (AppTab.bible, Icons.menu_book_outlined, Icons.menu_book, S.tabBible),
    (AppTab.search, Icons.search, Icons.search, S.tabSearch),
    (AppTab.maps, Icons.map_outlined, Icons.map, S.tabMaps),
    (AppTab.journal, Icons.bookmarks_outlined, Icons.bookmarks, S.tabJournal),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(14, 0, 14, bottom > 0 ? bottom : 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 64,
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
                      selected: tab == current,
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
