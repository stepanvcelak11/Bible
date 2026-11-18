import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/services/versification.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/notes_screen.dart';
import '../../content/presentation/people_screen.dart';
import '../../reader/application/reader_state.dart';
import '../../search/application/reference_parser.dart';
import '../../search/presentation/search_screen.dart';
import '../../shell/home_shell.dart';
import '../../study/application/study_providers.dart';
import '../../study/presentation/study_pack_screen.dart';
import '../../translations/application/translation_controller.dart';
import '../../translations/presentation/library_screen.dart';
import '../application/prep_controller.dart';
import '../../search/presentation/thought_results.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../../core/widgets/pill_switch.dart';
import 'passage_picker.dart';

part 'prep_export.dart';
part 'prep_present.dart';

void openPreps(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PrepListScreen()));

void openPrep(BuildContext context, int id) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => PrepEditorScreen(prepId: id)));

/// Rozpozná biblické místo zapsané česky: „J 3“, „J 3,16“, „Ř 8,28-39“.
/// Bez verše = celá kapitola. Kanonické (hebrejské) číslování.
Passage? parsePassageInput(String input, List<Book> books) {
  final start = parseReference(input, books);
  if (start == null) return null;
  final hasVerse = RegExp(r'\d\s*[,:.]\s*\d').hasMatch(input);
  if (!hasVerse) return Passage(start.bookId, start.chapter, 0, 0);
  final end = RegExp(r'[-–]\s*(\d{1,3})\s*$').firstMatch(input.trim());
  final last = int.tryParse(end?[1] ?? '') ?? start.verse;
  return Passage(
    start.bookId,
    start.chapter,
    start.verse,
    last < start.verse ? start.verse : last,
  );
}

String passageLabel(WidgetRef ref, Passage p) =>
    p.label(ref.read(bookByIdProvider(p.bookId)).name);

Color _blockColor(PrepBlockKind k) => switch (k) {
  PrepBlockKind.heading => const Color(0xFF8A6A3A),
  PrepBlockKind.note => const Color(0xFF6F7F8F),
  PrepBlockKind.verse => const Color(0xFFB07A2A),
  PrepBlockKind.question => const Color(0xFF3F7CAC),
  PrepBlockKind.illustration => const Color(0xFF7C5BA6),
  PrepBlockKind.idea => const Color(0xFF3E8E5E),
};

IconData _blockIcon(PrepBlockKind k) => switch (k) {
  PrepBlockKind.heading => Icons.format_list_numbered,
  PrepBlockKind.note => Icons.notes,
  PrepBlockKind.verse => Icons.menu_book_outlined,
  PrepBlockKind.question => Icons.help_outline,
  PrepBlockKind.illustration => Icons.theater_comedy_outlined,
  PrepBlockKind.idea => Icons.lightbulb_outline,
};

String _blockHint(PrepBlockKind k) => switch (k) {
  PrepBlockKind.heading => S.prepHintHeading,
  PrepBlockKind.note => S.prepHintNote,
  PrepBlockKind.verse => S.prepHintVerse,
  PrepBlockKind.question => S.prepHintQuestion,
  PrepBlockKind.illustration => S.prepHintIllustration,
  PrepBlockKind.idea => S.prepHintIdea,
};

String _date(DateTime d) => '${d.day}. ${d.month}. ${d.year}';

/// Odhad délky projevu (asi 130 slov za minutu + čtení veršů).
int _minutes(Prep p) {
  final verses = p.blocks.where((b) => b.kind == PrepBlockKind.verse).length;
  return ((p.words / 130) + verses * 0.5).ceil();
}

// --- Seznam -------------------------------------------------------------------

