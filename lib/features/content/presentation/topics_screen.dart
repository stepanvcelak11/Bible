import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../search/application/reference_parser.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../application/content_providers.dart';
import '../../study/presentation/study_blocks.dart';
import 'passage_card.dart';
import 'situations_screen.dart';

const _topicColors = {
  'god': Color(0xFFB0813B),
  'jesus': Color(0xFFB0603A),
  'salvation': Color(0xFF8C4A6B),
  'life': Color(0xFF3F7CAC),
  'relations': Color(0xFF2E8B57),
  'church': Color(0xFF8C6BA8),
  'future': Color(0xFF4E9A8A),
  'story': Color(0xFF7A55A8),
  'world': Color(0xFF5B6E8C),
};

Color topicColor(BibleTopic t) =>
    _topicColors[t.category] ?? const Color(0xFFB0813B);

Future<void> openTopic(BuildContext context, BibleTopic topic) => Navigator.of(
  context,
).push(MaterialPageRoute<void>(builder: (_) => TopicScreen(topic: topic)));

/// Rejstřík biblických témat podle oblastí.
class TopicsScreen extends ConsumerStatefulWidget {
  const TopicsScreen({super.key});

  @override
  ConsumerState<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends ConsumerState<TopicsScreen> {
  String _query = '';

  /// Vybraná oblast (`null` = přehled všech).
  String? _category;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(topicsProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final q = foldCzech(_query.trim());
    bool hit(BibleTopic t) =>
        q.isEmpty ||
        foldCzech(t.title).contains(q) ||
        foldCzech(t.summary).contains(q) ||
        t.labels.any((l) => foldCzech(l).contains(q)) ||
        t.deeper.any((l) => foldCzech(l).contains(q));

    Widget topicTile(BibleTopic t) => ListTile(
      contentPadding: const EdgeInsets.fromLTRB(14, 6, 10, 6),
      leading: CircleAvatar(
        backgroundColor: topicColor(t).withValues(alpha: 0.14),
        foregroundColor: topicColor(t),
        child: Icon(
          situationIcons[t.icon] ?? Icons.menu_book_outlined,
          size: 20,
        ),
      ),
      title: Text(t.title),
      subtitle: Text(t.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => openTopic(context, t),
    );

    // Přehled: každá oblast jako karta se štítky témat.
    Widget overviewCard(String id, String name, List<BibleTopic> topics) {
      final color = _topicColors[id] ?? palette.gold;
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _category = id),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${topics.length}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 20, color: palette.muted),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final t in topics)
                    Material(
                      color: color.withValues(alpha: 0.1),
                      shape: const StadiumBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => openTopic(context, t),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                situationIcons[t.icon] ??
                                    Icons.menu_book_outlined,
                                size: 16,
                                color: color,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  t.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final List<Widget> body;
    if (data == null) {
      body = const [];
    } else if (q.isNotEmpty || _category != null) {
      final found = [
        for (final t in data.$2)
          if ((_category == null || t.category == _category) && hit(t)) t,
      ];
      body = [
        if (found.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              S.studyNoResults,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (final (i, t) in found.indexed) ...[
                  if (i > 0) const Divider(height: 1, indent: 64),
                  topicTile(t),
                ],
              ],
            ),
          ),
      ];
    } else {
      body = [
        for (final (id, name) in data.$1)
          if (data.$2.where((t) => t.category == id).toList() case final topics
              when topics.isNotEmpty)
            overviewCard(id, name, topics),
      ];
    }

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.topics)),
        body: data == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  MediaQuery.paddingOf(context).bottom + 32,
                ),
                children: [
                  Text(
                    S.topicsIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: S.findTopic,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: palette.card,
                      isDense: true,
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
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: const Text(S.all),
                            selected: _category == null,
                            onSelected: (_) => setState(() => _category = null),
                          ),
                        ),
                        for (final (id, name) in data.$1)
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              avatar: CircleAvatar(
                                radius: 5,
                                backgroundColor:
                                    _topicColors[id] ?? palette.gold,
                              ),
                              label: Text(name),
                              selected: _category == id,
                              onSelected: (on) =>
                                  setState(() => _category = on ? id : null),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...body,
                ],
              ),
      ),
    );
  }
}

/// Jedno téma: shrnutí, výklad, zajímavosti, klíčová místa a otázky.
class TopicScreen extends ConsumerWidget {
  const TopicScreen({super.key, required this.topic});

  final BibleTopic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = topicColor(topic);
    final categories = ref.watch(topicsProvider).value?.$1 ?? const [];
    final category = [
      for (final (id, name) in categories)
        if (id == topic.category) name,
    ].firstOrNull;
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: Text(topic.title)),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            StudyHero(
              color: color,
              icon: situationIcons[topic.icon] ?? Icons.menu_book_outlined,
              kicker: category ?? S.topics,
              title: topic.title,
              subtitle: topic.summary,
            ),
            if (topic.deeper.isNotEmpty) ...[
              StudyHeading(
                S.deeper,
                color: color,
                icon: Icons.travel_explore_outlined,
              ),
              StudyParagraphs(topic.deeper),
            ],
            if (topic.facts.isNotEmpty)
              FactsCard(facts: topic.facts, color: color),
            const SectionLabel(S.keyPassages),
            for (final (i, p) in topic.passages.indexed)
              PassageCard(passage: p, accent: color, title: topic.labels[i]),
            if (topic.questions.isNotEmpty) ...[
              StudyHeading(
                S.toReflect,
                color: color,
                icon: Icons.question_answer_outlined,
              ),
              QuestionsBlock(questions: topic.questions, color: color),
            ],
          ],
        ),
      ),
    );
  }
}
