import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../domain/entities/bible_entities.dart';
import '../../../domain/services/bible_content.dart';
import '../../../domain/services/plan_info.dart';
import '../../../domain/services/timeline.dart';
import '../../../domain/services/versification.dart';
import '../../connections/presentation/connections_screen.dart';
import '../../content/application/content_providers.dart';
import '../../content/presentation/church_year_screen.dart';
import '../../content/presentation/family_tree_screen.dart';
import '../../content/presentation/harmony_screen.dart';
import '../../content/presentation/notes_screen.dart';
import '../../content/presentation/people_screen.dart';
import '../../content/presentation/quiz_screen.dart';
import '../../content/presentation/situations_screen.dart';
import '../../content/presentation/tables_screen.dart';
import '../../content/presentation/topics_screen.dart';
import '../../guide/presentation/guide_screen.dart';
import '../../guide/presentation/whats_new_sheet.dart';
import '../../maps/presentation/maps_screen.dart';
import '../../memory/presentation/memory_screen.dart';
import '../../plans/application/plans.dart';
import '../../plans/presentation/plans_screen.dart';
import '../../prayer/presentation/lectio_screen.dart';
import '../../prayer/presentation/prayers_view.dart';
import '../../prep/presentation/prep_screen.dart';
import '../../progress/presentation/mosaic.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../reader/application/inline_notes.dart';
import '../../reader/presentation/reflection_sheet.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../shell/home_shell.dart';
import '../../study/application/study_providers.dart';
import '../../study/presentation/book_intro_sheet.dart';
import '../../study/presentation/book_intros_screen.dart';
import '../../study/presentation/courses_screen.dart';
import '../../study/presentation/study_pack_screen.dart';
import '../../today/presentation/plan_detail_screen.dart';
import '../../today/presentation/plans_sheet.dart';
import '../../today/presentation/timeline_screen.dart';
import '../../translations/application/translation_controller.dart';
import '../../translations/presentation/library_screen.dart';
import '../application/app_search.dart';
import '../application/scene_search.dart';