class PrepListScreen extends ConsumerWidget {
  const PrepListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final preps = ref.watch(prepProvider);
    final books = ref.watch(booksProvider);
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(S.preps),
          actions: [
            IconButton(
              tooltip: S.prepImport,
              icon: const Icon(Icons.file_open_outlined),
              onPressed: () => importPrepFile(context, ref),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _newPrep(context, ref),
          icon: const Icon(Icons.add),
          label: const Text(S.prepNew),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 96,
          ),
          children: [
            Text(
              S.prepIntro,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                onPressed: () => importPrepFile(context, ref),
                icon: const Icon(Icons.file_open_outlined, size: 18),
                label: const Text(S.prepImportButton),
              ),
            ),
            const SizedBox(height: 6),
            if (preps.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.prepHowTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      for (final t in [...S.prepHow, S.prepHowDevices])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: palette.gold,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  t,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            for (final p in preps)
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  leading: CircleAvatar(
                    backgroundColor: palette.gold.withValues(alpha: 0.15),
                    child: Icon(Icons.edit_note, color: palette.gold),
                  ),
                  title: Text(
                    p.title.isEmpty ? S.prepUntitled : p.title,
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    [
                      p.kind.label,
                      for (final ps in p.passages)
                        ps.label(books[ps.bookId - 1].abbreviation),
                      if (p.date case final d?) _date(d),
                      S.prepBlocks(p.blocks.length),
                      if (p.preached.isNotEmpty)
                        S.prepPreachedTimes(p.preached.length),
                    ].join(' · '),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openPrep(context, p.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> _newPrep(BuildContext context, WidgetRef ref) async {
  final title = TextEditingController();
  var kind = PrepKind.sermon;
  var template = true;
  // Vybraná osnova: null = základní osnova pro druh přípravy.
  (String, String, List<(String, String)>)? outline;
  final passages = <Passage>[];
  final created = await showAppSheet<Prep>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);
        final palette = AppPalette.of(context);
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            MediaQuery.viewInsetsOf(context).bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Volby se posouvají, tlačítko Založit zůstává vždy vidět.
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.prepNew, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      TextField(
                        controller: title,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: S.prepTitle,
                          hintText: S.prepTitleHint,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final k in PrepKind.values)
                            ChoiceChip(
                              label: Text(k.label),
                              selected: kind == k,
                              onSelected: (_) => setState(() {
                                kind = k;
                                outline = null;
                              }),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        S.prepMainPassages,
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final p in passages)
                            InputChip(
                              avatar: Icon(
                                Icons.menu_book,
                                size: 18,
                                color: palette.gold,
                              ),
                              label: Text(passageLabel(ref, p)),
                              onDeleted: () =>
                                  setState(() => passages.remove(p)),
                            ),
                          ActionChip(
                            avatar: const Icon(Icons.add, size: 18),
                            label: Text(
                              passages.isEmpty
                                  ? S.prepPickFromBible
                                  : S.prepAnotherText,
                            ),
                            onPressed: () async {
                              final p = await pickPassage(context);
                              if (p != null && !passages.contains(p)) {
                                setState(() => passages.add(p));
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(S.prepOutline, style: theme.textTheme.labelLarge),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (prepTemplates[kind]!.isNotEmpty)
                            ChoiceChip(
                              label: const Text(S.prepOutlineBasic),
                              selected: template && outline == null,
                              onSelected: (_) => setState(() {
                                template = true;
                                outline = null;
                              }),
                            ),
                          for (final o in prepOutlines)
                            ChoiceChip(
                              label: Text(o.$1),
                              selected: template && outline == o,
                              onSelected: (_) => setState(() {
                                template = true;
                                outline = o;
                              }),
                            ),
                          ChoiceChip(
                            label: const Text(S.prepOutlineNone),
                            selected:
                                !template ||
                                (outline == null &&
                                    prepTemplates[kind]!.isEmpty),
                            onSelected: (_) => setState(() {
                              template = false;
                              outline = null;
                            }),
                          ),
                        ],
                      ),
                      if (template &&
                          (outline?.$3 ?? prepTemplates[kind]!).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            (outline?.$3 ?? prepTemplates[kind]!)
                                .map((e) => e.$1)
                                .join(' · '),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: palette.muted,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    ref
                        .read(prepProvider.notifier)
                        .create(
                          title: title.text.trim(),
                          kind: kind,
                          passages: passages,
                          template: template,
                          outline: outline?.$3,
                        ),
                  ),
                  child: const Text(S.prepCreate),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
  if (created != null && context.mounted) openPrep(context, created.id);
}

/// Vybere verš z Bible a přidá ho do přípravy (za [after] nebo do bodu
/// [section]).
Future<void> _addVerse(
  BuildContext context,
  WidgetRef ref,
  int prepId, {
  int? after,
  int? section,
}) async {
  final p = await pickPassage(context);
  if (p == null) return;
  ref
      .read(prepProvider.notifier)
      .addBlock(
        prepId,
        PrepBlockKind.verse,
        passage: p,
        after: after,
        section: section,
      );
}

// --- Editor -------------------------------------------------------------------

class PrepEditorScreen extends ConsumerStatefulWidget {
  const PrepEditorScreen({super.key, required this.prepId});

  final int prepId;

  @override
  ConsumerState<PrepEditorScreen> createState() => _PrepEditorScreenState();
}

class _PrepEditorScreenState extends ConsumerState<PrepEditorScreen> {
  /// Blok, ve kterém se naposledy psalo – nové bloky z dolní lišty se
  /// vloží za něj (u bodu osnovy na konec bodu).
  final _active = ValueNotifier<int?>(null);

  /// Blok, do kterého se má po vytvoření přesunout kurzor.
  int? _focusNew;

  int get prepId => widget.prepId;

  @override
  void dispose() {
    _active.dispose();
    super.dispose();
  }

  void _add(PrepBlockKind k, {int? section}) {
    final prep = ref.read(prepProvider.notifier).byId(prepId);
    if (prep == null) return;
    int? after;
    if (section == null) {
      final active = prep.blocks
          .where((b) => b.id == _active.value)
          .firstOrNull;
      if (active?.kind == PrepBlockKind.heading) {
        section = active!.id;
      } else {
        after = active?.id;
      }
    }
    if (k == PrepBlockKind.verse) {
      _addVerse(context, ref, prepId, after: after, section: section);
      return;
    }
    final b = ref
        .read(prepProvider.notifier)
        .addBlock(prepId, k, after: after, section: section);
    setState(() => _focusNew = b.id);
  }

  @override
  Widget build(BuildContext context) {
    final prep = ref.watch(
      prepProvider.select((l) => l.where((p) => p.id == prepId).firstOrNull),
    );
    if (prep == null) {
      return Scaffold(appBar: AppBar());
    }
    final controller = ref.read(prepProvider.notifier);
    final focusNew = _focusNew;
    _focusNew = null;
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: Text(prep.kind.label),
          actions: [
            IconButton(
              tooltip: S.prepHelper,
              icon: const Icon(Icons.tips_and_updates_outlined),
              onPressed: () => showPrepHelper(context, prepId),
            ),
            IconButton(
              tooltip: S.prepPresent,
              icon: const Icon(Icons.slideshow_outlined),
              onPressed: () async {
                final length = await Navigator.of(context, rootNavigator: true)
                    .push<Object?>(
                      MaterialPageRoute(
                        builder: (_) => PrepPresentScreen(prepId: prepId),
                      ),
                    );
                // Po skutečném kázání (ne jen nahlédnutí) nabídnout zápis.
                if (length is Duration &&
                    length >= const Duration(minutes: 5) &&
                    context.mounted) {
                  await askPreached(context, ref, prepId, afterPreaching: true);
                }
              },
            ),
            PopupMenuButton<String>(
              onSelected: (v) async {
                switch (v) {
                  case 'rehearse':
                    await Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute<Object?>(
                        builder: (_) =>
                            PrepPresentScreen(prepId: prepId, rehearsal: true),
                      ),
                    );
                  case 'export':
                    await showPrepExport(context, ref, prep);
                  case 'device':
                    await sendPrepToDevice(context, prep);
                  case 'delete':
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text(S.prepDeleteTitle),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(c).pop(false),
                            child: const Text(S.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(c).pop(true),
                            child: const Text(S.delete),
                          ),
                        ],
                      ),
                    );
                    if (ok == true && context.mounted) {
                      Navigator.of(context).pop();
                      controller.remove(prepId);
                    }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'rehearse',
                  child: ListTile(
                    leading: Icon(Icons.design_services_outlined),
                    title: Text(S.prepRehearsalMenu),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: ListTile(
                    leading: Icon(Icons.ios_share),
                    title: Text(S.prepExportTitle),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'device',
                  child: ListTile(
                    leading: Icon(Icons.devices_outlined),
                    title: Text(S.prepSendDevice),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text(S.delete),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _AddBar(onAdd: _add),
        body: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          header: _PrepHeader(prep: prep),
          itemCount: prep.blocks.length,
          onReorderItem: (a, b) => controller.moveBlock(prepId, a, b),
          itemBuilder: (context, i) {
            final b = prep.blocks[i];
            return _BlockCard(
              key: ValueKey(b.id),
              prepId: prepId,
              block: b,
              index: i,
              inSection:
                  b.kind != PrepBlockKind.heading &&
                  prep.blocks
                      .take(i)
                      .any((x) => x.kind == PrepBlockKind.heading),
              autofocus: b.id == focusNew,
              active: _active,
              onAdd: (k) => _add(k, section: b.id),
            );
          },
        ),
      ),
    );
  }
}

class _PrepHeader extends ConsumerStatefulWidget {
  const _PrepHeader({required this.prep});

  final Prep prep;

  @override
  ConsumerState<_PrepHeader> createState() => _PrepHeaderState();
}

class _PrepHeaderState extends ConsumerState<_PrepHeader> {
  late final _title = TextEditingController(text: widget.prep.title);

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final prep = widget.prep;
    final controller = ref.read(prepProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            style: theme.textTheme.headlineSmall,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: S.prepTitleHint,
              border: InputBorder.none,
              isDense: true,
            ),
            onChanged: (v) =>
                controller.update(prep.copyWith(title: v), debounce: true),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final p in prep.passages)
                InputChip(
                  avatar: Icon(Icons.menu_book, size: 18, color: palette.gold),
                  label: Text(passageLabel(ref, p)),
                  tooltip: S.treeRead,
                  onPressed: () => openReaderAt(context, ref, p.start),
                  onDeleted: () => controller.update(
                    prep.copyWith(
                      passages: [
                        for (final x in prep.passages)
                          if (x != p) x,
                      ],
                    ),
                  ),
                ),
              ActionChip(
                avatar: Icon(Icons.add, size: 18, color: palette.gold),
                label: Text(
                  prep.passages.isEmpty ? S.prepMainPassage : S.prepAnotherText,
                ),
                onPressed: () async {
                  final p = await pickPassage(context);
                  if (p == null || prep.passages.contains(p)) return;
                  final now = controller.byId(prep.id) ?? prep;
                  controller.update(
                    now.copyWith(passages: [...now.passages, p]),
                  );
                },
              ),
              ActionChip(
                avatar: Icon(Icons.event, size: 18, color: palette.gold),
                label: Text(prep.date == null ? S.prepDate : _date(prep.date!)),
                onPressed: () async {
                  final now = DateTime.now();
                  final d = await showDatePicker(
                    context: context,
                    initialDate: prep.date ?? now,
                    firstDate: DateTime(now.year - 5),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (d != null) {
                    controller.update(prep.copyWith(date: () => d));
                  }
                },
              ),
              PopupMenuButton<PrepKind>(
                onSelected: (k) => controller.update(prep.copyWith(kind: k)),
                itemBuilder: (_) => [
                  for (final k in PrepKind.values)
                    PopupMenuItem(value: k, child: Text(k.label)),
                ],
                child: Chip(
                  avatar: Icon(Icons.category, size: 18, color: palette.gold),
                  label: Text(prep.kind.label),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            S.prepStats(prep.blocks.length, prep.words, _minutes(prep)),
            style: theme.textTheme.labelSmall?.copyWith(color: palette.muted),
          ),
          _Preached(prep: prep),
        ],
      ),
    );
  }
}

/// Historie kázání (kdy a kde) a upozornění na dřívější kázání nad
/// stejným textem.
class _Preached extends ConsumerWidget {
  const _Preached({required this.prep});

  final Prep prep;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final controller = ref.read(prepProvider.notifier);
    final earlier = preachedOnSameText(ref.watch(prepProvider), prep);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (earlier.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            decoration: BoxDecoration(
              color: palette.gold.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: palette.gold.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, size: 18, color: palette.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        S.prepAlreadyPreached,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                for (final o in earlier)
                  InkWell(
                    onTap: () => openPrep(context, o.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: o.title.isEmpty ? S.prepUntitled : o.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '  ·  ${o.passages.map((p) => passageLabel(ref, p)).join(', ')}'
                                  '\n${o.preached.map(preachedLabel).join(' · ')}',
                              style: TextStyle(color: palette.muted),
                            ),
                          ],
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (prep.preached.isNotEmpty)
              Text(
                '${S.prepPreached}:',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: palette.muted,
                ),
              ),
            for (final d in prep.preached)
              InputChip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(Icons.check_circle, size: 16, color: palette.gold),
                label: Text(preachedLabel(d)),
                onPressed: () => askPreached(context, ref, prep.id, edit: d),
                deleteButtonTooltipMessage: S.prepPreachedDelete,
                onDeleted: () {
                  final now = controller.byId(prep.id) ?? prep;
                  controller.update(
                    now.copyWith(
                      preached: [
                        for (final x in now.preached)
                          if (x != d) x,
                      ],
                    ),
                  );
                },
              ),
            ActionChip(
              visualDensity: VisualDensity.compact,
              avatar: Icon(Icons.add, size: 16, color: palette.gold),
              label: const Text(S.prepPreachedAdd),
              onPressed: () => askPreached(context, ref, prep.id),
            ),
          ],
        ),
      ],
    );
  }
}

