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

/// Ikona a barva tabulky podle obsahu.
(IconData, Color) tableStyle(String id) => switch (id) {
  'desatero' => (Icons.gavel_outlined, const Color(0xFFB0603A)),
  'svatky' => (Icons.celebration_outlined, const Color(0xFFC08A2E)),
  'kralove-juda' => (Icons.workspace_premium_outlined, const Color(0xFF8C6BA8)),
  'kralove-izrael' => (
    Icons.workspace_premium_outlined,
    const Color(0xFF5B6E8C),
  ),
  'proroci' => (Icons.campaign_outlined, const Color(0xFF8C4A6B)),
  'podobenstvi' => (Icons.lightbulb_outline, const Color(0xFF2E8B57)),
  'zazraky' => (Icons.auto_awesome_outlined, const Color(0xFFB0813B)),
  'ja-jsem' => (Icons.format_quote_outlined, const Color(0xFF3F7CAC)),
  'apostolove' => (Icons.groups_outlined, const Color(0xFF4E9A8A)),
  'kmeny' => (Icons.account_tree_outlined, const Color(0xFF5B7A3A)),
  'pavlovy-listy' => (Icons.mail_outline, const Color(0xFF4E8A9A)),
  'svaty-tyden' => (Icons.event_outlined, const Color(0xFF8C4A6B)),
  'jmena-bozi' => (Icons.key_outlined, const Color(0xFFB0813B)),
  'smlouvy' => (Icons.link, const Color(0xFF7A55A8)),
  'miry-vahy' => (Icons.straighten, const Color(0xFF3F7CAC)),
  _ => (Icons.table_chart_outlined, const Color(0xFFB0813B)),
};

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
                          if (i > 0) const Divider(height: 1, indent: 72),
                          ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: tableStyle(t.id).$2
                                    .withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                tableStyle(t.id).$1,
                                color: tableStyle(t.id).$2,
                              ),
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
                  Card(
                    child: Column(
                      children: [
                        for (final (ri, row) in table.rows.indexed) ...[
                          if (ri > 0) const Divider(height: 1),
                          _CompactRow(
                            row: row,
                            columns: table.columns,
                            color: tableStyle(table.id).$2,
                            cell: cell,
                          ),
                        ],
                      ],
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

/// Řádek tabulky na telefonu: první sloupec jako nadpis, krátký druhý
/// údaj (roky, počet…) jako štítek vpravo, ostatní drobněji pod sebou.
class _CompactRow extends StatelessWidget {
  const _CompactRow({
    required this.row,
    required this.columns,
    required this.color,
    required this.cell,
  });

  final List<TableCellData> row;
  final List<String> columns;
  final Color color;
  final Widget Function(TableCellData c, {TextStyle? style}) cell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final badge =
        row.length > 1 &&
            row[1].passage == null &&
            row[1].text.isNotEmpty &&
            row[1].text.length <= 14
        ? row[1]
        : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: cell(
                  row.first,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge.text,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          for (var i = badge == null ? 1 : 2; i < row.length; i++)
            if (row[i].text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 92,
                      child: Text(
                        columns[i],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ),
                    Expanded(
                      child: cell(
                        row[i],
                        style: theme.textTheme.bodySmall?.copyWith(
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
