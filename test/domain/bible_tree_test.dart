import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/domain/entities/content_entities.dart';
import 'package:bible_reader/features/connections/presentation/bible_tree_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, Object?> load(String name) =>
      jsonDecode(File('assets/content/$name').readAsStringSync())
          as Map<String, Object?>;

  test('strom: období → příběhy → postavy a souvislosti', () {
    final eras = [
      for (final e in load('story.json')['eras']! as List)
        StoryEra.fromJson(e as Map<String, Object?>),
    ];
    final stories = [
      for (final s in load('stories.json')['stories']! as List)
        BibleStory.fromJson(s as Map<String, Object?>),
    ];
    final people = [
      for (final p in load('people.json')['people']! as List)
        BiblePerson.fromJson(p as Map<String, Object?>),
    ];
    final root = buildBibleTree(eras: eras, stories: stories, people: people);
    final all = <TreeNode>[];
    void walk(TreeNode n) {
      all.add(n);
      n.children.forEach(walk);
    }

    walk(root);
    expect(root.children.map((c) => c.title), hasLength(2));
    expect(all.where((n) => n.level == TreeLevel.era), hasLength(eras.length));
    expect(
      all.where((n) => n.level == TreeLevel.story),
      hasLength(stories.length),
    );
    // Každá postava vystupuje aspoň v jednom příběhu.
    expect({for (final n in all) ?n.person?.id}, hasLength(people.length));
    TreeNode story(String id) => all.firstWhere((n) => n.id == 'story:$id');
    expect(story('stvoreni').parent!.era!.id, 'creation');
    expect(story('kriz').parent!.era!.id, 'jesus');
    // Souvislosti vedou oběma směry.
    expect(story('kriz').links.map((l) => l.$1), contains(story('izak')));
    expect(story('izak').links.map((l) => l.$1), contains(story('kriz')));
    // Místo Bible najde svůj příběh, jinak období.
    expect(anchorFor(const Passage(1, 22, 7, 8), all), story('izak'));
    expect(anchorFor(const Passage(20, 3, 5, 6), all)!.era!.id, 'kingdom');
    // Uzly leží uvnitř plátna.
    for (final n in all) {
      expect(n.pos.dx, inInclusiveRange(0, treeCanvas));
      expect(n.pos.dy, inInclusiveRange(0, treeCanvas));
    }
  });
}
