import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'JSON s obsahem odpovídá zdrojům v tool/content',
    () {
      final r = Process.runSync('python3', [
        'tool/build_content.py',
        '--verify',
      ]);
      expect(r.exitCode, 0, reason: '${r.stdout}${r.stderr}');
    },
    skip: Process.runSync('which', ['python3']).exitCode != 0
        ? 'python3 není k dispozici'
        : false,
  );
}