String preachedLabel(PrepPreached d) =>
    d.place.isEmpty ? _date(d.date) : '${_date(d.date)}, ${d.place}';

/// Zapsat (nebo upravit [edit]) záznam, kdy a kde se kázalo. Po kázání
/// ([afterPreaching]) s dnešním datem a posledním použitým místem.
Future<void> askPreached(
  BuildContext context,
  WidgetRef ref,
  int prepId, {
  PrepPreached? edit,
  bool afterPreaching = false,
}) async {
  final controller = ref.read(prepProvider.notifier);
  final lastPlace = ([
    for (final p in ref.read(prepProvider)) ...p.preached,
  ]..sort((a, b) => a.date.compareTo(b.date))).lastOrNull?.place;
  final place = TextEditingController(text: edit?.place ?? lastPlace ?? '');
  var date = edit?.date ?? DateTime.now();
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: Text(edit == null ? S.prepPreachedAsk : S.prepPreached),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (afterPreaching)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  S.prepPreachedAskBody,
                  style: Theme.of(c).textTheme.bodySmall,
                ),
              ),
            OutlinedButton.icon(
              icon: const Icon(Icons.event, size: 18),
              label: Text(_date(date)),
              onPressed: () async {
                final d = await showDatePicker(
                  context: c,
                  initialDate: date,
                  firstDate: DateTime(1990),
                  lastDate: DateTime(DateTime.now().year + 5),
                );
                if (d != null) setState(() => date = d);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: place,
              autofocus: !afterPreaching,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: S.prepPreachedPlace,
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => Navigator.of(c).pop(true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(false),
            child: Text(afterPreaching ? S.prepPreachedLater : S.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(c).pop(true),
            child: const Text(S.prepPreachedSave),
          ),
        ],
      ),
    ),
  );
  final text = place.text.trim();
  place.dispose();
  if (ok != true) return;
  final prep = controller.byId(prepId);
  if (prep == null) return;
  final entry = PrepPreached(DateTime(date.year, date.month, date.day), text);
  controller.update(
    prep.copyWith(
      preached: [
        for (final x in prep.preached)
          if (x != edit) x,
        entry,
      ]..sort((a, b) => a.date.compareTo(b.date)),
    ),
  );
}

