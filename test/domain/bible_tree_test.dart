import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/bible_entities.dart';
import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/connections/presentation/bible_tree_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, Object?> load(String name) =>
      jsonDecode(File('assets/content/$name').readAsStringSync())
          as Map<String, Object?>;

  test('strom: všechny postavy, období a knihy mají své místo', () {
    final eras = [
      for (final e in load('story.json')['eras']! as List)
        StoryEra.fromJson(e as Map<String, Object?>),
    ];
    final people = [
      for (final p in load('people.json')['people']! as List)
        BiblePerson.fromJson(p as Map<String, Object?>),
    ];
    final books = [
      for (var i = 1; i <= 66; i++)
        Book(
          id: i,
          osis: 'B$i',
          name: 'Kniha $i',
          abbreviation: 'K$i',
          testament: i < 40 ? Testament.oldTestament : Testament.newTestament,
        ),
    ];
    final root = buildBibleTree(eras: eras, people: people, books: books);
    final all = <TreeNode>[];
    void walk(TreeNode n) {
      all.add(n);
      n.children.forEach(walk);
    }

    walk(root);
    expect(root.children.map((c) => c.title), hasLength(2));
    expect(all.where((n) => n.level == TreeLevel.era), hasLength(eras.length));
    expect(all.where((n) => n.person != null), hasLength(people.length));
    // Každá kniha Bible je ve stromu aspoň jednou.
    expect({for (final n in all) ?n.book}, hasLength(66));
    // Abraham patří k praotcům, Adam ke stvoření.
    TreeNode person(String id) => all.firstWhere((n) => n.id == 'person:$id');
    expect(person('adam').parent!.parent!.era!.id, 'creation');
    expect(person('abraham').parent!.parent!.era!.id, 'patriarchs');
    // Uzly leží uvnitř plátna.
    for (final n in all) {
      expect(n.pos.dx, inInclusiveRange(0, treeCanvas));
      expect(n.pos.dy, inInclusiveRange(0, treeCanvas));
    }
  });
}
