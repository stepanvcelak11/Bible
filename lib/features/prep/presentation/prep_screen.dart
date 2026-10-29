import 'dart:async';

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
import '../application/prep_controller.dart';

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
        appBar: AppBar(title: const Text(S.preps)),
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
            const SizedBox(height: 14),
            if (preps.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.prepHowTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      for (final t in S.prepHow)
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
                      if (p.passage case final ps?)
                        ps.label(books[ps.bookId - 1].abbreviation),
                      if (p.date case final d?) _date(d),
                      S.prepBlocks(p.blocks.length),
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
  final passageText = TextEditingController();
  var kind = PrepKind.sermon;
  var template = true;
  final books = ref.read(booksProvider);
  final created = await showModalBottomSheet<Prep>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);
        final passage = parsePassageInput(passageText.text, books);
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
              Text(S.prepNew, style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: title,
                autofocus: true,
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
                      onSelected: (_) => setState(() => kind = k),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passageText,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: S.prepMainPassage,
                  hintText: 'např. J 3,1-21',
                  helperText: passage == null
                      ? S.prepPassageHelp
                      : '✓ ${passage.label(books[passage.bookId - 1].name)}',
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: template && prepTemplates[kind]!.isNotEmpty,
                onChanged: prepTemplates[kind]!.isEmpty
                    ? null
                    : (v) => setState(() => template = v),
                title: const Text(S.prepUseTemplate),
                subtitle: Text(
                  prepTemplates[kind]!.map((e) => e.$2).take(3).join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                          passage: passage,
                          template: template,
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

/// Zeptá se na biblické místo (s okamžitou kontrolou zápisu).
Future<Passage?> askPassage(BuildContext context, WidgetRef ref) {
  final books = ref.read(booksProvider);
  final c = TextEditingController();
  return showDialog<Passage>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final p = parsePassageInput(c.text, books);
        return AlertDialog(
          title: const Text(S.prepAddVerse),
          content: TextField(
            controller: c,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (p != null) Navigator.of(context).pop(p);
            },
            decoration: InputDecoration(
              hintText: 'např. Ř 8,28-39',
              helperText: p == null
                  ? S.prepPassageHelp
                  : '✓ ${p.label(books[p.bookId - 1].name)}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(S.cancel),
            ),
            FilledButton(
              onPressed: p == null ? null : () => Navigator.of(context).pop(p),
              child: const Text(S.add),
            ),
          ],
        );
      },
    ),
  );
}

// --- Editor -------------------------------------------------------------------

class PrepEditorScreen extends ConsumerWidget {
  const PrepEditorScreen({super.key, required this.prepId});

  final int prepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prep = ref.watch(
      prepProvider.select((l) => l.where((p) => p.id == prepId).firstOrNull),
    );
    if (prep == null) {
      return Scaffold(appBar: AppBar());
    }
    final controller = ref.read(prepProvider.notifier);
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
              onPressed: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute<void>(
                  builder: (_) => PrepPresentScreen(prepId: prepId),
                ),
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) async {
                switch (v) {
                  case 'share':
                    final text = await _exportText(ref, prep);
                    await SharePlus.instance.share(ShareParams(text: text));
                  case 'copy':
                    final messenger = ScaffoldMessenger.of(context);
                    await Clipboard.setData(
                      ClipboardData(text: await _exportText(ref, prep)),
                    );
                    messenger.showSnackBar(
                      const SnackBar(content: Text(S.copied)),
                    );
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
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.ios_share),
                    title: Text(S.share),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'copy',
                  child: ListTile(
                    leading: Icon(Icons.copy_rounded),
                    title: Text(S.prepCopyText),
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
        bottomNavigationBar: _AddBar(prepId: prepId),
        body: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          header: _PrepHeader(prep: prep),
          itemCount: prep.blocks.length,
          onReorderItem: (a, b) => controller.moveBlock(prepId, a, b),
          itemBuilder: (context, i) => _BlockCard(
            key: ValueKey(prep.blocks[i].id),
            prepId: prepId,
            block: prep.blocks[i],
            index: i,
          ),
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
              ActionChip(
                avatar: Icon(Icons.menu_book, size: 18, color: palette.gold),
                label: Text(
                  prep.passage == null
                      ? S.prepMainPassage
                      : passageLabel(ref, prep.passage!),
                ),
                onPressed: () async {
                  final p = await askPassage(context, ref);
                  if (p != null) {
                    controller.update(prep.copyWith(passage: () => p));
                  }
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
        ],
      ),
    );
  }
}

class _AddBar extends ConsumerWidget {
  const _AddBar({required this.prepId});

