import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../translations/translation_installer.dart'
    show DownloadException, Downloading, InstallProgress, Processing, Saving;
import 'study_connection.dart';
import 'study_database.dart';

/// Popis publikovaného studijního balíčku (assets/db/study_manifest.json).
@immutable
class StudyManifest {
  const StudyManifest({
    required this.file,
    required this.version,
    required this.size,
    required this.downloadSize,
    required this.credits,
  });

  factory StudyManifest.fromJson(Map<String, Object?> j) => StudyManifest(
    file: j['file']! as String,
    version: j['version']! as String,
    size: (j['size']! as num).toInt(),
    downloadSize: (j['download_size'] as num?)?.toInt() ?? 0,
    credits: j['credits'] as String? ?? '',
  );

  final String file;
  final String version;
  final int size;
  final int downloadSize;
  final String credits;
}

/// Stažení, uložení a otevření studijního balíčku (původní text, slovník,
/// souvislosti, místa). Balíček je volitelný – aplikace funguje i bez něj.
class StudyPackManager {
  StudyPackManager({http.Client? client, AssetBundle? bundle})
    : _client = client ?? http.Client(),
      _bundle = bundle ?? rootBundle;

  final http.Client _client;
  final AssetBundle _bundle;

  static const manifestAsset = 'assets/db/study_manifest.json';

  Future<StudyManifest?> loadManifest() async {
    try {
      return StudyManifest.fromJson(
        jsonDecode(await _bundle.loadString(manifestAsset))
            as Map<String, Object?>,
      );
    } on FlutterError {
      return null;
    }
  }

  /// Otevře nainstalovanou verzi (`null` = není nainstalováno).
  Future<StudyDatabase?> open(String version) => openStudyPack(version);

  /// Stáhne, rozbalí a uloží balíček.
  Future<void> install(
    StudyManifest manifest, {
    void Function(InstallProgress)? onProgress,
  }) async {
    final uri = Uri.parse('$studyBaseUrl${manifest.file}');
    final http.StreamedResponse response;
    try {
      response = await _client.send(http.Request('GET', uri));
    } catch (e) {
      throw DownloadException('Nelze se připojit ($e).');
    }
    if (response.statusCode != 200) {
      throw DownloadException(
        'Server odpověděl chybou ${response.statusCode}.',
      );
    }
    final total = response.contentLength ?? manifest.downloadSize;
    final builder = BytesBuilder(copy: false);
    var last = 0;
    await for (final chunk in response.stream) {
      builder.add(chunk);
      if (builder.length - last > 200000) {
        last = builder.length;
        onProgress?.call(Downloading(builder.length, total));
      }
    }
    onProgress?.call(const Processing());
    // Na webu nemá rozbalení vlastní vlákno – dát UI chvíli překreslit.
    await Future<void>.delayed(const Duration(milliseconds: 50));
    final bytes = Uint8List.fromList(
      const GZipDecoder().decodeBytes(builder.takeBytes()),
    );
    onProgress?.call(const Saving());
    await storeStudyPack(manifest.version, bytes);
  }

  Future<void> remove(String version) => deleteStudyPack(version);
}
