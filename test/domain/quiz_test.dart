import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/today/presentation/for_today.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('otázka dne: každý den jiná, dokud se nevystřídají všechny', () {
    final json =
        jsonDecode(File('assets/content/quiz.json').readAsStringSync()) as Map;
    final all = [
      for (final x in json['questions'] as List)
        QuizQuestion.fromJson(x as Map<String, Object?>),
    ];
    final seen = <String>{};
    for (var d = 0; d < all.length; d++) {
      final (q, answers) = quizOfDay(
        all,
        DateTime(2026, 1, 1).add(Duration(days: d)),
      );
      expect(answers.toSet(), q.answers.toSet());
      seen.add(q.question);
    }
    expect(seen.length, all.length);
    // Každá otázka má čtyři různé odpovědi.
    for (final q in all) {
      expect(q.answers.toSet().length, 4, reason: q.question);
    }
  });
}
