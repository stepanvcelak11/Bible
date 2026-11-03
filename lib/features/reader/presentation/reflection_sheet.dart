import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/versification.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../content/application/content_providers.dart';
import '../../prayer/application/prayer_controller.dart';
import '../../translations/application/translation_controller.dart';
import '../application/chapter_content_provider.dart';
import '../../plans/application/plans.dart';
import '../../plans/presentation/plans_screen.dart';

/// Obecné otázky k zamyšlení (doplňují otázky ke konkrétní kapitole).
const reflectionQuestions = [
  'Co mě v kapitole nejvíc oslovilo nebo překvapilo?',
  'Co se tu dozvídám o Bohu (o Ježíši)?',
  'Co se tu dozvídám o člověku – a o sobě?',
  'Co s tím udělám? Za co se chci pomodlit?',
];

/// Krok zamyšlení.
class _Step {
  const _Step(this.label, this.icon, this.color, this.question);

  final String label;
  final IconData icon;
  final Color color;
  final String question;
}

/// Kroky: obecné otázky prokládané otázkami ke kapitole – od pozorování
/// přes porozumění k životu a modlitbě.
List<_Step> _steps(ChapterReflection? r) => [
  _Step(
    S.stepNotice,
    Icons.visibility_outlined,
    const Color(0xFFC08A2E),
    reflectionQuestions[0],
  ),
  if (r != null) ...[
    _Step(S.stepObserve, Icons.search, const Color(0xFF3F7CAC), r.observe),
    _Step(
      S.stepUnderstand,
      Icons.lightbulb_outline,
      const Color(0xFF8C6BA8),
      r.understand,
    ),
  ],
  _Step(
    S.stepGod,
    Icons.wb_sunny_outlined,
    const Color(0xFFD1A23A),
    reflectionQuestions[1],
  ),
  _Step(
    S.stepHuman,
    Icons.person_outline,
    const Color(0xFF4E9A8A),
    reflectionQuestions[2],
  ),
  if (r != null)
    _Step(S.stepLife, Icons.favorite_border, const Color(0xFFC0503A), r.life),
  _Step(
    S.stepPray,
    Icons.volunteer_activism_outlined,
    const Color(0xFF3E8E5E),
    reflectionQuestions[3],
  ),
];

/// Otevře zamyšlení nad kapitolou [chapter] (číslování hlavního překladu).
Future<void> showReflectionSheet(
  BuildContext context, {
  required int bookId,
  required int chapter,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => ReflectionScreen(bookId: bookId, chapter: chapter),
  ),
);

/// Zamyšlení krok za krokem: každá otázka na vlastní stránce, předchozí
/// odpověď je připomenuta u další otázky; na konci shrnutí a uložení.
class ReflectionScreen extends ConsumerStatefulWidget {
  const ReflectionScreen({
    super.key,
    required this.bookId,
    required this.chapter,
  });

  final int bookId;
  final int chapter;

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  final _page = PageController();
  final _controllers = <TextEditingController>[];
  int _index = 0;
  bool _addPrayer = false;

  /// Text kapitoly otevřený vedle otázek – odpovědi hledat v Bibli.
  bool _showText = false;

