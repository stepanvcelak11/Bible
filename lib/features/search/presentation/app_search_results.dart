import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../application/app_search.dart';
import 'app_search_index.dart';

/// Výsledky chytrého hledání v celé aplikaci: nejlepší shoda nahoře,
/// pod ní skupiny (funkce, mapy, témata, kurzy, zamyšlení…).
/// Výsledky chytrého hledání pro dotaz (prázdné, dokud se index načítá).
final appHitsProvider = Provider.family<List<AppHit>, String>((ref, query) {
  final items = ref.watch(appSearchIndexProvider).value;
  return items == null ? const [] : searchApp(items, query);
});

class AppSearchResults extends ConsumerStatefulWidget {
  const AppSearchResults({super.key, required this.query, this.onOpen});

  final String query;

  /// Zavolá se před otevřením výsledku (uložení do nedávných hledání).
  final VoidCallback? onOpen;

  @override
  ConsumerState<AppSearchResults> createState() => _AppSearchResultsState();
}

class _AppSearchResultsState extends ConsumerState<AppSearchResults> {
  final _expanded = <AppHitKind>{};
  bool _allGroups = false;

  /// Rozbalené výsledky po skupinách (jinak jen pět nejlepších).
  bool _grouped = false;
  String _lastQuery = '';

  @override
  Widget build(BuildContext context) {
    if (widget.query != _lastQuery) {
      _lastQuery = widget.query;
      _expanded.clear();
      _allGroups = false;
      _grouped = false;
    }
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    // Index se načítá na pozadí – verše se mezitím ukazují normálně.
    final hits = ref.watch(appHitsProvider(widget.query));
    if (hits.isEmpty) return const SizedBox.shrink();

    void open(AppSearchItem item) {
      widget.onOpen?.call();
      item.open(context, ref);
    }

    // Skupiny v pořadí podle nejlepšího výsledku v nich.
    final groups = <AppHitKind, List<AppHit>>{};
    for (final h in hits.skip(1)) {
      (groups[h.item.kind] ??= []).add(h);
    }
    final kinds = groups.keys.toList();
    final shownKinds = _allGroups ? kinds : kinds.take(5).toList();
    final best = hits.first.item;

    Color colorOf(AppSearchItem i) =>
        i.color != null ? Color(i.color!) : palette.gold;

    Widget tile(AppSearchItem i, {bool label = false}) => InkWell(
      onTap: () => open(i),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colorOf(i).withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(i.icon, size: 20, color: colorOf(i)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          i.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                      if (label) ...[
                        const SizedBox(width: 8),
                        Text(
                          i.kind.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorOf(i),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (i.subtitle.isNotEmpty)
                    Text(
                      i.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: palette.muted, size: 20),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 10, 4, 6),
          child: Text(
            S.searchInApp,
            style: theme.textTheme.labelLarge?.copyWith(color: palette.muted),
          ),
        ),
        // Nejlepší výsledek.
        Material(
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => open(best),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [palette.heroStart, palette.heroEnd],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: palette.onHero.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(best.icon, color: palette.onHero),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.bestMatch} · ${best.kind.label}'.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: palette.onHero.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          best.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: palette.onHero,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (best.subtitle.isNotEmpty)
                          Text(
                            best.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: palette.onHero.withValues(alpha: 0.85),
                              height: 1.3,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: palette.onHero),
                ],
              ),
            ),
          ),
        ),
        if (!_grouped && hits.length > 1) ...[
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                for (final (i, h) in hits.skip(1).take(5).indexed) ...[
                  if (i > 0) const Divider(height: 1, indent: 62),
                  tile(h.item, label: true),
                ],
                if (hits.length > 6) ...[
                  const Divider(height: 1),
                  TextButton.icon(
                    onPressed: () => setState(() => _grouped = true),
                    icon: const Icon(Icons.expand_more),
                    label: Text(S.allAppResults(hits.length)),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (_grouped)
          for (final k in shownKinds) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      k.group.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: palette.muted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  Text(
                    '${groups[k]!.length}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  for (final (i, h)
                      in groups[k]!
                          .take(_expanded.contains(k) ? 30 : 3)
                          .indexed) ...[
                    if (i > 0) const Divider(height: 1, indent: 62),
                    tile(h.item),
                  ],
                  if (groups[k]!.length > 3 && !_expanded.contains(k)) ...[
                    const Divider(height: 1),
                    TextButton(
                      onPressed: () => setState(() => _expanded.add(k)),
                      child: Text(S.showMoreCount(groups[k]!.length - 3)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        if (_grouped && kinds.length > shownKinds.length)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _allGroups = true),
              icon: const Icon(Icons.expand_more),
              label: Text(S.moreResultKinds(kinds.length - shownKinds.length)),
            ),
          ),
      ],
    );
  }
}