/// Dolní lišta: přidat blok za místo, kde se právě píše.
class _AddBar extends StatelessWidget {
  const _AddBar({required this.onAdd});

  final void Function(PrepBlockKind) onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      child: SafeArea(
        top: false,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: palette.cardBorder)),
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            children: [
              for (final k in const [
                PrepBlockKind.verse,
                PrepBlockKind.note,
                PrepBlockKind.heading,
                PrepBlockKind.question,
                PrepBlockKind.illustration,
                PrepBlockKind.idea,
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    avatar: Icon(
                      _blockIcon(k),
                      size: 18,
                      color: _blockColor(k),
                    ),
                    label: Text('+ ${k.label}'),
                    onPressed: () => onAdd(k),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlockCard extends ConsumerStatefulWidget {
  const _BlockCard({
    super.key,
    required this.prepId,
    required this.block,
    required this.index,
    required this.inSection,
    required this.autofocus,
    required this.active,
    required this.onAdd,
  });

  final int prepId;
  final PrepBlock block;
  final int index;

  /// Patří pod bod osnovy (odsazení).
  final bool inSection;
  final bool autofocus;
  final ValueNotifier<int?> active;

  /// Přidat blok do tohoto bodu (jen u bodu osnovy).
  final void Function(PrepBlockKind) onAdd;

  @override
  ConsumerState<_BlockCard> createState() => _BlockCardState();
}

class _BlockCardState extends ConsumerState<_BlockCard> {
  late final _text = TextEditingController(text: widget.block.text);
  late final _body = TextEditingController(text: widget.block.body);
  final _focus = FocusNode();
  final _bodyFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    void track() {
      if (_focus.hasFocus || _bodyFocus.hasFocus) {
        widget.active.value = widget.block.id;
      }
    }

    _focus.addListener(track);
    _bodyFocus.addListener(track);
  }

  @override
  void dispose() {
    _text.dispose();
    _body.dispose();
    _focus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final b = widget.block;
    final color = _blockColor(b.kind);
    final controller = ref.read(prepProvider.notifier);
    final heading = b.kind == PrepBlockKind.heading;
    PrepBlock current() => b.copyWith(text: _text.text, body: _body.text);
    final card = Padding(
      padding: EdgeInsets.only(
        bottom: 8,
        top: heading && !b.withPrevious ? 10 : 0,
        left: widget.inSection ? 14 : 0,
      ),
      child: Material(
        color: heading ? color.withValues(alpha: 0.12) : palette.card,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          padding: const EdgeInsets.fromLTRB(10, 4, 0, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_blockIcon(b.kind), size: 16, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      b.passage == null
                          ? b.kind.label.toUpperCase()
                          : passageLabel(ref, b.passage!),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                        letterSpacing: b.passage == null ? 1 : 0,
                      ),
                    ),
                  ),
                  if (b.passage case final p?) ...[
                    IconButton(
                      tooltip: S.prepConnections,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.hub_outlined, size: 20),
                      onPressed: () =>
                          showPrepHelper(context, widget.prepId, focus: p),
                    ),
                    IconButton(
                      tooltip: S.treeRead,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(
                        Icons.chrome_reader_mode_outlined,
                        size: 20,
                      ),
                      onPressed: () => openReaderAt(context, ref, p.start),
                    ),
                  ],
                  PopupMenuButton<PrepPlace>(
                    tooltip: S.prepPlace,
                    initialValue: b.place,
                    icon: Icon(
                      switch (b.place) {
                        PrepPlace.auto => Icons.dashboard_outlined,
                        PrepPlace.full => Icons.crop_landscape,
                        PrepPlace.left => Icons.align_horizontal_left,
                        PrepPlace.right => Icons.align_horizontal_right,
                      },
                      size: 20,
                      color: b.place == PrepPlace.auto
                          ? palette.muted
                          : palette.gold,
                    ),
                    onSelected: (v) => controller.updateBlock(
                      widget.prepId,
                      current().copyWith(place: v),
                    ),
                    itemBuilder: (_) => [
                      PopupMenuItem<PrepPlace>(
                        enabled: false,
                        child: Text(S.prepPlace),
                      ),
                      for (final v in PrepPlace.values)
                        CheckedPopupMenuItem(
                          value: v,
                          checked: b.place == v,
                          child: Text(v.label),
                        ),
                    ],
                  ),
                  if (widget.index > 0)
                    IconButton(
                      tooltip: b.withPrevious ? S.prepJoinedTip : S.prepJoinTip,
                      visualDensity: VisualDensity.compact,
                      isSelected: b.withPrevious,
                      icon: Icon(
                        b.withPrevious ? Icons.link : Icons.link_off,
                        size: 20,
                        color: b.withPrevious ? palette.gold : palette.muted,
                      ),
                      onPressed: () => controller.updateBlock(
                        widget.prepId,
                        current().copyWith(withPrevious: !b.withPrevious),
                      ),
                    ),
                  PopupMenuButton<Object>(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    onSelected: (v) {
                      if (v == 'delete') {
                        controller.removeBlock(widget.prepId, b.id);
                      } else if (v case final PrepBlockKind k) {
                        controller.updateBlock(
                          widget.prepId,
                          current().copyWith(kind: k),
                        );
                      }
                    },
                    itemBuilder: (_) => [
                      if (b.kind != PrepBlockKind.verse)
                        for (final k in PrepBlockKind.values)
                          if (k != b.kind && k != PrepBlockKind.verse)
                            PopupMenuItem(
                              value: k,
                              child: Text('${S.prepChangeTo} ${k.label}'),
                            ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(S.delete),
                      ),
                    ],
                  ),
                  ReorderableDragStartListener(
                    index: widget.index,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.drag_indicator, size: 20),
                    ),
                  ),
                ],
              ),
              if (b.passage != null)
                _VerseText(prepId: widget.prepId, block: b),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextField(
                  controller: _text,
                  focusNode: _focus,
                  autofocus: widget.autofocus,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  style: heading
                      ? theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        )
                      : theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: _blockHint(b.kind),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onChanged: (_) =>
                      controller.updateBlock(widget.prepId, current()),
                ),
              ),
              if (heading) ...[
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 4, 12, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: palette.cardBorder),
                  ),
                  child: TextField(
                    controller: _body,
                    focusNode: _bodyFocus,
                    minLines: 2,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: theme.textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText: b.hint.isEmpty ? S.prepBodyHint : b.hint,
                      hintMaxLines: 3,
                      border: InputBorder.none,
                    ),
                    onChanged: (_) =>
                        controller.updateBlock(widget.prepId, current()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 8),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      for (final k in const [
                        PrepBlockKind.verse,
                        PrepBlockKind.note,
                        PrepBlockKind.question,
                      ])
                        _SmallAdd(kind: k, onTap: () => widget.onAdd(k)),
                      PopupMenuButton<PrepBlockKind>(
                        tooltip: S.prepMore,
                        onSelected: widget.onAdd,
                        itemBuilder: (_) => [
                          for (final k in const [
                            PrepBlockKind.illustration,
                            PrepBlockKind.idea,
                          ])
                            PopupMenuItem(
                              value: k,
                              child: Text('+ ${k.label}'),
                            ),
                        ],
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.more_horiz, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
    if (!b.withPrevious || widget.index == 0) return card;
    // Spojeno s předchozím: při kázání na stejné obrazovce.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: (widget.inSection ? 14 : 0) + 12,
            bottom: 4,
            top: 0,
          ),
          child: Row(
            children: [
              Icon(
                Icons.subdirectory_arrow_right,
                size: 14,
                color: palette.gold,
              ),
              const SizedBox(width: 4),
              Text(
                S.prepJoinedLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        card,
      ],
    );
  }
}

