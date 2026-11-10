import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/content/presentation/situations_screen.dart';
import 'package:bible_reader/features/study/application/course_progress.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _load(String name) =>
    jsonDecode(File('assets/content/$name').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('každé téma má studijní část a známou ikonu i kategorii', () {
    final j = _load('topics.json');
    final cats = {for (final c in j['categories'] as List) c['id']};
    final topics = [
      for (final t in j['topics'] as List)
        BibleTopic.fromJson(t as Map<String, Object?>),
    ];
    expect(topics.length, greaterThanOrEqualTo(80));
    for (final t in topics) {
      expect(cats, contains(t.category), reason: t.id);
      expect(situationIcons, contains(t.icon), reason: t.id);
      expect(t.deeper, isNotEmpty, reason: t.id);
      expect(t.facts, isNotEmpty, reason: t.id);
      expect(t.questions, isNotEmpty, reason: t.id);
      expect(t.labels.length, t.passages.length, reason: t.id);
    }
    expect(topics.map((t) => t.id).toSet().length, topics.length);
  });

  test('kurzy se načtou a pokrok se počítá po lekcích', () {
    final courses = [
      for (final c in _load('courses.json')['courses'] as List)
        StudyCourse.fromJson(c as Map<String, Object?>),
    ];
    expect(courses.length, greaterThanOrEqualTo(7));
    for (final c in courses) {
      expect(situationIcons, contains(c.icon), reason: c.id);
      expect(c.lessons, isNotEmpty);
      for (final l in c.lessons) {
        expect(l.text, isNotEmpty, reason: l.title);
        expect(l.passages, isNotEmpty, reason: l.title);
        expect(l.labels.length, l.passages.length, reason: l.title);
        expect(l.questions, isNotEmpty, reason: l.title);
      }
    }
    final c = courses.first;
    final done = {c.lessons[0].key, c.lessons[1].key};
    expect(done.doneIn(c), 2);
    expect(done.nextIn(c), same(c.lessons[2]));
    expect(<String>{}.nextIn(c), same(c.lessons[0]));
    expect({for (final l in c.lessons) l.key}.nextIn(c), isNull);
  });
}
