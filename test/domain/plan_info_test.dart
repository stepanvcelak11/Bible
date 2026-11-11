import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/services/bible_content.dart';
import 'package:bible_reader/domain/services/plan_info.dart';
import 'package:bible_reader/features/today/presentation/plan_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('každý vestavěný plán má vlastní popis', () {
    for (final p in readingPlans) {
      final info = planInfo[p.id];
      expect(info, isNotNull, reason: p.id);
      expect(info!.about, isNotEmpty);
      expect(info.tips, isNotEmpty);
    }
    expect(planInfoFor('custom:10:40'), same(customPlanInfo));
  });

  test('úseky plánu po knihách', () {
    final schedule = [
      [const VerseRef(40, 1), const VerseRef(40, 2)],
      [const VerseRef(40, 3), const VerseRef(41, 1)],
      [const VerseRef(41, 2)],
    ];
    final books = [
      for (var i = 1; i <= 66; i++)
        Book(
          id: i,
          name: i == 40
              ? 'Matouš'
              : i == 41
              ? 'Marek'
              : 'K$i',
          osis: 'K$i',
          abbreviation: 'K$i',
          testament: i < 40 ? Testament.oldTestament : Testament.newTestament,
        ),
    ];
    expect(planStages(schedule, books), [(0, 1, 'Matouš'), (1, 2, 'Marek')]);
    expect(planDayLabel(schedule[1], books), 'Matouš 3 · Marek 1');
    expect(planDayLabel(schedule[0], books), 'Matouš 1–2');
  });
}
