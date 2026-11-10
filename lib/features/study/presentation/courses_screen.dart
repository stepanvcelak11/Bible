import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../domain/entities/content_entities.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/passage_card.dart';
import '../../content/presentation/situations_screen.dart';
import '../../content/presentation/topics_screen.dart';
import '../application/course_progress.dart';
import 'study_blocks.dart';

Color courseColor(StudyCourse c) => Color(c.color);

IconData courseIcon(StudyCourse c) =>
    situationIcons[c.icon] ?? Icons.school_outlined;

Future<void> openCourses(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const CoursesScreen()));

Future<void> openCourse(BuildContext context, StudyCourse course) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CourseScreen(course: course)),
    );

Future<void> openLesson(
  BuildContext context,
  StudyCourse course,
  CourseLesson lesson, {
  bool replace = false,
}) {
  final route = MaterialPageRoute<void>(
    builder: (_) => LessonScreen(course: course, lesson: lesson),
  );
  return replace
      ? Navigator.of(context).pushReplacement(route)
      : Navigator.of(context).push(route);
}

/// Přehled studijních kurzů.
class CoursesScreen extends ConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final courses = ref.watch(coursesProvider).value;
    final done = ref.watch(courseProgressProvider);
    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.courses)),
        body: courses == null
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
                    S.coursesIntro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  for (final c in courses)
                    CourseCard(course: c, done: done.doneIn(c)),
                ],
              ),
      ),
    );
  }
}

/// Karta kurzu s ukazatelem pokroku.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, required this.done});

  final StudyCourse course;
  final int done;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = courseColor(course);
    final all = course.lessons.length;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openCourse(context, course),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.16),
                color.withValues(alpha: 0.02),
              ],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      courseIcon(course),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          course.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.muted,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (done == all)
                    Icon(Icons.verified, color: color)
                  else
                    const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: all == 0 ? 0 : done / all,
                        minHeight: 6,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    done == 0
                        ? S.lessonsCount(all)
                        : S.lessonsProgress(done, all),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: palette.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Jeden kurz: úvod a seznam lekcí.
class CourseScreen extends ConsumerWidget {
  const CourseScreen({super.key, required this.course});

