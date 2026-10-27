import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/strings_cs.dart';
import '../../../core/providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/map/map_data.dart';
import '../../../domain/entities/study_entities.dart';
import '../../../domain/services/citation.dart';
import '../../reader/application/reader_state.dart';
import '../../shell/home_shell.dart';
import '../../study/application/study_providers.dart';
import '../../translations/application/translation_controller.dart';
import 'map_view.dart';

/// Mapa s místy zmíněnými v kapitole.
Future<void> openChapterMap(BuildContext context, int bookId, int chapter) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MapPage(chapter: (bookId, chapter)),
      ),
    );

/// Mapa zaměřená na jedno místo.
Future<void> openPlaceOnMap(BuildContext context, String placeId) =>
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => MapPage(placeId: placeId)));

/// Sekce „Mapy“ – tematické mapy a všechna místa.
class MapsScreen extends StatelessWidget {
  const MapsScreen({super.key});

  @override
  Widget build(BuildContext context) => const MapPage(isTab: true);
}

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key, this.chapter, this.placeId, this.isTab = false});

  final (int, int)? chapter;
  final String? placeId;
  final bool isTab;

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final _mapKey = GlobalKey<BibleMapViewState>();
  MapRoute? _route;
  BiblePlace? _selected;

  void _selectPlace(BiblePlace place, MapData data) {
    setState(() => _selected = place);
    _mapKey.currentState?.focusPlace(place);
    final mp = data.places.firstWhere((m) => m.place.id == place.id);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, controller) =>
            _PlaceSheet(place: mp, controller: controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(mapDataProvider).value;
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final insets = MediaQuery.paddingOf(context);
    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final chapter = widget.chapter;
    final focus = <BiblePlace>[
      if (chapter != null)
        for (final mp in data.places)
          if (mp.mentionedIn(chapter.$1, chapter.$2)) mp.place,
      if (widget.placeId != null)
        for (final mp in data.places)
          if (mp.place.id == widget.placeId) mp.place,
    ];
    final String title;
    if (chapter != null) {
      final book = ref.watch(bookByIdProvider(chapter.$1));
      title = '${S.chapterPlaces} · ${book.name} ${chapter.$2}';
    } else if (focus.length == 1) {
      title = focus.single.name;
    } else {
      title = S.mapsTitle;
    }

    final topBar = insets.top + 60 + (widget.isTab ? 52 : 0);
    final bottomPad = widget.isTab ? insets.bottom + 90 : insets.bottom + 16;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BibleMapView(
              key: _mapKey,
              data: data,
              route: _route,
              focus: focus,
              selectedPlaceId: _selected?.id,
              padding: EdgeInsets.only(
                top: topBar,
                bottom: bottomPad + (_route != null ? 120 : 0),
              ),
              onPlaceTap: (p) => _selectPlace(p, data),
            ),
          ),
          // Horní lišta: název, hledání míst, tematické mapy.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: insets.top),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withValues(alpha: 0.85),
                    theme.colorScheme.surface.withValues(alpha: 0),
                  ],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        if (!widget.isTab)
                          const BackButton()
                        else
                          const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          tooltip: S.findPlace,
                          icon: const Icon(Icons.search),
                          onPressed: () async {
                            final place = await showSearch<BiblePlace?>(
                              context: context,
                              delegate: _PlaceSearch(data),
                            );
                            if (place != null) _selectPlace(place, data);
                          },
                        ),
                        IconButton(
                          tooltip: S.fitMap,
                          icon: const Icon(Icons.fit_screen_outlined),
                          onPressed: () => _mapKey.currentState?.fitContent(),
                        ),
                      ],
                    ),
                  ),
                  if (widget.isTab)
                    SizedBox(
                      height: 46,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: const Text(S.allPlaces),
                              selected: _route == null,
                              onSelected: (_) => setState(() => _route = null),
                            ),
                          ),
                          for (final r in data.routes)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                avatar: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Color(r.color),
                                ),
                                label: Text(r.name),
                                selected: _route?.id == r.id,
                                onSelected: (_) => setState(() => _route = r),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Popis zvolené trasy.
          if (_route case final r?)
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomPad,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Color(r.color),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              r.name,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(r.description, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 6),
                      Text(
                        r.stops.map((s) => s.name).toSet().join(' → '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: palette.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 12,
            bottom: bottomPad - (_route != null ? 0 : 0) - 4,
            child: Text(
              S.mapCredits,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                color: palette.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceSheet extends ConsumerWidget {
  const _PlaceSheet({required this.place, required this.controller});

  final MapPlace place;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = AppPalette.of(context);
    final translationId = ref.watch(
      translationControllerProvider.select((s) => s.primaryId),
    );
    final verses = place.verses;
    final p = place.place;
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      itemCount: verses.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: theme.textTheme.headlineSmall),
                Text(
                  [
                    if (p.name != p.nameEn) p.nameEn,
                    ?_typeCs(p.type),
                    S.mentions(verses.length),
                  ].join(' · '),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: palette.muted,
                  ),
                ),
              ],
            ),
          );
        }
        final r = verses[i - 1];
        return Consumer(
          builder: (context, ref, _) {
            final book = ref.watch(bookByIdProvider(r.bookId));
            final text = ref.watch(verseTextProvider((translationId, r))).value;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                Citation.single(book.name, r),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: palette.gold,
                ),
              ),
              subtitle: Text(
                text?.text.replaceAll('\n', ' ') ?? '…',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => openReaderAt(context, ref, r),
            );
          },
        );
      },
    );
  }

  static String? _typeCs(String? type) => switch (type) {
    'settlement' => 'sídlo',
    'region' => 'oblast',
    'river' => 'řeka',
    'body of water' => 'vodní plocha',
    'mountain' => 'hora',
    'hill' => 'pahorek',
    'valley' => 'údolí',
    'island' => 'ostrov',
    'spring' => 'pramen',
    'campsite' => 'tábořiště',
    'gate' => 'brána',
    _ => null,
  };
}

class _PlaceSearch extends SearchDelegate<BiblePlace?> {
  _PlaceSearch(this.data) : super(searchFieldLabel: S.findPlace);

  final MapData data;

  // Stránka hledání není MaterialPageRoute → potřebuje vlastní neprůhledné
  // pozadí.
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = super.appBarTheme(context);
    return theme.copyWith(
      scaffoldBackgroundColor: theme.colorScheme.surface,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.colorScheme.surface,
      ),
    );
  }

  static String _fold(String s) {
    const from = 'áčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ';
    const to = 'acdeeinorstuuyzACDEEINORSTUUYZ';
    final b = StringBuffer();
    for (final ch in s.split('')) {
      final i = from.indexOf(ch);
      b.write(i >= 0 ? to[i] : ch);
    }
    return b.toString().toLowerCase();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
      BackButton(onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final q = _fold(query.trim());
    final results = [
      for (final mp in data.places)
        if (q.isEmpty ||
            _fold(mp.place.name).contains(q) ||
            _fold(mp.place.nameEn).contains(q))
          mp.place,
    ]..sort((a, b) => b.verseCount.compareTo(a.verseCount));
    return ListView.builder(
      itemCount: results.length.clamp(0, 200),
      itemBuilder: (context, i) {
        final p = results[i];
        return ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(p.name),
          subtitle: Text(S.mentions(p.verseCount)),
          onTap: () => close(context, p),
        );
      },
    );
  }
}