  @override
  void dispose() {
    _page.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _hasText => _controllers.any((c) => c.text.trim().isNotEmpty);

  /// Připíše odkaz na verš k právě rozepsané odpovědi.
  void _cite(int verse) {
    if (_index >= _controllers.length) return;
    final c = _controllers[_index];
    final t = c.text;
    final add =
        '${t.isEmpty || t.endsWith(' ') || t.endsWith('\n') ? '' : ' '}'
        '(v. $verse) ';
    c.value = TextEditingValue(
      text: t + add,
      selection: TextSelection.collapsed(offset: t.length + add.length),
    );
    setState(() {});
  }

  void _go(int index) {
    FocusScope.of(context).unfocus();
    setState(() => _index = index);
    _page.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _save(List<_Step> steps) async {
    final book = ref.read(bookByIdProvider(widget.bookId)).name;
    final translationId = ref.read(translationControllerProvider).primaryId;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final body = [
      S.reflectionTitle(book, widget.chapter),
      for (final (i, step) in steps.indexed)
        if (_controllers[i].text.trim().isNotEmpty)
          '${step.question}\n${_controllers[i].text.trim()}',
    ].join('\n\n');
    await ref
        .read(userDataRepositoryProvider)
        .saveNote(
          ref: Versification.toCanonical(
            VerseRef(widget.bookId, widget.chapter, 1),
            translationId,
          ),
          body: body,
        );
    final last = _controllers.last.text.trim();
    if (_addPrayer && last.isNotEmpty) {
      ref.read(prayerProvider.notifier).add(last);
    }
    navigator.pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text(S.reflectionSaved),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(widget.bookId)).name;
    final translationId = ref.watch(primaryTranslationProvider).id;
    final canonical = Versification.toCanonical(
      VerseRef(widget.bookId, widget.chapter, 1),
      translationId,
    );
    final all = ref.watch(reflectionsProvider).value;
    final chapters = all?[canonical.bookId];
    final reflection = chapters != null && canonical.chapter <= chapters.length
        ? chapters[canonical.chapter - 1]
        : null;
    final steps = _steps(reflection);
    while (_controllers.length < steps.length) {
      _controllers.add(TextEditingController());
    }
    final total = steps.length + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.reflectionTitle(book, widget.chapter)),
        actions: [
          IconButton(
            tooltip: S.reflectionText,
            isSelected: _showText,
            onPressed: () => setState(() => _showText = !_showText),
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
          ),
          TextButton(
            onPressed: _hasText ? () => _save(steps) : null,
            child: const Text(S.reflectionSaveShort),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (var i = 0; i < total; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: i <= _index
                            ? (i < steps.length ? steps[i].color : palette.gold)
                            : palette.cardBorder,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: _withText(
        translationId,
        PageView(
          controller: _page,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final (i, step) in steps.indexed)
              _StepPage(
                step: step,
                index: i,
                total: steps.length,
                focus: i == 0 ? reflection?.focus : null,
                previous: i == 0 ? null : _controllers[i - 1].text.trim(),
                previousQuestion: i == 0 ? null : steps[i - 1].question,
                controller: _controllers[i],
                onChanged: () => setState(() {}),
                onBack: i == 0 ? null : () => _go(i - 1),
                onNext: () => _go(i + 1),
                onShowText: _showText
                    ? null
                    : () => setState(() => _showText = true),
              ),
            _Summary(
              steps: steps,
              controllers: _controllers,
              addPrayer: _addPrayer,
              onAddPrayer: (v) => setState(() => _addPrayer = v),
              onBack: () => _go(steps.length - 1),
              onSave: _hasText ? () => _save(steps) : null,
            ),
          ],
        ),
      ),
    );
  }

  /// Otázky samotné, nebo vedle (na úzkém displeji pod) textem kapitoly.
  Widget _withText(String translationId, Widget questions) {
    if (!_showText) return ReadableWidth(child: questions);
    final text = _ChapterTextPanel(
      translationId: translationId,
      bookId: widget.bookId,
      chapter: widget.chapter,
      onVerse: _cite,
    );
    return LayoutBuilder(
      builder: (context, c) => c.maxWidth >= 900
          ? Row(
              children: [
                Expanded(child: text),
                const VerticalDivider(width: 1),
                Expanded(child: questions),
              ],
            )
          : Column(
              children: [
                Expanded(flex: 4, child: text),
                const Divider(height: 1),
                Expanded(flex: 5, child: questions),
              ],
            ),
    );
  }
}

/// Text kapitoly v hlavním překladu; klepnutí na verš ho připíše k odpovědi.
class _ChapterTextPanel extends ConsumerWidget {
  const _ChapterTextPanel({
    required this.translationId,
    required this.bookId,
    required this.chapter,
    required this.onVerse,
  });

