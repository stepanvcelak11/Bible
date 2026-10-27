import 'package:bible_reader/core/utils/morphology_cs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hebrejská morfologie', () {
    expect(
      describeMorphology('HVqp3ms', hebrew: true),
      'sloveso · kal · perfektum · 3. os. · m. r. · j. č.',
    );
    expect(
      describeMorphology('HC/Vqw3ms', hebrew: true),
      'spojka + sloveso · kal · imperfektum s vav (vyprávěcí) · 3. os. · m. r. · j. č.',
    );
    expect(
      describeMorphology('HTd/Ncmpa', hebrew: true),
      'člen (určitý) + podstatné jméno · m. r. · mn. č.',
    );
    expect(describeMorphology('HNpm', hebrew: true), 'vlastní jméno');
  });

  test('řecká morfologie', () {
    expect(
      describeMorphology('V-AAI-3S', hebrew: false),
      'sloveso · aorist · činný rod · oznamovací způsob · 3. os. · j. č.',
    );
    expect(
      describeMorphology('N-GSM', hebrew: false),
      'podstatné jméno · 2. pád · j. č. · m. r.',
    );
    expect(
      describeMorphology('V-PAP-NSM', hebrew: false),
      'sloveso · přítomný čas · činný rod · příčestí · 1. pád · j. č. · m. r.',
    );
    expect(describeMorphology('CONJ', hebrew: false), 'spojka');
  });
}
