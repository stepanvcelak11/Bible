part of 'prep_screen.dart';

// --- Přenos mezi zařízeními a export ------------------------------------------

/// Název souboru z názvu přípravy (bez diakritiky a mezer).
String prepFileName(Prep prep, String ext, {String suffix = ''}) {
  final slug = foldCzech(prep.title.isEmpty ? S.prepUntitled : prep.title)
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return '${slug.isEmpty ? 'priprava' : slug}$suffix.$ext';
}

/// Pošle soubor přes nabídku sdílení (e-mail, cloud, Bluetooth…);
/// na webu bez sdílení souborů se soubor stáhne.
Future<void> _shareFile(
  BuildContext context,
  String content,
  String name,
  String mime,
) async {
  final box = context.findRenderObject() as RenderBox?;
  await SharePlus.instance.share(
    ShareParams(
      files: [
        XFile.fromData(
          Uint8List.fromList(utf8.encode(content)),
          name: name,
          mimeType: mime,
        ),
      ],
      fileNameOverrides: [name],
      sharePositionOrigin: box == null || !box.hasSize
          ? null
          : box.localToGlobal(Offset.zero) & box.size,
    ),
  );
}

/// Soubor přípravy pro jiné zařízení (načte se v Přípravách).
Future<void> sendPrepToDevice(BuildContext context, Prep prep) => _shareFile(
  context,
  const JsonEncoder.withIndent(' ').convert(prepFileJson(prep)),
  prepFileName(prep, 'json'),
  'application/json',
);

/// Texty veršů bloku ve vybraných překladech: (zkratka překladu, text).
Future<List<(String, String)>> _verseTexts(WidgetRef ref, PrepBlock b) async {
  final all = ref.read(translationsProvider);
  final picked = [
    for (final id in b.translations) ?all.where((t) => t.id == id).firstOrNull,
  ];
  return [
    for (final t
        in picked.isEmpty ? [ref.read(primaryTranslationProvider)] : picked)
      (
        t.abbreviation,
        (await ref.read(passageTextProvider((t.id, b.passage!)).future))
            .map((v) => v.text.replaceAll('\n', ' '))
            .join(' '),
      ),
  ];
}

Future<String> _exportText(WidgetRef ref, Prep prep) async {
  final out = StringBuffer()
    ..writeln(prep.title.isEmpty ? S.prepUntitled : prep.title)
    ..writeln(
      [
        prep.kind.label,
        for (final p in prep.passages) passageLabel(ref, p),
        if (prep.date case final d?) _date(d),
      ].join(' · '),
    )
    ..writeln();
  for (final b in prep.blocks) {
    switch (b.kind) {
      case PrepBlockKind.heading:
        out
          ..writeln()
          ..writeln(b.text.toUpperCase());
        if (b.body.isNotEmpty) out.writeln(b.body);
      case PrepBlockKind.verse:
        for (final (abbr, text) in await _verseTexts(ref, b)) {
          out.writeln('${passageLabel(ref, b.passage!)} ($abbr): „$text“');
        }
        if (b.text.isNotEmpty) out.writeln('  ${b.text}');
      case PrepBlockKind.question:
        out.writeln('? ${b.text}');
      case PrepBlockKind.illustration:
        out.writeln('${S.prepIllustrationLabel}: ${b.text}');
      case PrepBlockKind.idea || PrepBlockKind.note:
        out.writeln(b.text);
    }
  }
  return out.toString().trim();
}

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll('\n', '<br>');