  final StudyCourse course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = courseColor(course);
    final done = ref.watch(courseProgressProvider);
    final count = done.doneIn(course);
    final next = done.nextIn(course);
    final all = course.lessons.length;

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.title),
          actions: [
            if (count > 0)
              PopupMenuButton<void>(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () => ref
                        .read(courseProgressProvider.notifier)
                        .resetCourse(course),
                    child: const Text(S.courseReset),
                  ),
                ],
              ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, Color.lerp(color, Colors.black, 0.35)!],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(courseIcon(course), color: Colors.white, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          course.subtitle,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    course.intro,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: count / all,
                      minHeight: 6,
                      color: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    S.lessonsProgress(count, all),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: color,
                    ),
                    onPressed: () =>
                        openLesson(context, course, next ?? course.lessons[0]),
                    icon: Icon(
                      next == null ? Icons.replay : Icons.play_arrow_rounded,
                    ),
                    label: Text(
                      next == null
                          ? S.courseRestart
                          : count == 0
                          ? S.courseStart
                          : S.courseContinue(next.index + 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Column(
                children: [
                  for (final l in course.lessons) ...[
                    if (l.index > 0) const Divider(height: 1, indent: 64),
                    ListTile(
                      leading: done.contains(l.key)
                          ? CircleAvatar(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              child: const Icon(Icons.check, size: 20),
                            )
                          : CircleAvatar(
                              backgroundColor: color.withValues(alpha: 0.14),
                              foregroundColor: color,
                              child: Text('${l.index + 1}'),
                            ),
                      title: Text(l.title),
                      subtitle: Text(
                        l.text.first,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: palette.muted),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => openLesson(context, course, l),
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

/// Lekce kurzu.
class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key, required this.course, required this.lesson});

  final StudyCourse course;
  final CourseLesson lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final color = courseColor(course);
    final progress = ref.watch(courseProgressProvider);
    final isDone = progress.contains(lesson.key);
    final all = course.lessons.length;
    final hasNext = lesson.index + 1 < all;
    final next = hasNext ? course.lessons[lesson.index + 1] : null;
    final prev = lesson.index > 0 ? course.lessons[lesson.index - 1] : null;

    void finish() {
      ref.read(courseProgressProvider.notifier).setDone(lesson, true);
      if (next != null) {
        openLesson(context, course, next, replace: true);
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text(S.courseFinished)));
      }
    }

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: Text(course.title)),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            4,
            16,
            MediaQuery.paddingOf(context).bottom + 32,
          ),
          children: [
            // Pokrok v kurzu: tečka za každou lekci.
            Row(
              children: [
                for (final l in course.lessons)
                  Expanded(
                    child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: l.index == lesson.index
                            ? color
                            : progress.contains(l.key)
                            ? color.withValues(alpha: 0.5)
                            : color.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              S.lessonOf(lesson.index + 1, all).toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(lesson.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 14),
            StudyParagraphs(lesson.text),
            StudyHeading(
              S.lessonRead,
              color: color,
              icon: Icons.menu_book_outlined,
            ),
            for (final (i, p) in lesson.passages.indexed)
              PassageCard(passage: p, accent: color, title: lesson.labels[i]),
            if (lesson.facts.isNotEmpty)
              FactsCard(facts: lesson.facts, color: color),
            if (lesson.questions.isNotEmpty) ...[
              StudyHeading(
                S.toReflect,
                color: color,
                icon: Icons.question_answer_outlined,
              ),
              QuestionsBlock(questions: lesson.questions, color: color),
            ],
            if (lesson.life.isNotEmpty)
              LifeCard(text: lesson.life, color: color),
            const SizedBox(height: 22),
            Row(
              children: [
                if (prev != null)
                  OutlinedButton.icon(
                    onPressed: () =>
                        openLesson(context, course, prev, replace: true),
                    icon: const Icon(Icons.chevron_left),
                    label: const Text(S.lessonPrev),
                  ),
                const Spacer(),
                if (isDone && next != null)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: color),
                    onPressed: () =>
                        openLesson(context, course, next, replace: true),
                    icon: const Icon(Icons.chevron_right),
                    label: const Text(S.lessonNext),
                  )
                else if (!isDone)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: color),
                    onPressed: finish,
                    icon: const Icon(Icons.check),
                    label: Text(hasNext ? S.lessonDone : S.lessonMarkDone),
                  )
                else
                  Row(
                    children: [
                      Icon(Icons.verified, color: color),
                      const SizedBox(width: 6),
                      Text(
                        progress.doneIn(course) == all
                            ? S.courseFinishedTitle
                            : S.lessonDone,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Karta ve Studiu: pokračování v rozečteném kurzu a nabídka kurzů.
class CoursesHeroCard extends ConsumerWidget {
  const CoursesHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final courses = ref.watch(coursesProvider).value ?? const <StudyCourse>[];
    final done = ref.watch(courseProgressProvider);
    if (courses.isEmpty) return const SizedBox(height: 120);
    // Rozečtený kurz (první započatý a nedokončený), jinak první kurz.
    final current = courses.firstWhere(
      (c) => done.started(c) && done.nextIn(c) != null,
      orElse: () => courses.firstWhere(
        (c) => done.nextIn(c) != null,
        orElse: () => courses.first,
      ),
    );
    final next = done.nextIn(current);
    final color = courseColor(current);
    final started = done.started(current);

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [palette.heroStart, palette.heroEnd],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.school_outlined, color: palette.onHero),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  S.courses,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: palette.onHero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            S.coursesHint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: palette.onHero.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 12),
          // Pokračovat / začít.
          Material(
            color: palette.onHero.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => next == null
                  ? openCourse(context, current)
                  : openLesson(context, current, next),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(courseIcon(current), color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: palette.onHero,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            next == null
                                ? S.courseFinished
                                : '${started ? S.courseContinue(next.index + 1) : S.courseStart}'
                                      ' · ${next.title}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: palette.onHero.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.play_circle_fill, color: palette.onHero),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in courses)
                if (c != current)
                  Material(
                    color: palette.onHero.withValues(alpha: 0.14),
                    shape: const StadiumBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => openCourse(context, c),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              done.nextIn(c) == null
                                  ? Icons.verified
                                  : courseIcon(c),
                              size: 18,
                              color: palette.onHero,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                c.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: palette.onHero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => openCourses(context),
              style: TextButton.styleFrom(foregroundColor: palette.onHero),
              icon: const Icon(Icons.arrow_forward),
              label: const Text(S.courses),
            ),
          ),
        ],
      ),
    );
  }
}

/// Zajímavost dne – střídá zajímavosti z témat a lekcí kurzů.
class FactOfDayCard extends ConsumerWidget {
  const FactOfDayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final topics = ref.watch(topicsProvider).value?.$2 ?? const <BibleTopic>[];
    final courses = ref.watch(coursesProvider).value ?? const <StudyCourse>[];
    final items = <(String, String, VoidCallback)>[
      for (final t in topics)
        for (final f in t.facts) (f, t.title, () => openTopic(context, t)),
      for (final c in courses)
        for (final l in c.lessons)
          for (final f in l.facts)
            (f, '${c.title} · ${l.title}', () => openLesson(context, c, l)),
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    final now = DateTime.now();
    final day = DateTime.utc(
      now.year,
      now.month,
      now.day,
    ).difference(DateTime.utc(2024)).inDays;
    // Krok nesoudělný s počtem položek – po sobě jdoucí dny skáčou
    // napříč tématy a kurzy.
    var step = 97;
    while (items.length % step == 0) {
      step++;
    }
    final (fact, source, onTap) = items[(day * step) % items.length];
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: palette.gold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    S.factOfDay,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: palette.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                fact,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      source,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: palette.muted,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: palette.muted, size: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
