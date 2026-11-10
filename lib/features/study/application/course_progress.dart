import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/content_entities.dart';

/// Dokončené lekce studijních kurzů (klíče `kurz:index`).
class CourseProgressController extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.read(appPreferencesProvider).coursesDone.toSet();

  void _save(Set<String> s) {
    state = s;
    ref.read(appPreferencesProvider).setCoursesDone(s.toList()..sort());
  }

  void setDone(CourseLesson lesson, bool done) =>
      _save(done ? {...state, lesson.key} : ({...state}..remove(lesson.key)));

  void resetCourse(StudyCourse course) =>
      _save({...state}..removeWhere((k) => k.startsWith('${course.id}:')));
}

final courseProgressProvider =
    NotifierProvider<CourseProgressController, Set<String>>(
      CourseProgressController.new,
    );

extension CourseProgressX on Set<String> {
  int doneIn(StudyCourse c) => c.lessons.where((l) => contains(l.key)).length;

  /// První nedokončená lekce, nebo `null`, když je kurz hotový.
  CourseLesson? nextIn(StudyCourse c) {
    for (final l in c.lessons) {
      if (!contains(l.key)) return l;
    }
    return null;
  }

  bool started(StudyCourse c) => doneIn(c) > 0;
}