/// Přehledný dokument (HTML) – otevře se v každém prohlížeči a jde
/// vytisknout nebo uložit jako PDF.
Future<String> exportPrepHtml(WidgetRef ref, Prep prep) async {
  final title = prep.title.isEmpty ? S.prepUntitled : prep.title;
  final meta = [
    prep.kind.label,
    for (final p in prep.passages) passageLabel(ref, p),
    if (prep.date case final d?) _date(d),
  ].join(' · ');
  final body = StringBuffer();
  var open = false;
  for (final b in prep.blocks) {
    if (b.text.trim().isEmpty && b.passage == null && b.body.isEmpty) {
      continue;
    }
    switch (b.kind) {
      case PrepBlockKind.heading:
        if (open) body.writeln('</section>');
        open = true;
        body.writeln('<section><h2>${_esc(b.text)}</h2>');
        if (b.body.isNotEmpty) body.writeln('<p>${_esc(b.body)}</p>');
      case PrepBlockKind.verse:
        body.writeln('<div class="verse">');
        body.writeln(
          '<div class="ref">${_esc(passageLabel(ref, b.passage!))}</div>',
        );
        for (final (abbr, text) in await _verseTexts(ref, b)) {
          body.writeln(
            '<blockquote>${_esc(text)} <span class="tr">$abbr</span></blockquote>',
          );
        }
        if (b.text.isNotEmpty) {
          body.writeln('<p class="comment">${_esc(b.text)}</p>');
        }
        body.writeln('</div>');
      case PrepBlockKind.question:
        body.writeln(
          '<p class="tag q"><b>${S.prepQuestionLabel}</b> ${_esc(b.text)}</p>',
        );
      case PrepBlockKind.illustration:
        body.writeln(
          '<p class="tag i"><b>${S.prepIllustrationLabel}</b> ${_esc(b.text)}</p>',
        );
      case PrepBlockKind.idea:
        body.writeln(
          '<p class="tag n"><b>${S.prepIdeaLabel}</b> ${_esc(b.text)}</p>',
        );
      case PrepBlockKind.note:
        body.writeln('<p>${_esc(b.text)}</p>');
    }
  }
  if (open) body.writeln('</section>');
  return '''<!doctype html>
<html lang="cs"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${_esc(title)}</title>
<style>
body{font-family:Georgia,'Times New Roman',serif;max-width:720px;margin:40px auto;padding:0 20px;color:#2b241c;line-height:1.55;background:#fffdf8}
h1{font-size:30px;margin:0 0 4px}
.meta{color:#8a7a62;font-family:system-ui,sans-serif;font-size:14px;margin-bottom:28px}
h2{font-size:21px;margin:30px 0 8px;padding-bottom:4px;border-bottom:2px solid #c9a35b}
.verse{margin:14px 0}
.ref{font-family:system-ui,sans-serif;font-weight:700;color:#9a7232;font-size:14px}
blockquote{margin:6px 0;padding:8px 14px;background:#f5ecda;border-left:4px solid #c9a35b;border-radius:4px}
.tr{font-family:system-ui,sans-serif;font-size:11px;color:#9a7232}
.comment{font-style:italic;color:#5b4f40;margin:4px 0}
.tag b{font-family:system-ui,sans-serif;font-size:12px;text-transform:uppercase;letter-spacing:.06em;margin-right:6px}
.q b{color:#3f7cac}.i b{color:#b0603a}.n b{color:#6b7a3a}
footer{margin-top:40px;color:#a99a80;font-family:system-ui,sans-serif;font-size:12px}
@media print{body{margin:0;background:#fff}blockquote{background:#f7f2e8}}
</style></head><body>
<h1>${_esc(title)}</h1>
<div class="meta">${_esc(meta)}</div>
$body
<footer>${S.prepExportFooter}</footer>
</body></html>
''';
}

/// List otázek pro skupinku: hlavní texty v plném znění a otázky
/// (seskupené podle bodů) s místem na odpovědi. Null = žádné otázky.
Future<String?> exportQuestionsHtml(WidgetRef ref, Prep prep) async {
  if (!prep.blocks.any(
    (b) => b.kind == PrepBlockKind.question && b.text.trim().isNotEmpty,
  )) {
    return null;
  }
  final title = prep.title.isEmpty ? S.prepUntitled : prep.title;
  final tr = ref.read(primaryTranslationProvider);
  final texts = StringBuffer();
  for (final p in prep.passages) {
    final vs = await ref.read(passageTextProvider((tr.id, p)).future);
    texts.writeln(
      '<div class="ref">${_esc(passageLabel(ref, p))}</div>'
      '<blockquote>${_esc(vs.map((v) => v.text.replaceAll('\n', ' ')).join(' '))}'
      ' <span class="tr">${tr.abbreviation}</span></blockquote>',
    );
  }
  final body = StringBuffer();
  String? section;
  var n = 0;
  for (final b in prep.blocks) {
    if (b.kind == PrepBlockKind.heading) section = b.text.trim();
    if (b.kind != PrepBlockKind.question || b.text.trim().isEmpty) continue;
    if (section != null) {
      if (section.isNotEmpty) body.writeln('<h2>${_esc(section)}</h2>');
      section = null;
    }
    n++;
    body.writeln(
      '<div class="q"><span class="n">$n</span>${_esc(b.text.trim())}'
      '<div class="lines"></div></div>',
    );
  }
  return '''<!doctype html>
<html lang="cs"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${_esc(title)} – ${S.prepQuestionsTitle}</title>
<style>
body{font-family:Georgia,'Times New Roman',serif;max-width:720px;margin:40px auto;padding:0 20px;color:#2b241c;line-height:1.55;background:#fffdf8}
h1{font-size:28px;margin:0 0 2px}
.meta{color:#8a7a62;font-family:system-ui,sans-serif;font-size:14px;margin-bottom:22px}
h2{font-size:19px;margin:26px 0 6px;padding-bottom:3px;border-bottom:2px solid #c9a35b}
.ref{font-family:system-ui,sans-serif;font-weight:700;color:#9a7232;font-size:14px;margin-top:10px}
blockquote{margin:6px 0 14px;padding:8px 14px;background:#f5ecda;border-left:4px solid #c9a35b;border-radius:4px}
.tr{font-family:system-ui,sans-serif;font-size:11px;color:#9a7232}
.q{margin:18px 0;font-size:18px;break-inside:avoid}
.n{display:inline-block;width:28px;height:28px;line-height:28px;text-align:center;border-radius:50%;background:#3f7cac;color:#fff;font-family:system-ui,sans-serif;font-size:14px;font-weight:700;margin-right:10px}
.lines{height:84px;margin:6px 0 0 38px;background:repeating-linear-gradient(transparent 0 27px,#d8cbb2 27px 28px)}
footer{margin-top:40px;color:#a99a80;font-family:system-ui,sans-serif;font-size:12px}
@media print{body{margin:0;background:#fff}blockquote{background:#f7f2e8}}
</style></head><body>
<h1>${_esc(title)}</h1>
<div class="meta">${_esc(S.prepQuestionsTitle)}</div>
$texts
$body
<footer>${S.prepExportFooter}</footer>
</body></html>
''';
}