/// Malé tlačítko „+ Verš“ v bodu osnovy.
class _SmallAdd extends StatelessWidget {
  const _SmallAdd({required this.kind, required this.onTap});

  final PrepBlockKind kind;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _blockColor(kind);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_blockIcon(kind), size: 15, color: color),
            const SizedBox(width: 4),
            Text(
              '+ ${kind.label}',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Text verše v hlavním překladu (jako citát).
/// Překlady, ve kterých se verš bloku ukazuje (jen nainstalované;
/// bez výběru hlavní překlad aplikace).
List<Translation> prepTranslations(WidgetRef ref, PrepBlock b) {
  final all = ref.watch(translationsProvider);
  final picked = [
    for (final id in b.translations) ?all.where((t) => t.id == id).firstOrNull,
  ];
  return picked.isEmpty ? [ref.watch(primaryTranslationProvider)] : picked;
}

/// Výběr překladů verše (jeden nebo víc) a jak je ukázat.
Future<void> showPrepTranslations(
  BuildContext context,
  WidgetRef ref,
  int prepId,
  PrepBlock block,
) => showAppSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (context) => _TranslationPicker(prepId: prepId, blockId: block.id),
);

class _TranslationPicker extends ConsumerWidget {
  const _TranslationPicker({required this.prepId, required this.blockId});

  final int prepId;
  final int blockId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final prep = ref.watch(
      prepProvider.select((l) => l.where((p) => p.id == prepId).firstOrNull),
    );
    final b = prep?.blocks.where((x) => x.id == blockId).firstOrNull;
    if (b == null) return const SizedBox.shrink();
    final all = ref.watch(translationsProvider);
    final current = [for (final t in prepTranslations(ref, b)) t.id];
    final controller = ref.read(prepProvider.notifier);
    void set(List<String> ids) =>
        controller.updateBlock(prepId, b.copyWith(translations: ids));
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(S.prepTranslationsTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            S.prepTranslationsHint,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 8),
          for (final t in all)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: current.contains(t.id),
              title: Text('${t.abbreviation} – ${t.name}'),
              onChanged: (on) {
                final next = [...current];
                on == true ? next.add(t.id) : next.remove(t.id);
                // Aspoň jeden překlad zůstane.
                if (next.isNotEmpty) set(next);
              },
            ),
          if (current.length > 1) ...[
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: b.parallel,
              title: const Text(S.prepParallel),
              subtitle: const Text(S.prepParallelHint),
              onChanged: (v) =>
                  controller.updateBlock(prepId, b.copyWith(parallel: v)),
            ),
          ],
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const LibraryScreen()),
              );
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text(S.prepMoreTranslations),
          ),
        ],
      ),
    );
  }
}

/// Text verše v editoru – v každém vybraném překladu – a tlačítko výběru
/// překladů.
class _VerseText extends ConsumerWidget {
  const _VerseText({required this.prepId, required this.block});

