import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/services/versification.dart';
import '../../reader/application/reader_state.dart';
import '../../reader/presentation/note_editor_sheet.dart';
import '../../reader/presentation/reflection_sheet.dart';
import '../../shell/home_shell.dart';
import '../../translations/application/translation_controller.dart';
import '../application/today_providers.dart';

final _notesProvider = StreamProvider.autoDispose<List<Note>>(
  (ref) => ref.watch(userDataRepositoryProvider).watchAllNotes(),
);

/// Krátké myšlenky o čtení jako setkání s Bohem (vlastní texty aplikace).
const _thoughts = [
  'Čtení Bible není výkon. Je to čas, kdy Bůh mluví a vy nasloucháte.',
  'Nemusíte rozumět všemu. Stačí si odnést do dne jednu větu.',
  'Než začnete, řekněte jednoduše: „Mluv, Pane, tvůj služebník slyší.“ '
      '(1S 3,10)',
  'Bůh vás hledá dřív, než vy hledáte jeho.',
  'Raději deset minut každý den než hodinu jednou za měsíc.',
  'Co vás v textu zastaví, o tom si s Bohem promluvte.',
  'Vztah roste rozhovorem: čtěte, ptejte se a odpovídejte modlitbou.',
  'Když nevíte, jak se modlit, přečtěte žalm a modlete se jeho slovy.',
  'Ve dnech, kdy se nic nestane, se stává nejvíc: zvykáte si na Boží hlas.',
  'Čtěte pomalu. Jedna kapitola přečtená se srdcem je víc než pět '
      'přelétnutých.',
];

/// Verše pro návrat ke čtení (kanonické číslování).
const _welcomeVerses = [
  VerseRef(42, 15, 20), // L 15,20 – otec vybíhá synovi naproti
  VerseRef(40, 11, 28), // Mt 11,28
  VerseRef(24, 29, 13), // Jr 29,13
  VerseRef(59, 4, 8), // Jk 4,8
  VerseRef(66, 3, 20), // Zj 3,20
  VerseRef(25, 3, 23), // Pl 3,23
  VerseRef(23, 55, 6), // Iz 55,6
];

/// Krátké žalmy na nový začátek.
const _shortPsalms = [23, 27, 34, 46, 62, 91, 103, 121, 130, 139];

/// Pozvání ke čtení podle toho, jak člověk čte: první začátek, návrat po
/// pauze (bez výčitek), nebo dnešní krok s ohlédnutím za vlastními
/// zamyšleními. Pod tím rytmus týdne.
class InvitationCard extends ConsumerWidget {
  const InvitationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daily = ref.watch(dailyReadingProvider).value;
    if (daily == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Den v roce určuje, která myšlenka a verš se dnes ukážou.
    final day = today.difference(DateTime(2024)).inDays;
    final last = daily.keys.isEmpty
        ? null
        : daily.keys.reduce((a, b) => a.isAfter(b) ? a : b);
    final gap = last == null ? null : today.difference(last).inDays;

    final String title;
    final Widget body;
    Widget? action;
    if (gap == null) {
      title = S.inviteStartTitle;
      body = _Text(S.inviteStartText);
      action = FilledButton.tonalIcon(
        onPressed: () => openReaderAt(context, ref, const VerseRef(41, 1, 1)),
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text(S.inviteStartButton),
      );
    } else if (gap >= 2) {
      final psalm = _shortPsalms[day % _shortPsalms.length];
      title = S.inviteBackTitle;
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Text(S.inviteBackText),
          const SizedBox(height: 10),
          _WelcomeVerse(_welcomeVerses[day % _welcomeVerses.length]),
        ],
      );
      action = FilledButton.tonalIcon(
        onPressed: () => openReaderAt(context, ref, VerseRef(19, psalm, 1)),
        icon: const Icon(Icons.play_arrow_rounded),
        label: Text(S.inviteBackButton(psalm)),
      );
    } else {
      final lookBack = gap == 0 ? _lookBack(ref, today, day) : null;
      title = gap == 0 ? S.inviteTodayTitle : S.inviteStepTitle;
      body = lookBack == null
          ? _Text(_thoughts[day % _thoughts.length])
          : _LookBack(note: lookBack, today: today);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite_outline, size: 18, color: palette.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            body,
            if (action != null) ...[const SizedBox(height: 12), action],
            const SizedBox(height: 14),
            _WeekRhythm(daily: daily, today: today),
          ],
        ),
      ),
    );
  }

  /// Zamyšlení starší než týden, ke kterému se dnes vrátit.
  Note? _lookBack(WidgetRef ref, DateTime today, int day) {
    final notes = ref.watch(_notesProvider).value ?? const <Note>[];
    final old = [
      for (final n in notes)
        if (isReflectionNote(n.body) &&
            today.difference(n.createdAt).inDays >= 7 &&
            parseReflection(n.body).isNotEmpty)
          n,
    ];
    return old.isEmpty ? null : old[day % old.length];
  }
}