/// Nabídka exportu kázání: dokument, text, soubor pro aplikaci.
Future<void> showPrepExport(
  BuildContext context,
  WidgetRef ref,
  Prep prep,
) => showAppSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (sheet) {
    final theme = Theme.of(sheet);
    final palette = AppPalette.of(sheet);
    Future<void> run(Future<void> Function() f) async {
      Navigator.of(sheet).pop();
      await f();
    }

    Widget option(
      IconData icon,
      Color color,
      String title,
      String subtitle,
      Future<void> Function() onTap,
    ) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.13),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () => run(onTap),
    );

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(S.prepExportTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            S.prepExportIntro,
            style: theme.textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 10),
          option(
            Icons.description_outlined,
            const Color(0xFFB0603A),
            S.prepExportDoc,
            S.prepExportDocHint,
            () async {
              final content = await exportPrepHtml(ref, prep);
              if (context.mounted) {
                await _shareFile(
                  context,
                  content,
                  prepFileName(prep, 'html'),
                  'text/html',
                );
              }
            },
          ),
          option(
            Icons.groups_outlined,
            const Color(0xFF3F7CAC),
            S.prepExportQuestions,
            S.prepExportQuestionsHint,
            () async {
              final content = await exportQuestionsHtml(ref, prep);
              if (!context.mounted) return;
              if (content == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(S.prepNoQuestions)),
                );
                return;
              }
              await _shareFile(
                context,
                content,
                prepFileName(prep, 'html', suffix: '-otazky'),
                'text/html',
              );
            },
          ),
          option(
            Icons.notes,
            const Color(0xFF5B6F8A),
            S.prepExportTxt,
            S.prepExportTxtHint,
            () async {
              final content = await _exportText(ref, prep);
              if (context.mounted) {
                await _shareFile(
                  context,
                  content,
                  prepFileName(prep, 'txt'),
                  'text/plain',
                );
              }
            },
          ),
          option(
            Icons.ios_share,
            const Color(0xFF6B7A3A),
            S.prepExportShare,
            S.prepExportShareHint,
            () async => SharePlus.instance.share(
              ShareParams(text: await _exportText(ref, prep)),
            ),
          ),
          option(
            Icons.copy_rounded,
            const Color(0xFF8C6BA8),
            S.prepCopyText,
            S.prepExportCopyHint,
            () async {
              final messenger = ScaffoldMessenger.of(context);
              await Clipboard.setData(
                ClipboardData(text: await _exportText(ref, prep)),
              );
              messenger.showSnackBar(const SnackBar(content: Text(S.copied)));
            },
          ),
          option(
            Icons.devices_outlined,
            const Color(0xFFB0813B),
            S.prepSendDevice,
            S.prepSendDeviceHint,
            () => sendPrepToDevice(context, prep),
          ),
        ],
      ),
    );
  },
);

/// Načte přípravu (nebo přípravy ze zálohy) ze souboru. Když už stejná
/// příprava v zařízení je, zeptá se, zda ji nahradit, nebo uložit kopii.
Future<void> importPrepFile(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  void say(String text) => messenger.showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: const ['json'],
  );
  if (file == null) return;
  List<Prep> preps;
  try {
    preps = parsePrepFile(jsonDecode(utf8.decode(await file.readAsBytes())));
  } on FormatException {
    preps = const [];
  }
  if (preps.isEmpty) {
    say(S.prepImportInvalid);
    return;
  }
  final controller = ref.read(prepProvider.notifier);
  var count = 0;
  Prep? last;
  for (final p in preps) {
    final existing = controller.byId(p.id);
    var replace = true;
    if (existing != null) {
      if (!context.mounted) return;
      final choice = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(p.title.isEmpty ? S.prepUntitled : p.title),
          content: Text(
            S.prepImportExists(
              _dateTime(p.updated),
              _dateTime(existing.updated),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(c).pop(),
              child: const Text(S.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(c).pop(false),
              child: const Text(S.prepImportCopy),
            ),
            FilledButton(
              onPressed: () => Navigator.of(c).pop(true),
              child: const Text(S.prepImportReplace),
            ),
          ],
        ),
      );
      if (choice == null) continue;
      replace = choice;
    }
    last = controller.importPrep(p, replace: replace);
    count++;
  }
  if (count == 0) return;
  say(S.prepImported(count));
  if (count == 1 && last != null && context.mounted) {
    openPrep(context, last.id);
  }
}

String _dateTime(DateTime d) =>
    '${_date(d)} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
