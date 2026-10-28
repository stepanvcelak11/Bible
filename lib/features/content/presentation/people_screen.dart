import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../../search/application/reference_parser.dart';
import '../application/content_providers.dart';
import 'passage_card.dart';

Future<void> openPerson(BuildContext context, BiblePerson person) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PersonScreen(person: person)),
    );

const _otColor = Color(0xFFB7792F);
const _ntColor = Color(0xFF3F7CAC);

/// Seznam medailonů postav s hledáním.
class PeopleScreen extends ConsumerStatefulWidget {
  const PeopleScreen({super.key});

  @override
  ConsumerState<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends ConsumerState<PeopleScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(peopleProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final q = foldCzech(_query.trim());
    final filtered = people
        ?.where(
          (p) =>
              q.isEmpty ||
              foldCzech(p.name).contains(q) ||
              foldCzech(p.role).contains(q),
        )
        .toList();

    Widget group(String title, Color color, List<BiblePerson> list) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
          child: Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              for (final (i, p) in list.indexed) ...[
                if (i > 0) const Divider(height: 1, indent: 64),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.14),
                    foregroundColor: color,
                    child: Text(
                      p.name.characters.first,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  title: Text(p.name),
                  subtitle: Text(
                    p.role,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => openPerson(context, p),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.people)),
        body: filtered == null
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
                    S.peopleIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: S.findPerson,
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
                  if (filtered.any((p) => !p.isNewTestament))
                    group(S.oldTestament, _otColor, [
                      for (final p in filtered)
                        if (!p.isNewTestament) p,
                    ]),
                  if (filtered.any((p) => p.isNewTestament))
                    group(S.newTestament, _ntColor, [
                      for (final p in filtered)
                        if (p.isNewTestament) p,
                    ]),
                ],
              ),
      ),
    );
  }
}

/// Medailon jedné postavy.
class PersonScreen extends ConsumerWidget {
  const PersonScreen({super.key, required this.person});

  final BiblePerson person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final books = ref.watch(booksProvider);
    final color = person.isNewTestament ? _ntColor : _otColor;

    Widget list(String title, IconData icon, Color c, List<String> items) =>
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: c, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: c,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8, right: 10),
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );

    Widget fact(String label, String value) => value.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      color: palette.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: value),
                ],
              ),
              style: theme.textTheme.bodyMedium,
            ),
          );

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Text(person.name, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 2),
            Text(
              person.role,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            fact(S.personWhere, person.where),
            fact(S.personOccupation, person.occupation),
            fact(S.personRelatives, person.relatives),
            fact(
              S.personBooks,
              person.books.map((b) => books[b - 1].name).join(', '),
            ),
            const SizedBox(height: 8),
            list(
              S.strengths,
              Icons.thumb_up_alt_outlined,
              const Color(0xFF2E8B57),
              person.strengths,
            ),
            if (person.weaknesses.isNotEmpty)
              list(
                S.weaknesses,
                Icons.warning_amber_rounded,
                const Color(0xFFB0603A),
                person.weaknesses,
              ),
            list(
              S.lessons,
              Icons.lightbulb_outline,
              palette.gold,
              person.lessons,
            ),
            const SizedBox(height: 8),
            Text(S.keyVerse, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            PassageCard(passage: person.key, accent: color),
            const SizedBox(height: 8),
            Text(S.personStory, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in person.story)
                  ActionChip(
                    label: Text(p.label(books[p.bookId - 1].abbreviation)),
                    onPressed: () => showPassageSheet(context, p),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
