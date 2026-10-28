import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

Future<void> openTable(BuildContext context, ContentTable table) =>
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => TableScreen(table: table)));

/// Seznam tabulek a přehledů.
class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tablesProvider).value;
    final theme = Theme.of(context);
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.tables)),
        body: tables == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.paddingOf(context).bottom + 32,
                ),
                children: [
                  Card(
                    child: Column(
                      children: [
                        for (final (i, t) in tables.indexed) ...[
                          if (i > 0) const Divider(height: 1, indent: 56),
                          ListTile(
                            leading: Icon(
                              Icons.table_chart_outlined,
                              color: AppPalette.of(context).gold,
                            ),
                            title: Text(
                              t.title,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              t.intro,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => openTable(context, t),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Jedna tabulka: na tabletu jako tabulka, na telefonu jako karty řádků.
class TableScreen extends StatelessWidget {
  const TableScreen({super.key, required this.table});

  final ContentTable table;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);

    Widget cell(TableCellData c, {TextStyle? style}) => c.passage == null
        ? Text(c.text, style: style)
        : InkWell(
            onTap: () => showPassageSheet(context, c.passage!),
            child: Text(
              c.text,
              style: (style ?? theme.textTheme.bodyMedium)?.copyWith(
                color: palette.gold,
                decoration: TextDecoration.underline,
                decorationColor: palette.gold.withValues(alpha: 0.5),
              ),
            ),
          );

    return ReadableWidth(
      maxWidth: 960,
      child: Scaffold(
        appBar: AppBar(title: Text(table.title)),
        body: LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 640;
            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                MediaQuery.paddingOf(context).bottom + 32,
              ),
              children: [
                Text(
                  table.intro,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                  ),
                ),
                const SizedBox(height: 14),
                if (wide)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder(
                          horizontalInside: BorderSide(
                            color: palette.cardBorder,
                          ),
                        ),
                        children: [
                          TableRow(
                            children: [
                              for (final h in table.columns)
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    h,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          for (final row in table.rows)
                            TableRow(
                              children: [
                                for (final (i, c) in row.indexed)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: cell(
                                      c,
                                      style: i == 0
                                          ? theme.textTheme.titleSmall
                                          : theme.textTheme.bodyMedium,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  for (final row in table.rows)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            cell(row.first, style: theme.textTheme.titleMedium),
                            for (var i = 1; i < row.length; i++)
                              if (row[i].text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 110,
                                        child: Text(
                                          table.columns[i],
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(color: palette.muted),
                                        ),
                                      ),
                                      Expanded(child: cell(row[i])),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                if (table.note.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      table.note,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: palette.muted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
