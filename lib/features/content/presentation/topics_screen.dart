import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../search/application/reference_parser.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/widgets/section_label.dart';
import '../../../domain/entities/content_entities.dart';
import '../application/content_providers.dart';
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
        t.labels.any((l) => foldCzech(l).contains(q));

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
                  for (final (id, name) in data.$1)
                    if (data.$2.any((t) => t.category == id && hit(t))) ...[
                      SectionLabel(name),
                      Card(
                        child: Column(
                          children: [
                            for (final (i, t)
                                in data.$2
                                    .where((t) => t.category == id && hit(t))
                                    .indexed) ...[
                              if (i > 0) const Divider(height: 1, indent: 64),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: topicColor(t)
                                      .withValues(alpha: 0.14),
                                  foregroundColor: topicColor(t),
                                  child: Icon(
                                    situationIcons[t.icon] ??
                                        Icons.menu_book_outlined,
                                    size: 20,
                                  ),
                                ),
                                title: Text(t.title),
                                subtitle: Text(
                                  t.summary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => openTopic(context, t),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                ],
              ),
      ),
    );
  }
}

/// Jedno téma: shrnutí a klíčová místa.
class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key, required this.topic});

  final BibleTopic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = topicColor(topic);
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
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    situationIcons[topic.icon] ?? Icons.menu_book_outlined,
                    color: color,
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      topic.summary,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SectionLabel(S.keyPassages),
            for (final (i, p) in topic.passages.indexed)
              PassageCard(passage: p, accent: color, title: topic.labels[i]),
          ],
        ),
      ),
    );
  }
}
