import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/features/content/presentation/family_tree_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('postavy v rodokmenu odkazují na existující medailony', () {
    final ids = {
      for (final p
          in (jsonDecode(File('assets/content/people.json').readAsStringSync())
                  as Map<String, dynamic>)['people']
              as List)
        p['id'] as String,
    };
    final used = [
      for (final n in familyLine) ...[
        ?n.person,
        for (final l in [...n.spouses, ...n.children]) ?l.person,
      ],
    ];
    expect(used.where((id) => !ids.contains(id)), isEmpty);
    expect(familyLine.first.name, 'Adam');
    expect(familyLine.last.person, 'jezis');
  });
}
