import 'dart:convert';
import 'dart:io';

import 'package:bible_reader/data/bible/bible_db_installer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Falešný AssetBundle s počítadlem načtení databáze.
class _FakeBundle extends CachingAssetBundle {
  _FakeBundle({required this.version, this.hasDb = true});

  String version;
  bool hasDb;
  int dbLoads = 0;

  @override
  Future<ByteData> load(String key) async {
    switch (key) {
      case BibleDbInstaller.manifestAsset:
        return ByteData.sublistView(
          utf8.encode(jsonEncode({'content_version': version})),
        );
      case BibleDbInstaller.dbAsset when hasDb:
        dbLoads++;
        return ByteData.sublistView(
          Uint8List.fromList(utf8.encode('db-$version')),
        );
      default:
        throw FlutterError('Asset $key nenalezen');
    }
  }
}

void main() {
  late Directory tmp;
  setUp(() => tmp = Directory.systemTemp.createTempSync('bible_test'));
  tearDown(() => tmp.deleteSync(recursive: true));

  BibleDbInstaller installer(_FakeBundle bundle) =>
      BibleDbInstaller(bundle: bundle, baseDirectory: () async => tmp);

  test('první start nainstaluje, další start nic nekopíruje', () async {
    final bundle = _FakeBundle(version: 'v1');
    final file = await installer(bundle).ensureInstalled();
    expect(file.readAsStringSync(), 'db-v1');
    expect(bundle.dbLoads, 1);

    await installer(bundle).ensureInstalled();
    expect(bundle.dbLoads, 1);
  });

  test('nová verze obsahu databázi nahradí', () async {
    final bundle = _FakeBundle(version: 'v1');
    await installer(bundle).ensureInstalled();
    bundle.version = 'v2';
    final file = await installer(bundle).ensureInstalled();
    expect(file.readAsStringSync(), 'db-v2');
    expect(bundle.dbLoads, 2);
  });

  test('chybějící databáze → BibleDataMissingException', () async {
    final bundle = _FakeBundle(version: 'v1', hasDb: false);
    expect(
      installer(bundle).ensureInstalled(),
      throwsA(isA<BibleDataMissingException>()),
    );
  });
}
