import 'dart:convert';

import 'package:bible_reader/data/preferences/app_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<AppPreferences> prefs(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return AppPreferences(await SharedPreferences.getInstance());
  }

  test('nastavení a pokrok projdou zálohou na nové zařízení', () async {
    final old = await prefs({});
    await old.setPlan('nt90', start: DateTime(2026, 9, 1));
    await old.setPlanDone({0, 1, 2});
    await old.setCoursesDone(['jak-cist:0', 'jak-cist:1']);
    await old.setQuizBest({'all': 8});
    await old.setPrepLayout('versesLeft');
    // Přes JSON jako skutečný soubor zálohy.
    final file = jsonDecode(jsonEncode(old.exportSettings()));

    final fresh = await prefs({});
    expect(await fresh.importSettings(file), greaterThan(0));
    expect(fresh.planId, 'nt90');
    expect(fresh.planStart, DateTime(2026, 9, 1));
    expect(fresh.planDone, {0, 1, 2});
    expect(fresh.coursesDone, ['jak-cist:0', 'jak-cist:1']);
    expect(fresh.quizBest, {'all': 8});
    expect(fresh.prepLayout, 'versesLeft');
  });

  test('obnova nic nepřepíše, jen sloučí', () async {
    final backup = {
      'plan.id': 'nt90',
      'plan.done': ['0', '5'],
      'courses.done': ['a:0'],
      'quiz.best': ['all:5', 'ot:9'],
      'prep.layout': 'versesLeft',
    };
    final p = await prefs({});
    await p.setPlan('nt90', start: DateTime(2026, 9, 1));
    await p.setPlanDone({0, 1});
    await p.setCoursesDone(['b:0']);
    await p.setQuizBest({'all': 7});
    await p.setPrepLayout('stacked');
    await p.importSettings(backup);
    expect(p.planDone, {0, 1, 5});
    expect(p.coursesDone, ['a:0', 'b:0']);
    expect(p.quizBest, {'all': 7, 'ot': 9});
    expect(p.prepLayout, 'stacked');

    // Jiný rozběhnutý plán zůstane.
    final q = await prefs({});
    await q.setPlan('gospels');
    await q.importSettings(backup);
    expect(q.planId, 'gospels');
    expect(q.planDone, isEmpty);
  });

  test('neplatná data zálohy se ignorují', () async {
    final p = await prefs({});
    expect(await p.importSettings(null), 0);
    expect(await p.importSettings({'plan.done': 'x', 'quiz.best': 3}), 0);
  });
}
