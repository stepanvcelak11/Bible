import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'study_database.dart';

/// Kde je publikovaný balíček (GitHub Pages); na webu se použije relativní
/// cesta ke stejnému webu.
const studyBaseUrl = 'https://stepanvcelak11.github.io/Bible/data/';

Future<File> _file(String version) async {
  final dir = Directory(
    p.join((await getApplicationSupportDirectory()).path, 'study'),
  );
  await dir.create(recursive: true);
  return File(p.join(dir.path, 'study-$version.db'));
}

/// Uloží rozbalený balíček (a smaže starší verze).
Future<void> storeStudyPack(String version, Uint8List bytes) async {
  final file = await _file(version);
  final tmp = File('${file.path}.tmp');
  await tmp.writeAsBytes(bytes, flush: true);
  await tmp.rename(file.path);
  for (final old in file.parent.listSync()) {
    if (old is File && old.path != file.path) old.deleteSync();
  }
}

/// Otevře nainstalovaný balíček, nebo vrátí `null`, pokud chybí.
Future<StudyDatabase?> openStudyPack(
  String version, {
  bool create = false,
}) async {
  final file = await _file(version);
  if (!file.existsSync()) return null;
  // Bez query_only: Drift si při prvním otevření zapíše user_version.
  return StudyDatabase(NativeDatabase.createInBackground(file));
}

/// Odstraní balíček ze zařízení.
Future<void> deleteStudyPack(String version) async {
  final file = await _file(version);
  for (final f in file.parent.listSync()) {
    if (f is File) f.deleteSync();
  }
}