  final int prepId;
  final PrepBlock block;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passage = block.passage!;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translations = prepTranslations(ref, block);
    final many = translations.length > 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final t in translations) ...[
            if (many)
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 2),
                child: Text(
                  t.abbreviation,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            Text.rich(
              TextSpan(
                children: markedSpans(
                  switch (ref
                      .watch(passageTextProvider((t.id, passage)))
                      .value) {
                    final vs? =>
                      vs.map((v) => v.text.replaceAll('\n', ' ')).join(' '),
                    null => '…',
                  },
                  block.marks,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    backgroundColor: palette.gold.withValues(alpha: 0.22),
                  ),
                ),
              ),
              maxLines: passage.wholeChapter ? 4 : (many ? 6 : 12),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: appFontFamily,
                fontSize: 16,
                height: 1.45,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              ActionChip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(Icons.translate, size: 16, color: palette.gold),
                label: Text(
                  translations.map((t) => t.abbreviation).join(' · ') +
                      (many && block.parallel
                          ? '  ·  ${S.prepParallelShort}'
                          : ''),
                ),
                onPressed: () =>
                    showPrepTranslations(context, ref, prepId, block),
              ),
              ActionChip(
                visualDensity: VisualDensity.compact,
                avatar: Icon(
                  Icons.format_color_text,
                  size: 16,
                  color: palette.gold,
                ),
                label: Text(
                  block.marks.isEmpty
                      ? S.prepMarks
                      : S.prepMarksCount(block.marks.length),
                ),
                onPressed: () => _pickMarks(context, ref, prepId, block),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Výběr slov verše, která se při kázání zvýrazní.
Future<void> _pickMarks(
  BuildContext context,
  WidgetRef ref,
  int prepId,
  PrepBlock block,
) async {
  final words = <String, String>{};
  for (final t in prepTranslations(ref, block)) {
    final vs = await ref.read(
      passageTextProvider((t.id, block.passage!)).future,
    );
    for (final v in vs) {
      for (final m in _wordRe.allMatches(v.text)) {
        words.putIfAbsent(markKey(m[0]!), () => m[0]!);
      }
    }
  }
  if (!context.mounted) return;
  final chosen = {...block.marks};
  final ok = await showDialog<bool>(
    context: context,
    builder: (c) => StatefulBuilder(
      builder: (c, setState) => AlertDialog(
        title: const Text(S.prepMarks),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  words.isEmpty ? S.prepMarksNone : S.prepMarksIntro,
                  style: Theme.of(c).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final MapEntry(:key, :value) in words.entries)
                      FilterChip(
                        visualDensity: VisualDensity.compact,
                        showCheckmark: false,
                        label: Text(value),
                        selected: chosen.contains(key),
                        onSelected: (on) => setState(
                          () => on ? chosen.add(key) : chosen.remove(key),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(c).pop(false),
            child: const Text(S.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(c).pop(true),
            child: const Text(S.save),
          ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  final now =
      ref
          .read(prepProvider.notifier)
          .byId(prepId)
          ?.blocks
          .where((b) => b.id == block.id)
          .firstOrNull ??
      block;
  ref
      .read(prepProvider.notifier)
      .updateBlock(prepId, now.copyWith(marks: chosen.toList()));
}

// --- Přidání vybraných veršů ze čtečky ---------------------------------------

/// Ze čtečky: přidá místo do přípravy (vybrané nebo nové).
Future<void> addPassageToPrep(
  BuildContext context,
  WidgetRef ref,
  Passage passage,
) async {
  final preps = ref.read(prepProvider);
  final messenger = ScaffoldMessenger.of(context);
  final navigator = Navigator.of(context);
  final chosen = await showAppSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              '${S.prepAddTo}: ${passageLabel(ref, passage)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text(S.prepNew),
            onTap: () => Navigator.of(context).pop(-1),
          ),
          for (final p in preps.take(12))
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: Text(p.title.isEmpty ? S.prepUntitled : p.title),
              subtitle: Text(p.kind.label),
              onTap: () => Navigator.of(context).pop(p.id),
            ),
        ],
      ),
    ),
  );
  if (chosen == null) return;
  final controller = ref.read(prepProvider.notifier);
  final id = chosen == -1
      ? controller.create(passages: [passage], template: false).id
      : (controller..addBlock(chosen, PrepBlockKind.verse, passage: passage))
            .byId(chosen)!
            .id;
  messenger.showSnackBar(
    SnackBar(
      content: const Text(S.prepAdded),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: S.open,
        onPressed: () => navigator.push(
          MaterialPageRoute<void>(builder: (_) => PrepEditorScreen(prepId: id)),
        ),
      ),
    ),
  );
}

// --- Pomocník -----------------------------------------------------------------

/// Pomocník přípravy: hledání v Bibli, souvislosti, podklady k textu
/// a osnovy. [focus] = verš, pro který ukázat souvislosti.
Future<void> showPrepHelper(
  BuildContext context,
  int prepId, {
  Passage? focus,
}) => showAppSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.85,
    maxChildSize: 0.95,
    builder: (context, scroll) => DefaultTabController(
      length: 5,
      initialIndex: focus == null ? 0 : 1,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.symmetric(horizontal: 12),
            tabs: [
              Tab(text: S.prepTabSearch),
              Tab(text: S.prepConnections),
              Tab(text: S.prepTabContext),
              Tab(text: S.prepTabJournal),
              Tab(text: S.prepTabOutline),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _HelperSearch(prepId: prepId),
                _HelperConnections(prepId: prepId, focus: focus),
                _HelperContext(prepId: prepId),
                _HelperJournal(prepId: prepId),
                _HelperOutline(prepId: prepId),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

void _added(BuildContext context) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    const SnackBar(
      content: Text(S.prepAdded),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 1),
    ),
  );

/// Místo z překladu [translationId] → kanonické (tak se ukládá).
Passage _canonical(VerseRef r, int endVerse, String translationId) {
  final a = Versification.toCanonical(r, translationId);
  final b = Versification.toCanonical(
    VerseRef(r.bookId, r.chapter, endVerse),
    translationId,
  );
  return Passage(
    a.bookId,
    a.chapter,
    a.verse,
    b.chapter == a.chapter ? b.verse : a.verse,
  );
}

final _prepNotesProvider = StreamProvider.autoDispose<List<Note>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllNotes(),
);
final _prepBookmarksProvider = StreamProvider.autoDispose<List<Bookmark>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllBookmarks(),
);
final _prepHighlightsProvider = StreamProvider.autoDispose<List<Highlight>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllHighlights(),
);

/// Zvýrazněné verše sloučené do souvislých úseků (nejnovější první).
List<Passage> highlightPassages(List<Highlight> list) {
  final sorted = [...list]
    ..sort((a, b) {
      final x = a.ref, y = b.ref;
      return x.bookId != y.bookId
          ? x.bookId.compareTo(y.bookId)
          : x.chapter != y.chapter
          ? x.chapter.compareTo(y.chapter)
          : x.verse.compareTo(y.verse);
    });
  final runs = <(Passage, DateTime)>[];
  for (final h in sorted) {
    final last = runs.lastOrNull;
    final r = h.ref;
    if (last != null &&
        last.$1.bookId == r.bookId &&
        last.$1.chapter == r.chapter &&
        last.$1.end + 1 >= r.verse) {
      runs.last = (
        Passage(
          r.bookId,
          r.chapter,
          last.$1.verse,
          math.max(r.verse, last.$1.end),
        ),
        h.createdAt.isAfter(last.$2) ? h.createdAt : last.$2,
      );
    } else {
      runs.add((Passage(r.bookId, r.chapter, r.verse, r.verse), h.createdAt));
    }
  }
  runs.sort((a, b) => b.$2.compareTo(a.$2));
  return [for (final (p, _) in runs) p];
}

/// Pomocník: vložit do přípravy poznámky, záložky a zvýraznění z deníku.
class _HelperJournal extends ConsumerStatefulWidget {
  const _HelperJournal({required this.prepId});

  final int prepId;

  @override
  ConsumerState<_HelperJournal> createState() => _HelperJournalState();
}

