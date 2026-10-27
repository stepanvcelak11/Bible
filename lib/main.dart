import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'bootstrap.dart';
import 'data/bible/bible_db_installer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final overrides = await bootstrap();
    runApp(ProviderScope(overrides: overrides, child: const BibleApp()));
  } on BibleDataMissingException catch (e) {
    debugPrint('$e');
    runApp(const StartupErrorApp(dataMissing: true));
  } catch (e, st) {
    debugPrint('Start aplikace selhal: $e\n$st');
    runApp(StartupErrorApp(dataMissing: false, error: e));
  }
}