  final int prepId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    Future<void> add(PrepBlockKind k) async {
      final controller = ref.read(prepProvider.notifier);
      if (k == PrepBlockKind.verse) {
        final p = await askPassage(context, ref);
        if (p != null) controller.addBlock(prepId, k, passage: p);
      } else {
        controller.addBlock(prepId, k);
      }
    }

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
              for (final k in PrepBlockKind.values)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ActionChip(
                    avatar: Icon(
                      _blockIcon(k),
                      size: 18,
                      color: _blockColor(k),
                    ),
                    label: Text('+ ${k.label}'),
                    onPressed: () => add(k),
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
  });

  final int prepId;
  final PrepBlock block;
  final int index;

  @override
  ConsumerState<_BlockCard> createState() => _BlockCardState();
}

class _BlockCardState extends ConsumerState<_BlockCard> {
  late final _text = TextEditingController(text: widget.block.text);

  @override
  void dispose() {
    _text.dispose();
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
    return Padding(
      padding: EdgeInsets.only(bottom: 8, top: heading ? 8 : 0),
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
                  PopupMenuButton<Object>(
                    icon: const Icon(Icons.more_horiz, size: 20),
                    onSelected: (v) {
                      if (v == 'delete') {
                        controller.removeBlock(widget.prepId, b.id);
                      } else if (v case final PrepBlockKind k) {
                        controller.updateBlock(
                          widget.prepId,
                          b.copyWith(kind: k, text: _text.text),
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
              if (b.passage case final p?) _VerseText(passage: p),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextField(
                  controller: _text,
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
                  onChanged: (v) => controller.updateBlock(
                    widget.prepId,
                    b.copyWith(text: v),
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

/// Text verše v hlavním překladu (jako citát).
class _VerseText extends ConsumerWidget {
  const _VerseText({required this.passage});

  final Passage passage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translation = ref.watch(primaryTranslationProvider);
    final verses = ref
        .watch(passageTextProvider((translation.id, passage)))
        .value;
    final theme = Theme.of(context);
    final text = verses == null
        ? '…'
        : verses.map((v) => v.text.replaceAll('\n', ' ')).join(' ');
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 12, 4),
      child: Text(
        text,
        maxLines: passage.wholeChapter ? 4 : 12,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: appFontFamily,
          fontSize: 16,
          height: 1.45,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}

Future<String> _exportText(WidgetRef ref, Prep prep) async {
  final translation = ref.read(primaryTranslationProvider);
  final out = StringBuffer()
    ..writeln(prep.title.isEmpty ? S.prepUntitled : prep.title)
    ..writeln(
      [
        prep.kind.label,
        if (prep.passage case final p?) passageLabel(ref, p),
        if (prep.date case final d?) _date(d),
      ].join(' · '),
    )
    ..writeln();
  for (final b in prep.blocks) {
    switch (b.kind) {
      case PrepBlockKind.heading:
        out
          ..writeln()
          ..writeln(b.text.toUpperCase());
      case PrepBlockKind.verse:
        final verses = await ref.read(
          passageTextProvider((translation.id, b.passage!)).future,
        );
        out.writeln(
          '${passageLabel(ref, b.passage!)} (${translation.abbreviation}): '
          '„${verses.map((v) => v.text.replaceAll('\n', ' ')).join(' ')}“',
        );
        if (b.text.isNotEmpty) out.writeln('  ${b.text}');
      case PrepBlockKind.question:
        out.writeln('? ${b.text}');
      case PrepBlockKind.illustration:
        out.writeln('Ilustrace: ${b.text}');
      case PrepBlockKind.idea || PrepBlockKind.note:
        out.writeln(b.text);
    }
  }
  return out.toString().trim();
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
  final chosen = await showModalBottomSheet<int>(
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
      ? controller.create(passage: passage, template: false).id
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
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.85,
    maxChildSize: 0.95,
    builder: (context, scroll) => DefaultTabController(
      length: 4,
      initialIndex: focus == null ? 0 : 1,
      child: Column(
        children: [
          const TabBar(
            labelPadding: EdgeInsets.symmetric(horizontal: 4),
            tabs: [
              Tab(text: S.prepTabSearch),
              Tab(text: S.prepConnections),
              Tab(text: S.prepTabContext),
              Tab(text: S.prepTabOutline),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _HelperSearch(prepId: prepId),
                _HelperConnections(prepId: prepId, focus: focus),
                _HelperContext(prepId: prepId),
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
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final tid = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final hits = _q.length < 2
        ? null
        : ref.watch(
            searchResultsProvider((
              text: _q,
              testament: null,
              bookId: null,
              limit: 40,
              translations: tid,
            )),
          );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: S.prepSearchHint,
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
              const Duration(milliseconds: 300),
              () => setState(() => _q = v.trim()),
            );
          },
        ),
        const SizedBox(height: 8),
        if (hits == null)
          Text(
            S.prepSearchIntro,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          )
        else
          ...hits.when(
            loading: () => [const LinearProgressIndicator()],
            error: (e, _) => [Text('$e')],
            data: (list) => list.isEmpty
                ? [const Text(S.searchNoResults)]
                : [
                    for (final h in list)
                      _HitTile(
                        hit: h,
                        onAdd: () {
                          ref
                              .read(prepProvider.notifier)
                              .addBlock(
                                widget.prepId,
                                PrepBlockKind.verse,
                                passage: _canonical(
                                  h.verse.ref,
                                  h.verse.ref.verse,
                                  h.verse.translationId,
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
      ?prep?.passage,
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
                final p = await askPassage(context, ref);
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
        for (final MapEntry(key: kind, value: items) in prepTemplates.entries)
          if (items.isNotEmpty)
            Card(
              margin: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(kind.label, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    for (final (_, t) in items)
                      Text('•  $t', style: theme.textTheme.bodySmall),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.playlist_add),
                        label: const Text(S.prepInsertOutline),
                        onPressed: () {
                          final c = ref.read(prepProvider.notifier);
                          for (final (k, t) in items) {
                            c.addBlock(prepId, k, text: t);
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

// --- Prezentace ---------------------------------------------------------------

/// Prezentační režim: velké písmo, listování po blocích a stopky.
class PrepPresentScreen extends ConsumerStatefulWidget {
  const PrepPresentScreen({super.key, required this.prepId});

  final int prepId;

  @override
  ConsumerState<PrepPresentScreen> createState() => _PrepPresentScreenState();
}

class _PrepPresentScreenState extends ConsumerState<PrepPresentScreen> {
  final _pages = PageController();
  final _watch = Stopwatch()..start();
  late final Timer _tick;
  double _scale = 1;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick.cancel();
    _pages.dispose();
    super.dispose();
  }

  void _go(int delta, int count) {
    final target = (_page + delta).clamp(0, count - 1);
    _pages.animateToPage(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final prep = ref.watch(prepProvider.notifier).byId(widget.prepId);
    if (prep == null) return const Scaffold();
    final blocks = prep.blocks
        .where((b) => b.text.trim().isNotEmpty || b.passage != null)
        .toList();
    final count = blocks.length + 1;
    const ink = Color(0xFFF3E6CC);
    final e = _watch.elapsed;
    final time =
        '${e.inMinutes}:${(e.inSeconds % 60).toString().padLeft(2, '0')}';
    return Scaffold(
      backgroundColor: const Color(0xFF15120F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        title: Text(
          '$time  ·  ${_page + 1}/$count',
          style: const TextStyle(
            color: ink,
            fontSize: 17,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        actions: [
          IconButton(
            tooltip: S.smallerText,
            icon: const Icon(Icons.text_decrease),
            onPressed: () =>
                setState(() => _scale = (_scale - 0.15).clamp(0.7, 2.0)),
          ),
          IconButton(
            tooltip: S.largerText,
            icon: const Icon(Icons.text_increase),
            onPressed: () =>
                setState(() => _scale = (_scale + 0.15).clamp(0.7, 2.0)),
          ),
        ],
      ),
      body: GestureDetector(
        onTapUp: (d) {
          final w = MediaQuery.sizeOf(context).width;
          _go(d.localPosition.dx > w / 3 ? 1 : -1, count);
        },
        child: PageView.builder(
          controller: _pages,
          itemCount: count,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (context, i) => Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: i == 0
                    ? _Slide(
                        title: prep.title.isEmpty ? S.prepUntitled : prep.title,
                        subtitle: prep.passage == null
                            ? prep.kind.label
                            : passageLabel(ref, prep.passage!),
                        scale: _scale,
                        big: true,
                      )
                    : _BlockSlide(block: blocks[i - 1], scale: _scale),
              ),
            ),
          ),
        ),
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
  });

  final String title;
  final String? subtitle;
  final String? body;
  final double scale;
  final bool big;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFFF3E6CC);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: big ? ink : color,
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
            child: Text(
              b,
              style: TextStyle(
                color: ink,
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

class _BlockSlide extends ConsumerWidget {
  const _BlockSlide({required this.block, required this.scale});

  final PrepBlock block;
  final double scale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = block;
    final color = Color.lerp(_blockColor(b.kind), Colors.white, 0.35)!;
    if (b.passage case final p?) {
      final t = ref.watch(primaryTranslationProvider);
      final verses = ref.watch(passageTextProvider((t.id, p))).value;
      final text = verses?.map((v) => v.text.replaceAll('\n', ' ')).join(' ');
      return _Slide(
        title: '${passageLabel(ref, p)} · ${t.abbreviation}',
        body: [?text, if (b.text.isNotEmpty) '\n${b.text}'].join(),
        scale: scale,
        color: color,
      );
    }
    if (b.kind == PrepBlockKind.heading) {
      return _Slide(title: b.text, scale: scale, big: true, color: color);
    }
    return _Slide(
      title: b.kind.label,
      body: b.text,
      scale: scale,
      color: color,
    );
  }
}
