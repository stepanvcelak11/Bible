import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/widgets/readable_width.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/translations/translation_installer.dart';
import '../../../data/translations/translation_parsers.dart';
import '../../../domain/entities/bible_entities.dart';

final _catalogProvider = FutureProvider<List<CatalogTranslation>>(
  (ref) => ref.watch(translationInstallerProvider).loadCatalog(),
);

/// Probíhající instalace (id překladu → průběh).
class _InstallsController extends Notifier<Map<String, InstallProgress?>> {
  @override
  Map<String, InstallProgress?> build() => const {};

  void set(String id, InstallProgress? p) => state = {...state, id: p};
  void done(String id) => state = {...state}..remove(id);
}

final _installsProvider =
    NotifierProvider<_InstallsController, Map<String, InstallProgress?>>(
      _InstallsController.new,
    );

/// Správa překladů: nainstalované, ke stažení, nedostupné, import souboru.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  Future<void> _install(
    BuildContext context,
    WidgetRef ref,
    CatalogTranslation entry,
    int order,
  ) async {
    final installs = ref.read(_installsProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    installs.set(entry.id, null);
    try {
      await ref
          .read(translationInstallerProvider)
          .install(
            entry,
            sortOrder: 100 + order,
            onProgress: (p) => installs.set(entry.id, p),
          );
      await ref.read(translationsProvider.notifier).refresh();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('${S.downloadFailed}: $e')),
      );
    } finally {
      installs.done(entry.id);
    }
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    Translation t,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.removeTranslationQuestion(t.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(S.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(S.remove),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(translationInstallerProvider).remove(t.id);
    await ref.read(translationsProvider.notifier).refresh();
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final file = await FilePicker.pickFile();
    if (file == null || !context.mounted) return;
    final names = await showDialog<(String, String)>(
      context: context,
      builder: (_) => const _ImportDialog(),
    );
    if (names == null) return;
    final installs = ref.read(_installsProvider.notifier);
    final id =
        'U_${names.$2.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '')}';
    installs.set(id, const Processing());
    try {
      final count = await ref
          .read(translationInstallerProvider)
          .importFile(
            await file.readAsBytes(),
            id: id,
            name: names.$1,
            abbreviation: names.$2,
            sortOrder: 200,
          );
      await ref.read(translationsProvider.notifier).refresh();
      messenger.showSnackBar(SnackBar(content: Text(S.imported(count))));
    } on TranslationFormatException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('$e')));
    } finally {
      installs.done(id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installed = ref.watch(translationsProvider);
    final catalog = ref.watch(_catalogProvider).value ?? const [];
    final installs = ref.watch(_installsProvider);
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final installedIds = {for (final t in installed) t.id};
    final available = [
      for (final c in catalog)
        if (c.available && !installedIds.contains(c.id)) c,
    ];
    final unavailable = [
      for (final c in catalog)
        if (!c.available) c,
    ];

    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          letterSpacing: 1.4,
          fontWeight: FontWeight.w700,
          color: palette.muted,
        ),
      ),
    );

    return ReadableWidth(
      child: Scaffold(
        appBar: AppBar(title: const Text(S.library)),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            MediaQuery.paddingOf(context).bottom + 24,
          ),
          children: [
            Text(
              S.libraryInfo,
              style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted),
            ),
            header(S.installed),
            for (final t in installed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: ListTile(
                    leading: _Badge(text: t.abbreviation, active: true),
                    title: Text(t.name),
                    subtitle: Text(
                      [
                        if (t.year != null) '${t.year}',
                        t.downloaded ? S.installed : S.bundled,
                      ].join(' · '),
                    ),
                    trailing: t.downloaded
                        ? IconButton(
                            tooltip: S.remove,
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _remove(context, ref, t),
                          )
                        : null,
                  ),
                ),
              ),
            if (available.isNotEmpty) header(S.availableToDownload),
            for (final (i, c) in available.indexed)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _Badge(text: c.abbreviation, active: false),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.name,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                  if (c.description != null)
                                    Text(
                                      c.description!,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            if (!installs.containsKey(c.id))
                              FilledButton.tonalIcon(
                                onPressed: () => _install(context, ref, c, i),
                                icon: const Icon(Icons.download, size: 18),
                                label: Text(
                                  c.sizeMb == null
                                      ? S.download
                                      : '${c.sizeMb!.toStringAsFixed(0)} MB',
                                ),
                              ),
                          ],
                        ),
                        if (installs.containsKey(c.id)) ...[
                          const SizedBox(height: 12),
                          _ProgressRow(progress: installs[c.id]),
                        ],
                        if (c.license != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            c.license!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: palette.muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            if (unavailable.isNotEmpty) header(S.unavailable),
            for (final c in unavailable)
              Opacity(
                opacity: 0.7,
                child: Card(
                  child: ListTile(
                    leading: _Badge(text: c.abbreviation, active: false),
                    title: Text(c.name),
                    subtitle: Text(c.description ?? ''),
                  ),
                ),
              ),
            header(S.importFile),
            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text(S.importFile),
                subtitle: const Text(S.importHint),
                onTap: () => _import(context, ref),
              ),
            ),
            for (final e in installs.entries)
              if (e.key.startsWith('U_'))
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _ProgressRow(progress: e.value),
                ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.active});

  final String text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = AppPalette.of(context);
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? palette.gold : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: active ? Colors.white : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.progress});

  final InstallProgress? progress;

  @override
  Widget build(BuildContext context) {
    final (label, value) = switch (progress) {
      Downloading(:final fraction, :final received) => (
        '${S.downloading} ${(received / 1048576).toStringAsFixed(1)} MB',
        fraction,
      ),
      Processing() => (S.processing, null),
      Saving() => (S.saving, null),
      null => (S.downloading, null),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: value,
          minHeight: 5,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog();

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  final _name = TextEditingController();
  final _abbr = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _abbr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(S.importFile),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: const InputDecoration(labelText: S.importName),
          ),
          TextField(
            controller: _abbr,
            maxLength: 6,
            decoration: const InputDecoration(labelText: S.importAbbreviation),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(S.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            final abbr = _abbr.text.trim();
            if (name.isEmpty || abbr.isEmpty) return;
            Navigator.pop(context, (name, abbr));
          },
          child: const Text(S.save),
        ),
      ],
    );
  }
}
