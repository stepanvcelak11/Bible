import 'bible_entities.dart';

/// Jedno slovo původního (hebrejského/řeckého) textu verše.
class OriginalWord {
  const OriginalWord({
    required this.text,
    required this.transliteration,
    required this.english,
    required this.strong,
    required this.morphology,
  });

  /// Slovo v původním jazyce (hebrejsky bez kantilace / řecky).
  final String text;
  final String transliteration;

  /// Anglický překlad slova v daném kontextu (STEPBible).
  final String english;

  /// Strongovo číslo, např. `H1980` nebo `G0025` (prázdné u částic).
  final String strong;

  /// Morfologický kód (OSHB pro hebrejštinu, Robinson pro řečtinu).
  final String morphology;

  bool get isHebrew => strong.startsWith('H') || morphology.startsWith('H');
}

/// Heslo slovníku.
class LexiconEntry {
  const LexiconEntry({
    required this.strong,
    required this.lemma,
    required this.transliteration,
    required this.glossEn,
    required this.definition,
    required this.occurrences,
    this.glossCs,
    this.partOfSpeech,
  });

  final String strong;
  final String lemma;
  final String transliteration;

  /// Český význam (u ~1000 nejčastějších slov), jinak `null`.
  final String? glossCs;
  final String glossEn;

  /// Podrobný anglický výklad (STEPBible).
  final String definition;
  final int occurrences;
  final String? partOfSpeech;

  bool get isHebrew => strong.startsWith('H');
}

/// Křížový odkaz (souvislost) na jiný verš nebo úsek.
class CrossReference {
  const CrossReference({
    required this.target,
    required this.endVerse,
    required this.votes,
  });

  final VerseRef target;
  final int endVerse;

  /// Kolik čtenářů OpenBible souvislost potvrdilo (síla vazby).
  final int votes;
}

/// Biblické místo se souřadnicemi.
class BiblePlace {
  const BiblePlace({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.lon,
    required this.lat,
    required this.verseCount,
    this.type,
  });

  final String id;
  final String name;
  final String nameEn;
  final String? type;
  final double lon;
  final double lat;
  final int verseCount;
}

/// Zastávka tematické mapy.
class RouteStop {
  const RouteStop({
    required this.placeId,
    required this.name,
    required this.lon,
    required this.lat,
  });

  final String placeId;
  final String name;
  final double lon;
  final double lat;
}

/// Tematická mapa (trasa).
class MapRoute {
  const MapRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.stops,
  });

  final String id;
  final String name;
  final String description;

  /// Barva jako ARGB.
  final int color;
  final List<RouteStop> stops;
}

/// Úvod k biblické knize.
class BookIntro {
  const BookIntro({
    required this.author,
    required this.date,
    required this.theme,
    required this.summary,
    required this.outline,
    required this.keyVerses,
  });

  factory BookIntro.fromJson(Map<String, Object?> j) => BookIntro(
    author: j['author']! as String,
    date: j['date']! as String,
    theme: j['theme']! as String,
    summary: j['summary']! as String,
    outline: [for (final o in j['outline']! as List<Object?>) o! as String],
    keyVerses: [for (final o in j['keyVerses']! as List<Object?>) o! as String],
  );

  final String author;
  final String date;
  final String theme;
  final String summary;
  final List<String> outline;

  /// Klíčové verše ve tvaru „3:16“ nebo „3:16-17“.
  final List<String> keyVerses;
}