void _push(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

/// Funkce aplikace s výrazy, pod kterými je lidé hledají.
List<AppSearchItem> _features() {
  AppSearchItem f(
    String title,
    String subtitle,
    IconData icon,
    String keywords,
    void Function(BuildContext, WidgetRef) open,
  ) => AppSearchItem(
    kind: AppHitKind.feature,
    title: title,
    subtitle: subtitle,
    icon: icon,
    keywords: keywords,
    open: open,
    boost: 1.15,
  );
  return [
    f(
      'Biblické mapy',
      'Místa a tematické mapy cest',
      Icons.map_outlined,
      'mapa mapy místa země geografie cesty trasy',
      (c, _) => openMaps(c),
    ),
    f(
      'Časová osa',
      'Bible a světové dějiny',
      Icons.view_timeline_outlined,
      'kdy datum datace dějiny historie chronologie letopočet',
      (c, _) => openTimeline(c),
    ),
    f(
      'Plány měst a staveb',
      'Jeruzalém, svatostánek, chrám…',
      Icons.account_balance_outlined,
      'plan mesta stavby chram svatostanek pudorys',
      (c, _) => openPlans(c),
    ),
    f(
      'Rodokmen',
      'Od Adama přes Abrahama a Davida k Ježíši',
      Icons.account_tree_outlined,
      'rodokmen predci genealogie rod rodina potomci',
      (c, _) => openFamilyTree(c),
    ),
    f(
      'Strom Bible',
      'Období, příběhy a postavy',
      Icons.hub_outlined,
      'strom souvislosti obdobi struktura bible celek',
      (c, _) => openConnections(c),
    ),
    f(
      'Velký příběh Bible',
      'Bible jako jeden příběh',
      Icons.auto_stories_outlined,
      'pribeh celek souvislosti dejiny spasy',
      (c, _) => openConnections(c, view: ConnectionsView.story),
    ),
    f(
      'Červené nitě',
      'Témata, která procházejí celou Biblí',
      Icons.timeline,
      'nite souvislosti motivy linie',
      (c, _) => openConnections(c, view: ConnectionsView.threads),
    ),
    f(
      'Oblouky odkazů',
      'Křížové odkazy jako oblouky',
      Icons.architecture,
      'odkazy krizove oblouky souvislosti',
      (c, _) => openConnections(c, view: ConnectionsView.arcs),
    ),
    f(
      'Studijní kurzy',
      'Lekce krok za krokem',
      Icons.school_outlined,
      'kurz kurzy lekce studium ucit naucit',
      (c, _) => openCourses(c),
    ),
    f(
      'Biblická témata',
      'Výklad, zajímavosti a klíčová místa',
      Icons.lightbulb_outline,
      'temata tema vyklad nauka',
      (c, _) => _push(c, const TopicsScreen()),
    ),
    f(
      'Úvody ke knihám',
      'Autor, doba, osnova a témata knih',
      Icons.menu_book_outlined,
      'uvod uvody knihy autor osnova kniha',
      (c, _) => _push(c, const BookIntrosScreen()),
    ),
    f(
      'Biblické postavy',
      'Medailony postav',
      Icons.diversity_3_outlined,
      'postavy osobnosti lide kdo medailon',
      (c, _) => _push(c, const PeopleScreen()),
    ),
    f(
      'Aplikační poznámky',
      'Výklad a použití v životě',
      Icons.sticky_note_2_outlined,
      'poznamky vyklad aplikace',
      (c, _) => _push(c, const NotesScreen()),
    ),
    f(
      'Tabulky a přehledy',
      'Králové, svátky, zázraky…',
      Icons.table_chart_outlined,
      'tabulky prehledy seznam kralove zazraky',
      (c, _) => _push(c, const TablesScreen()),
    ),
    f(
      'Harmonie evangelií',
      'Ježíšův život v pořadí',
      Icons.view_week_outlined,
      'harmonie evangelia porovnani synopse vedle sebe',
      (c, _) => _push(c, const HarmonyScreen()),
    ),
    f(
      'Verše do situací',
      'Co právě prožíváte',
      Icons.favorite_border,
      'situace pocity strach smutek radost pomoc utecha',
      (c, _) => _push(c, const SituationsScreen()),
    ),
    f(
      'Verše nazpaměť',
      'Naučte se verše krok za krokem',
      Icons.psychology_outlined,
      'nazpamet naucit memorovat zapamatovat verse',
      (c, _) => openMemory(c),
    ),
    f(
      'Modlitby',
      'Za co se modlíte a co Bůh vyslyšel',
      Icons.volunteer_activism_outlined,
      'modlitba modlitby modlitebni seznam prosby',
      (c, _) => openPrayers(c),
    ),
    f(
      'Lectio divina',
      'Modlitební čtení se čtyřmi kroky',
      Icons.spa_outlined,
      'lectio divina meditace ztiseni rozjimani modlitebni cteni',
      (c, _) => openLectio(c),
    ),
    f(
      'Biblický kvíz',
      'Otestujte se',
      Icons.emoji_events_outlined,
      'kviz test otazky hra soutez',
      (c, _) => openQuiz(c),
    ),
    f(
      'Církevní rok',
      'Doby a svátky s čteními',
      Icons.donut_large,
      'cirkevni rok svatky advent vanoce velikonoce pust letnice kalendar',
      (c, _) => openChurchYear(c),
    ),
    f(
      'Plány čtení',
      'Pravidelné čtení po malých dávkách',
      Icons.event_note_outlined,
      'plan plany cteni denne cist kazdy den rok',
      (c, _) => showPlansSheet(c),
    ),
    f(
      'Přípravy',
      'Kázání, skupinka, program',
      Icons.edit_note,
      'priprava kazani skupinka program biblicka hodina',
      (c, _) => openPreps(c),
    ),
    f(
      'Studijní balíček',
      'Původní text, slovník, souvislosti',
      Icons.history_edu,
      'recky hebrejsky original puvodni text slovnik strong lexikon',
      (c, _) => _push(c, const StudyPackScreen()),
    ),
    f(
      'Překlady',
      'Stáhnout a spravovat překlady',
      Icons.translate,
      'preklad preklady stahnout b21 cep csp kralicka',
      (c, _) => _push(c, const LibraryScreen()),
    ),
    f(
      'Nastavení',
      'Vzhled, písmo, překlady, záloha',
      Icons.tune,
      'nastaveni vzhled pismo velikost tmavy rezim barva zaloha',
      (c, _) => _push(c, const SettingsScreen()),
    ),
    f(
      'Můj pokrok',
      'Statistiky čtení, série a odznaky',
      Icons.insights_outlined,
      'pokrok statistiky serie odznaky precteno kalendar',
      (c, _) => openProgress(c),
    ),
    f(
      'Mozaika celé Bible',
      'Obraz z přečtených kapitol',
      Icons.grid_view_rounded,
      'mozaika obraz kaminky',
      (c, _) => _push(c, const MosaicScreen()),
    ),
    f(
      'Deník',
      'Záložky, poznámky, zvýraznění',
      Icons.bookmarks_outlined,
      'denik zalozky poznamky zvyrazneni moje',
      (c, r) => r.read(shellTabProvider.notifier).select(AppTab.journal),
    ),
    f(
      'Průvodce aplikací',
      'Jak aplikace funguje',
      Icons.help_outline,
      'pruvodce napoveda navod pomoc jak',
      (c, _) => openGuide(c),
    ),
    f(
      'Co je nového',
      'Novinky v aplikaci',
      Icons.auto_awesome,
      'novinky co je noveho zmeny',
      (c, _) => showWhatsNew(c),
    ),
  ];
}

/// Index všeho obsahu aplikace pro chytré hledání (načte se jednou).
final appSearchIndexProvider = FutureProvider<List<AppSearchItem>>((ref) async {
  final books = ref.watch(booksProvider);
  String book(int id) =>
      id >= 1 && id <= books.length ? books[id - 1].name : '';
  final items = <AppSearchItem>[..._features()];

  final (topicCats, topics) = await ref.watch(topicsProvider.future);
  final catNames = {for (final (id, n) in topicCats) id: n};
  for (final t in topics) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.topic,
        title: t.title,
        subtitle: t.summary,
        icon: situationIcons[t.icon] ?? Icons.lightbulb_outline,
        keywords: '${t.labels.join(' ')} ${catNames[t.category] ?? ''}',
        body: '${t.summary} ${t.deeper.join(' ')} ${t.facts.join(' ')}',
        open: (c, _) => openTopic(c, t),
        boost: 1.1,
      ),
    );
  }

  for (final c in await ref.watch(coursesProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.course,
        title: c.title,
        subtitle: c.subtitle,
        icon: courseIcon(c),
        keywords: c.lessons.map((l) => l.title).join(' '),
        body: c.intro,
        color: c.color,
        open: (ctx, _) => openCourse(ctx, c),
        boost: 1.1,
      ),
    );
    for (final l in c.lessons) {
      items.add(
        AppSearchItem(
          kind: AppHitKind.lesson,
          title: l.title,
          subtitle: '${c.title} · lekce ${l.index + 1}',
          icon: courseIcon(c),
          keywords: l.labels.join(' '),
          body: '${l.text.join(' ')} ${l.facts.join(' ')}',
          color: c.color,
          open: (ctx, _) => openLesson(ctx, c, l),
        ),
      );
    }
  }

  for (final p in readingPlans) {
    final info = planInfoFor(p.id);
    items.add(
      AppSearchItem(
        kind: AppHitKind.readingPlan,
        title: p.name,
        subtitle: p.description,
        icon: Icons.event_note_outlined,
        keywords: 'plan cteni',
        body: '${p.description} ${info.about.join(' ')} ${info.forWhom}',
        open: (c, _) => openPlanDetail(c, p),
      ),
    );
  }

  for (final s in (await ref.watch(situationsProvider.future)).$2) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.situation,
        title: s.title,
        subtitle: s.intro,
        icon: situationIcons[s.icon] ?? Icons.favorite_border,
        body: '${s.intro} ${s.thoughts.join(' ')}',
        open: (c, _) => openSituation(c, s),
        boost: 1.05,
      ),
    );
  }

  for (final p in await ref.watch(peopleProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.person,
        title: p.name,
        subtitle: p.role,
        icon: Icons.person_outline,
        keywords: '${p.role} ${p.occupation}',
        body:
            '${p.where} ${p.relatives} ${p.strengths.join(' ')} '
            '${p.weaknesses.join(' ')} ${p.lessons.join(' ')}',
        open: (c, _) => openPerson(c, p),
        boost: 1.05,
      ),
    );
  }

  final intros = await ref.watch(bookIntrosProvider.future);
  for (final MapEntry(key: id, value: i) in intros.entries) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.intro,
        title: book(id),
        subtitle: i.theme,
        icon: Icons.menu_book_outlined,
        keywords:
            'uvod kniha ${i.author} ${i.people.join(' ')} '
            '${i.places.join(' ')}',
        body:
            '${i.summary} ${i.purpose} ${i.background} '
            '${i.themes.map((t) => '${t.title} ${t.text}').join(' ')}',
        open: (c, _) => showBookIntro(c, id),
      ),
    );
  }

  for (final e in await ref.watch(storyProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.story,
        title: e.title,
        subtitle: e.period,
        icon: Icons.auto_stories_outlined,
        body: e.summary,
        open: (c, _) => showEra(c, e),
      ),
    );
  }
  for (final s in await ref.watch(storiesProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.story,
        title: s.title,
        subtitle: s.span,
        icon: Icons.auto_stories_outlined,
        body: s.summary,
        open: (c, r) => openReaderAt(c, r, s.passage.start),
      ),
    );
  }
  // Konkrétní scény, zázraky, podobenství a známé verše.
  for (final sc in (await ref.watch(sceneIndexProvider.future)).items) {
    final b = book(sc.passage.bookId);
    items.add(
      AppSearchItem(
        kind: AppHitKind.story,
        title: sc.title,
        subtitle: '${sc.kind.label} · ${sc.passage.label(b)}',
        icon: switch (sc.kind) {
          SceneKind.miracle => Icons.auto_awesome_outlined,
          SceneKind.parable => Icons.lightbulb_outline,
          SceneKind.verse => Icons.format_quote_outlined,
          SceneKind.story => Icons.auto_stories_outlined,
        },
        keywords: sc.stems.join(' '),
        open: (c, r) => openReaderAt(c, r, sc.passage.start),
      ),
    );
  }
  for (final t in await ref.watch(threadsProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.thread,
        title: t.title,
        subtitle: t.intro,
        icon: Icons.timeline,
        keywords: t.stations.map((s) => s.title).join(' '),
        body: '${t.intro} ${t.stations.map((s) => s.text).join(' ')}',
        color: t.color,
        open: (c, _) => openConnections(c, view: ConnectionsView.threads),
      ),
    );
  }

  for (final (i, e) in timelineEvents.indexed) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.timeline,
        title: e.title,
        subtitle: e.date,
        icon: Icons.view_timeline_outlined,
        keywords: e.era.label,
        body: e.description,
        open: (c, _) => openTimeline(c, focus: i),
      ),
    );
  }

  for (final t in await ref.watch(tablesProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.table,
        title: t.title,
        subtitle: t.intro,
        icon: Icons.table_chart_outlined,
        body: '${t.intro} ${t.note}',
        open: (c, _) => openTable(c, t),
      ),
    );
  }
  for (final n in await ref.watch(notesProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.appNote,
        title: n.title,
        subtitle: n.explanation,
        icon: Icons.sticky_note_2_outlined,
        body: '${n.explanation} ${n.bridge} ${n.application}',
        open: (c, _) => showNoteSheet(c, n),
      ),
    );
  }
  for (final per in await ref.watch(harmonyProvider.future)) {
    for (final e in per.events) {
      items.add(
        AppSearchItem(
          kind: AppHitKind.harmony,
          title: e.title,
          subtitle: per.name,
          icon: Icons.view_week_outlined,
          open: (c, _) => _push(c, const HarmonyScreen()),
        ),
      );
    }
  }
  final (seasons, feasts) = await ref.watch(churchYearProvider.future);
  for (final x in [...seasons.values, ...feasts.values]) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.church,
        title: x.name,
        subtitle: x.text,
        icon: Icons.donut_large,
        body: x.text,
        open: (c, _) => openChurchYear(c),
      ),
    );
  }

  final map = await ref.watch(mapDataProvider.future);
  for (final mp in map.places) {
    final p = mp.place;
    items.add(
      AppSearchItem(
        kind: AppHitKind.map,
        title: p.name,
        subtitle: '${placeTypeCs(p.type) ?? 'místo'} · ${p.verseCount} veršů',
        icon: Icons.place_outlined,
        keywords: p.nameEn,
        open: (c, _) => openPlaceOnMap(c, p.id),
        // Často zmiňovaná místa výš (Jeruzalém před malou vesnicí).
        boost: 0.9 + (p.verseCount.clamp(0, 400) / 2000),
      ),
    );
  }
  for (final r in map.routes) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.route,
        title: r.name,
        subtitle: r.description,
        icon: Icons.route_outlined,
        keywords: r.stops.map((s) => s.name).join(' '),
        body: r.description,
        color: r.color,
        open: (c, _) => openMaps(c, routeId: r.id),
        boost: 1.1,
      ),
    );
  }
  for (final p in await ref.watch(plansProvider.future)) {
    items.add(
      AppSearchItem(
        kind: AppHitKind.cityPlan,
        title: p.title,
        subtitle: p.subtitle,
        icon: Icons.account_balance_outlined,
        keywords: p.parts.map((x) => x.name).join(' '),
        body: '${p.intro} ${p.parts.map((x) => x.text).join(' ')}',
        open: (c, _) => openPlan(c, p),
        boost: 1.1,
      ),
    );
  }

  // Zamyšlení ke každé kapitole (kanonické číslování).
  final reflections = await ref.watch(reflectionsProvider.future);
  for (final MapEntry(key: b, value: chapters) in reflections.entries) {
    for (final (i, r) in chapters.indexed) {
      items.add(
        AppSearchItem(
          kind: AppHitKind.reflection,
          title: '${book(b)} ${i + 1}',
          subtitle: r.focus,
          icon: Icons.self_improvement,
          body: '${r.focus} ${r.observe} ${r.understand} ${r.life}',
          open: (c, ref) {
            final tid = ref.read(translationControllerProvider).primaryId;
            final v = Versification.convert(
              VerseRef(b, i + 1, 1),
              VerseScheme.hebrew,
              schemeOf(tid),
            );
            showReflectionSheet(c, bookId: v.bookId, chapter: v.chapter);
          },
          boost: 0.85,
        ),
      );
    }
  }

  // Poznámky v textu (2400 krátkých vysvětlení u veršů).
  for (var b = 1; b <= 66; b++) {
    for (final n in await ref.watch(bookInlineNotesProvider(b).future)) {
      items.add(
        AppSearchItem(
          kind: AppHitKind.inlineNote,
          title: n.title,
          subtitle: '${book(b)} ${n.ref.chapter},${n.ref.verse} · ${n.text}',
          icon: Icons.lightbulb_outline,
          body: n.text,
          open: (c, r) => openReaderAt(c, r, n.ref),
          boost: 0.9,
        ),
      );
    }
  }
  return items;
});