class _HelperJournalState extends ConsumerState<_HelperJournal> {
  var _tab = 0;

  void _add(Passage p, [String text = '']) {
    ref
        .read(prepProvider.notifier)
        .addBlock(widget.prepId, PrepBlockKind.verse, passage: p, text: text);
    _added(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final tid = ref.watch(primaryTranslationProvider).id;
    // (místo, vlastní text – u poznámky)
    final List<(Passage, String)>? items = switch (_tab) {
      0 =>
        ref
            .watch(_prepNotesProvider)
            .value
            ?.map(
              (n) => (
                Passage(n.ref.bookId, n.ref.chapter, n.ref.verse, n.verseEnd),
                n.body,
              ),
            )
            .toList(),
      1 =>
        ref
            .watch(_prepBookmarksProvider)
            .value
            ?.map(
              (b) => (
                Passage(b.ref.bookId, b.ref.chapter, b.ref.verse, b.ref.verse),
                b.label ?? '',
              ),
            )
            .toList(),
      _ => switch (ref.watch(_prepHighlightsProvider).value) {
        final l? => [for (final p in highlightPassages(l)) (p, '')],
        null => null,
      },
    };
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Text(
          S.prepJournalIntro,
          style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 10),
        PillSwitch<int>(
          options: const [
            PillOption(0, S.notes),
            PillOption(1, S.bookmarks),
            PillOption(2, S.highlights),
          ],
          value: _tab,
          onChanged: (v) => setState(() => _tab = v),
        ),
        const SizedBox(height: 8),
        if (items == null)
          const LinearProgressIndicator()
        else if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                S.prepJournalEmpty,
                style: TextStyle(color: palette.muted),
              ),
            ),
          )
        else
          for (final (p, text) in items.take(200))
            ListTile(
              contentPadding: const EdgeInsets.only(left: 4),
              title: Text(
                passageLabel(ref, p),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: palette.gold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    switch (ref.watch(passageTextProvider((tid, p))).value) {
                      final vs? =>
                        vs.map((v) => v.text.replaceAll('\n', ' ')).join(' '),
                      null => '…',
                    },
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: appFontFamily),
                  ),
                  if (text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: _AddButton(onTap: () => _add(p, text)),
            ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: S.prepAddToPrep,
    icon: const Icon(Icons.add, size: 20),
    onPressed: onTap,
  );
}

/// Hledání v Bibli – ověření myšlenky: kde Bible o tom mluví?
class _HelperSearch extends ConsumerStatefulWidget {
  const _HelperSearch({required this.prepId});

  final int prepId;

  @override
  ConsumerState<_HelperSearch> createState() => _HelperSearchState();
}

class _HelperSearchState extends ConsumerState<_HelperSearch> {
  String _q = '';
  bool _thought = true;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _add(Passage p) {
    ref
        .read(prepProvider.notifier)
        .addBlock(widget.prepId, PrepBlockKind.verse, passage: p);
    _added(context);
  }

  void _addHit(SearchHit h) =>
      _add(_canonical(h.verse.ref, h.verse.ref.verse, h.verse.translationId));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        PillSwitch<bool>(
          options: const [
            PillOption(
              true,
              S.prepThoughtMode,
              icon: Icons.psychology_alt_outlined,
            ),
            PillOption(false, S.prepWordsMode, icon: Icons.text_fields),
          ],
          value: _thought,
          onChanged: (v) => setState(() => _thought = v),
        ),
        const SizedBox(height: 10),
        TextField(
          autofocus: true,
          minLines: 1,
          maxLines: _thought ? 3 : 1,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            prefixIcon: Icon(
              _thought ? Icons.psychology_alt_outlined : Icons.search,
            ),
            hintText: _thought ? S.prepThoughtHint : S.prepSearchHint,
            filled: true,
            fillColor: palette.gold.withValues(alpha: 0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (v) {
            _debounce?.cancel();
            _debounce = Timer(
              const Duration(milliseconds: 400),
              () => setState(() => _q = v.trim()),
            );
          },
        ),
        const SizedBox(height: 8),
        if (_q.length < 2)
          Text(
            _thought ? S.prepThoughtIntro : S.prepSearchIntro,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          )
        else if (_thought)
          ThoughtResults(text: _q, onAdd: _add)
        else
          ..._wordResults(),
      ],
    );
  }

  List<Widget> _wordResults() {
    final tid = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    return ref
        .watch(
          searchResultsProvider((
            text: _q,
            testament: null,
            bookId: null,
            limit: 40,
            translations: tid,
          )),
        )
        .when(
          loading: () => [const LinearProgressIndicator()],
          error: (e, _) => [Text('$e')],
          data: (list) => list.isEmpty
              ? [const Text(S.searchNoResults)]
              : [
                  for (final h in list)
                    _HitTile(hit: h, onAdd: () => _addHit(h)),
                ],
        );
  }
}

class _HitTile extends ConsumerWidget {
  const _HitTile({required this.hit, required this.onAdd});

  final SearchHit hit;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(hit.verse.ref.bookId));
    final spans = <TextSpan>[];
    var bold = false;
    for (final part in hit.snippet.split(RegExp('[\u0002\u0003]'))) {
      spans.add(
        TextSpan(
          text: part,
          style: bold
              ? TextStyle(fontWeight: FontWeight.w700, color: palette.gold)
              : null,
        ),
      );
      bold = !bold;
    }
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${book.name} ${hit.verse.ref.chapter},${hit.verse.ref.verse}',
        style: theme.textTheme.labelLarge?.copyWith(color: palette.gold),
      ),
      subtitle: Text.rich(TextSpan(children: spans)),
      trailing: _AddButton(onTap: onAdd),
    );
  }
}

/// Souvislosti (křížové odkazy) k verši.
class _HelperConnections extends ConsumerStatefulWidget {
  const _HelperConnections({required this.prepId, this.focus});

  final int prepId;
  final Passage? focus;

  @override
  ConsumerState<_HelperConnections> createState() => _HelperConnectionsState();
}