  final String translationId;
  final int bookId;
  final int chapter;
  final ValueChanged<int> onVerse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final content = ref
        .watch(
          chapterPageProvider((
            primaryId: translationId,
            secondaryId: null,
            bookId: bookId,
            chapter: chapter,
          )),
        )
        .value;
    if (content is! SingleChapter) {
      return const Center(child: CircularProgressIndicator());
    }
    final verses = content.text.verses;
    return ColoredBox(
      color: palette.card,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        itemCount: verses.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                S.reflectionTextHint,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: palette.muted,
                ),
              ),
            );
          }
          final v = verses[i - 1];
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onVerse(v.ref.verse),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${v.ref.verse} ',
                      style: TextStyle(
                        color: palette.gold,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(text: v.text.replaceAll('\n', ' ')),
                  ],
                ),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: appFontFamily,
                  height: 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  const _StepPage({
    required this.step,
    required this.index,
    required this.total,
    required this.focus,
    required this.previous,
    required this.previousQuestion,
    required this.controller,
    required this.onChanged,
    required this.onBack,
    required this.onNext,
    required this.onShowText,
  });

  final _Step step;
  final int index;
  final int total;
  final String? focus;
  final String? previous;
  final String? previousQuestion;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final VoidCallback? onBack;
  final VoidCallback onNext;

  /// Otevře text kapitoly (null = už je otevřený).
  final VoidCallback? onShowText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final answered = controller.text.trim().isNotEmpty;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.viewInsetsOf(context).bottom + 32,
      ),
      children: [
        if (focus case final f?) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: palette.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: palette.gold.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.reflectionAbout.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.gold,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(f, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        Row(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 5, 12, 5),
              decoration: BoxDecoration(
                color: step.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(step.icon, size: 18, color: step.color),
                  const SizedBox(width: 6),
                  Text(
                    step.label,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: step.color,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              S.reflectionStep(index + 1, total),
              style: theme.textTheme.labelMedium?.copyWith(
                color: palette.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          step.question,
          style: theme.textTheme.headlineSmall?.copyWith(height: 1.3),
        ),
        if (onShowText != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              onPressed: onShowText,
              icon: const Icon(Icons.menu_book_outlined, size: 18),
              label: const Text(S.reflectionFindInText),
            ),
          ),
        if (previous case final p? when p.isNotEmpty) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: palette.cardBorder, width: 3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.reflectionPrevious,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: palette.muted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  p,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: palette.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          minLines: 3,
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            hintText: S.reflectionHint,
            filled: true,
            fillColor: palette.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: palette.cardBorder),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            if (onBack != null)
              IconButton.outlined(
                tooltip: S.reflectionBack,
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back, size: 18),
              ),
            const Spacer(),
            if (!answered)
              TextButton(
                onPressed: onNext,
                child: const Text(S.reflectionSkip),
              ),
            const SizedBox(width: 6),
            FilledButton.icon(
              onPressed: onNext,
              style: FilledButton.styleFrom(backgroundColor: step.color),
              icon: Icon(
                index + 1 == total ? Icons.check : Icons.arrow_forward,
                size: 18,
              ),
              label: Text(
                index + 1 == total ? S.reflectionDone : S.reflectionNext,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.steps,
    required this.controllers,
    required this.addPrayer,
    required this.onAddPrayer,
    required this.onBack,
    required this.onSave,
  });

  final List<_Step> steps;
  final List<TextEditingController> controllers;
  final bool addPrayer;
  final ValueChanged<bool> onAddPrayer;
  final VoidCallback onBack;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final answered = [
      for (final (i, s) in steps.indexed)
        if (controllers[i].text.trim().isNotEmpty)
          (s, controllers[i].text.trim()),
    ];
    final last = controllers.last.text.trim();
    return ListView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.paddingOf(context).bottom + 32,
      ),
      children: [
        Text(S.reflectionSummary, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 12),
        if (answered.isEmpty)
          Text(
            S.reflectionEmpty,
            style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
          ),
        for (final (s, a) in answered)
          Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(s.icon, size: 16, color: s.color),
                      const SizedBox(width: 6),
                      Text(
                        s.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: s.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s.question,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(a, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ),
        if (last.isNotEmpty)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: addPrayer,
            onChanged: onAddPrayer,
            secondary: const Icon(Icons.volunteer_activism_outlined),
            title: const Text(S.reflectionAddPrayer),
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onSave,
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text(S.reflectionSave),
        ),
        const SizedBox(height: 6),
        TextButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text(S.reflectionBack),
        ),
      ],
    );
  }
}

