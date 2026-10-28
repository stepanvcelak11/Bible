import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/features/memory/application/memory_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_databases.dart';

void main() {
  test('verše nazpaměť: kódování, pokrok a záloha', () async {
    final container = await createTestContainer();
    addTearDown(container.dispose);
    final ctl = container.read(memoryProvider.notifier);

    expect(ctl.add(const MemoryVerse(VerseRef(43, 3, 16), 17)), isTrue);
    expect(ctl.add(const MemoryVerse(VerseRef(43, 3, 16), 17)), isFalse);
    ctl.setLevel(container.read(memoryProvider).single, 3);
    final backup = ctl.exportList();
    expect(backup, ['43:3:16-17|3']);

    // Obnova do prázdného seznamu zachová i pokrok; duplicity přeskočí.
    ctl.remove(container.read(memoryProvider).single);
    expect(ctl.importList([...backup, 'nesmysl', 42]), 1);
    expect(ctl.importList(backup), 0);
    final m = container.read(memoryProvider).single;
    expect((m.start, m.end, m.level), (const VerseRef(43, 3, 16), 17, 3));
  });
}