class _HelperConnectionsState extends ConsumerState<_HelperConnections> {
  late Passage? _focus = widget.focus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final prep = ref.watch(prepProvider.notifier).byId(widget.prepId);
    final sources = <Passage>[
      ...?prep?.passages,
      for (final b in prep?.blocks ?? const <PrepBlock>[]) ?b.passage,
    ];
    final focus = _focus ?? sources.firstOrNull;
    final repo = ref.watch(studyRepositoryProvider);
    final tid = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Text(
          S.prepConnectionsIntro,
          style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final p in {...sources})
              ChoiceChip(
                label: Text(passageLabel(ref, p)),
                selected: focus == p,
                onSelected: (_) => setState(() => _focus = p),
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text(S.prepOtherVerse),
              onPressed: () async {
                final p = await pickPassage(context);
                if (p != null) setState(() => _focus = p);
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (repo == null)
          const StudyPackCard()
        else if (focus == null)
          const Text(S.prepNoVerse)
        else
          ...ref
              .watch(
                crossReferencesProvider((
                  Versification.fromCanonical(
                    focus.wholeChapter
                        ? VerseRef(focus.bookId, focus.chapter, 1)
                        : focus.start,
                    tid,
                  ),
                  tid,
                )),
              )
              .when(
                loading: () => [const LinearProgressIndicator()],
                error: (e, _) => [Text('$e')],
                data: (list) => list.isEmpty
                    ? [const Text(S.noCrossRefs)]
                    : [
                        for (final x in list.take(40))
                          _XrefTile(
                            target: x.target,
                            endVerse: x.endVerse,
                            translationId: tid,
                            onAdd: () {
                              ref
                                  .read(prepProvider.notifier)
                                  .addBlock(
                                    widget.prepId,
                                    PrepBlockKind.verse,
                                    passage: _canonical(
                                      x.target,
                                      x.endVerse,
                                      tid,
                                    ),
                                  );
                              _added(context);
                            },
                          ),
                      ],
              ),
      ],
    );
  }
}

class _XrefTile extends ConsumerWidget {
  const _XrefTile({
    required this.target,
    required this.endVerse,
    required this.translationId,
    required this.onAdd,
  });

  final VerseRef target;
  final int endVerse;
  final String translationId;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(target.bookId));
    final text = ref.watch(verseTextProvider((translationId, target))).value;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${book.name} ${target.chapter},${target.verse}'
        '${endVerse > target.verse ? '–$endVerse' : ''}',
        style: theme.textTheme.labelLarge?.copyWith(color: palette.gold),
      ),
      subtitle: Text(
        text?.text.replaceAll('\n', ' ') ?? '…',
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _AddButton(onTap: onAdd),
    );
  }
}

/// Podklady k hlavnímu textu: otázky ke kapitole, aplikační poznámky,
/// postavy a ověření myšlenky.
class _HelperContext extends ConsumerWidget {
  const _HelperContext({required this.prepId});

  final int prepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final prep = ref.watch(prepProvider.notifier).byId(prepId);
    final main =
        prep?.passage ??
        prep?.blocks.where((b) => b.passage != null).firstOrNull?.passage;
    final controller = ref.read(prepProvider.notifier);
    void addBlock(PrepBlockKind k, String text) {
      controller.addBlock(prepId, k, text: text);
      _added(context);
    }

    Widget label(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 6),
      child: Text(
        t.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: palette.muted,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );

    final children = <Widget>[];
    if (main == null) {
      children.add(
        Text(
          S.prepNoMainPassage,
          style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
        ),
      );
    } else {
      final reflection = ref
          .watch(reflectionsProvider)
          .value?[main.bookId]
          ?.elementAtOrNull(main.chapter - 1);
      bool covers(Passage p) =>
          p.bookId == main.bookId &&
          main.chapter >= p.chapter &&
          main.chapter <= p.endChapter;
      final notes = [
        for (final n in ref.watch(notesProvider).value ?? const <AppNote>[])
          if (covers(n.passage)) n,
      ];
      final people = [
        for (final p
            in ref.watch(peopleProvider).value ?? const <BiblePerson>[])
          if (p.story.any(covers) || covers(p.key)) p,
      ];
      children.add(
        Text(
          S.chapterTitle(
            ref.read(bookByIdProvider(main.bookId)).name,
            main.chapter,
          ),
          style: theme.textTheme.titleMedium,
        ),
      );
      if (reflection != null) {
        children
          ..add(
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(reflection.focus, style: theme.textTheme.bodyMedium),
            ),
          )
          ..add(label(S.prepQuestions));
        for (final q in [
          reflection.observe,
          reflection.understand,
          reflection.life,
        ]) {
          children.add(
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.help_outline,
                color: _blockColor(PrepBlockKind.question),
              ),
              title: Text(q),
              trailing: _AddButton(
                onTap: () => addBlock(PrepBlockKind.question, q),
              ),
            ),
          );
        }
      }
      if (notes.isNotEmpty) {
        children.add(label(S.prepAppNotes));
        for (final n in notes) {
          children.add(
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(n.title),
              subtitle: Text(
                n.application,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => showNoteSheet(context, n),
              trailing: _AddButton(
                onTap: () => addBlock(
                  PrepBlockKind.note,
                  '${n.title}: ${n.application}',
                ),
              ),
            ),
          );
        }
      }
      if (people.isNotEmpty) {
        children
          ..add(label(S.prepPeople))
          ..add(
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final p in people.take(10))
                  ActionChip(
                    avatar: const Icon(Icons.person_outline, size: 18),
                    label: Text(p.name),
                    onPressed: () => openPerson(context, p),
                  ),
              ],
            ),
          );
      }
    }
    children.add(label(S.prepCheckTitle));
    for (final t in S.prepCheck) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_box_outline_blank,
                size: 18,
                color: palette.gold,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(t, style: theme.textTheme.bodySmall)),
            ],
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: children,
    );
  }
}

/// Šablony osnov.
class _HelperOutline extends ConsumerWidget {
  const _HelperOutline({required this.prepId});

  final int prepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        Text(
          S.prepOutlineIntro,
          style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        for (final (title, about, items) in [
          for (final MapEntry(key: kind, value: items) in prepTemplates.entries)
            if (items.isNotEmpty) (kind.label, null, items),
          for (final (t, a, items) in prepOutlines) (t, a, items),
        ])
          Card(
            margin: const EdgeInsets.only(top: 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  if (about case final a?)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        a,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.muted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  for (final (t, _) in items)
                    Text('•  $t', style: theme.textTheme.bodySmall),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.playlist_add),
                      label: const Text(S.prepInsertOutline),
                      onPressed: () {
                        final c = ref.read(prepProvider.notifier);
                        for (final (t, hint) in items) {
                          c.addBlock(
                            prepId,
                            PrepBlockKind.heading,
                            text: t,
                            hint: hint,
                          );
                        }
                        _added(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