class _Text extends StatelessWidget {
  const _Text(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.45),
  );
}

/// Verš pro návrat – v překladu, který čtenář používá.
class _WelcomeVerse extends ConsumerWidget {
  const _WelcomeVerse(this.verseRef);

  final VerseRef verseRef;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translationId = ref.watch(primaryTranslationProvider).id;
    final local = Versification.fromCanonical(verseRef, translationId);
    final verse = ref.watch(verseTextProvider((translationId, local))).value;
    final book = ref.watch(bookByIdProvider(verseRef.bookId));
    if (verse == null) return const SizedBox.shrink();
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => openReaderAt(context, ref, verseRef),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: palette.gold, width: 3)),
        ),
        child: Text(
          '„${verse.text.replaceAll('\n', ' ')}“ '
          '(${book.abbreviation} ${local.chapter},${local.verse})',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontFamily: appFontFamily,
            fontStyle: FontStyle.italic,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

/// Ohlédnutí: co jsem si kdysi zapsal(a) – připomínka cesty s Bohem.
class _LookBack extends ConsumerWidget {
  const _LookBack({required this.note, required this.today});

  final Note note;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final book = ref.watch(bookByIdProvider(note.ref.bookId));
    final title = '${book.name} ${note.ref.chapter}';
    final days = today.difference(note.createdAt).inDays;
    final answer = parseReflection(note.body).first.$2;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (route) => ReflectionNoteScreen(
            note: note,
            title: title,
            onEdit: () {
              Navigator.of(route).pop();
              showNoteEditor(context, existing: note);
            },
            onOpenChapter: () {
              Navigator.of(route).pop();
              openReaderAt(context, ref, note.ref);
            },
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.inviteLookBack(title, days),
            style: theme.textTheme.labelMedium?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 4),
          Text(
            '„${answer.replaceAll('\n', ' ')}“',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sedm dní týdne: kdy jsem četl(a). Bez počítání a bez výčitek.
class _WeekRhythm extends StatelessWidget {
  const _WeekRhythm({required this.daily, required this.today});

  final Map<DateTime, int> daily;
  final DateTime today;

  static const _days = ['Po', 'Út', 'St', 'Čt', 'Pá', 'So', 'Ne'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return Row(
      children: [
        for (var i = 0; i < 7; i++)
          Expanded(
            child: Builder(
              builder: (context) {
                final d = DateTime(monday.year, monday.month, monday.day + i);
                final read = (daily[d] ?? 0) > 0;
                final isToday = d == today;
                return Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: read ? palette.gold : null,
                        border: Border.all(
                          color: read || isToday
                              ? palette.gold
                              : palette.cardBorder,
                          width: isToday ? 2 : 1.2,
                        ),
                      ),
                      child: read
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _days[i],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isToday ? palette.gold : palette.muted,
                        fontWeight: isToday ? FontWeight.w700 : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }
}