/// Konec kapitoly: zamyšlení a přechod na další kapitolu.
class ChapterFooter extends ConsumerWidget {
  const ChapterFooter({
    super.key,
    required this.bookId,
    required this.chapter,
    required this.onNext,
  });

  final int bookId;
  final int chapter;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translationId = ref.watch(primaryTranslationProvider).id;
    final canonical = Versification.toCanonical(
      VerseRef(bookId, chapter, 1),
      translationId,
    );
    final plans = ref.watch(
      chapterPlansProvider((canonical.bookId, canonical.chapter)),
    );
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        children: [
          Container(width: 48, height: 2, color: palette.gold),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
              leading: Icon(Icons.self_improvement, color: palette.gold),
              title: const Text(S.reflection),
              subtitle: const Text(S.reflectionHintShort),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => showReflectionSheet(
                context,
                bookId: bookId,
                chapter: chapter,
              ),
            ),
          ),
          // Plán města nebo stavby, o které kapitola mluví.
          for (final p in plans)
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
                leading: Icon(
                  Icons.account_balance_outlined,
                  color: palette.gold,
                ),
                title: Text(S.planForChapter(p.title)),
                subtitle: Text(p.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openPlan(context, p),
              ),
            ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onNext,
            icon: const Icon(Icons.arrow_forward),
            label: Text(S.nextChapter, style: theme.textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}

/// Je poznámka uložené zamyšlení nad kapitolou?
bool isReflectionNote(String body) => body.startsWith(S.reflectionPrefix);

/// Otázky a odpovědi uloženého zamyšlení (odstavce „otázka?\nodpověď“).
/// Prázdné řádky uvnitř odpovědi zůstanou u ní.
List<(String, String)> parseReflection(String body) {
  final out = <(String, String)>[];
  for (final block in body.split('\n\n').skip(1)) {
    final nl = block.indexOf('\n');
    final first = nl < 0 ? block : block.substring(0, nl);
    if (nl > 0 && first.trimRight().endsWith('?')) {
      out.add((first.trim(), block.substring(nl + 1).trim()));
    } else if (out.isNotEmpty) {
      final (q, a) = out.removeLast();
      out.add((q, '$a\n\n$block'));
    } else {
      out.add(('', block.trim()));
    }
  }
  return out;
}

/// Uložené zamyšlení k pročtení: otázky a odpovědi, úprava, kapitola.
class ReflectionNoteScreen extends ConsumerWidget {
  const ReflectionNoteScreen({
    super.key,
    required this.note,
    required this.title,
    required this.onEdit,
    required this.onOpenChapter,
  });

  final Note note;
  final String title;
  final VoidCallback onEdit;
  final VoidCallback onOpenChapter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final d = note.createdAt;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: S.edit,
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ReadableWidth(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Text(
              '${d.day}. ${d.month}. ${d.year}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: palette.muted,
              ),
            ),
            const SizedBox(height: 12),
            for (final (q, a) in parseReflection(note.body))
              Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (q.isNotEmpty) ...[
                        Text(
                          q,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.gold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(a, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onOpenChapter,
              icon: const Icon(Icons.menu_book_outlined),
              label: const Text(S.openChapter),
            ),
          ],
        ),
      ),
    );
  }
}
