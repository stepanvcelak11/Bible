/// Převod morfologických kódů původního textu do srozumitelné češtiny.
///
/// * Hebrejština/aramejština: kódy OSHB (Open Scriptures Hebrew Bible),
///   např. `HVqp3ms` = sloveso, kal, perfektum, 3. os., m. r., j. č.
///   Předpony jsou odděleny lomítkem: `HC/Vqw3ms`.
/// * Řečtina: Robinsonovy kódy, např. `V-AAI-3S`, `N-GSM`.
String describeMorphology(String code, {required bool hebrew}) {
  if (code.isEmpty) return '';
  return hebrew ? _hebrew(code) : _greek(code);
}

// --- Hebrejština (OSHB) --------------------------------------------------------

const _hebPos = {
  'A': 'přídavné jméno',
  'C': 'spojka',
  'D': 'příslovce',
  'N': 'podstatné jméno',
  'P': 'zájmeno',
  'R': 'předložka',
  'S': 'přípona',
  'T': 'částice',
  'V': 'sloveso',
};

const _hebStem = {
  'q': 'kal',
  'N': 'nifal',
  'p': 'piel',
  'P': 'pual',
  'h': 'hifil',
  'H': 'hofal',
  't': 'hitpael',
  'o': 'polel',
  'O': 'polal',
  'r': 'hitpolel',
  'm': 'poel',
  'M': 'poal',
  'k': 'palel',
  'K': 'pulal',
  'Q': 'kal pasivum',
  'l': 'pilpel',
  'L': 'polpal',
  'f': 'hitpalpel',
  'D': 'nitpael',
  'j': 'pealal',
  'i': 'piel',
  'u': 'hotpaal',
  'c': 'tifil',
  'v': 'hištafel',
  'w': 'hitpaal',
  'y': 'jifil',
  'z': 'hitpoel',
};

const _hebAspect = {
  'p': 'perfektum',
  'q': 'perfektum s vav',
  'i': 'imperfektum',
  'w': 'imperfektum s vav (vyprávěcí)',
  'h': 'kohortativ',
  'j': 'jusiv',
  'v': 'rozkazovací způsob',
  'r': 'příčestí činné',
  's': 'příčestí trpné',
  'a': 'infinitiv absolutní',
  'c': 'infinitiv vázaný',
};

const _gender = {
  'm': 'm. r.',
  'f': 'ž. r.',
  'c': 'společný r.',
  'b': 'oba rody',
};
const _number = {'s': 'j. č.', 'p': 'mn. č.', 'd': 'dvojné č.'};

const _hebParticle = {
  'Td': 'člen (určitý)',
  'To': 'označení předmětu',
  'Ta': 'citoslovce',
  'Tn': 'zápor',
  'Ti': 'tázací',
  'Tr': 'vztažná',
  'Tm': 'zdůrazňující',
  'Te': 'zvolání',
  'Tj': 'spojovací',
};

String _hebrew(String code) {
  final parts = code.substring(1).split('/');
  return parts.map(_hebSegment).where((s) => s.isNotEmpty).join(' + ');
}

String _hebSegment(String s) {
  if (s.isEmpty) return '';
  final pos = s[0];
  final out = <String>[];
  if (pos == 'T' && s.length >= 2) {
    return _hebParticle[s.substring(0, 2)] ?? 'částice';
  }
  out.add(_hebPos[pos] ?? pos);
  var i = 1;
  String? at(int k) => k < s.length ? s[k] : null;
  switch (pos) {
    case 'V':
      if (_hebStem[at(i)] case final stem?) out.add(stem);
      i++;
      if (_hebAspect[at(i)] case final a?) out.add(a);
      i++;
      final aspect = at(i - 1);
      if (aspect == 'r' || aspect == 's') {
        if (_gender[at(i)] case final g?) out.add(g);
        if (_number[at(i + 1)] case final n?) out.add(n);
      } else if (aspect != 'a' && aspect != 'c') {
        if (at(i) case final p? when '123'.contains(p)) out.add('$p. os.');
        if (_gender[at(i + 1)] case final g?) out.add(g);
        if (_number[at(i + 2)] case final n?) out.add(n);
      }
    case 'N' || 'A':
      final type = at(i);
      if (type == 'p') {
        out[0] = 'vlastní jméno';
        return out.join(' · ');
      }
      i++;
      if (_gender[at(i)] case final g?) out.add(g);
      if (_number[at(i + 1)] case final n?) out.add(n);
      if (at(i + 2) == 'c') out.add('vázaný stav');
    case 'P' || 'S':
      final rest = s.substring(1);
      for (final ch in rest.split('')) {
        if ('123'.contains(ch)) out.add('$ch. os.');
        if (_gender[ch] case final g?) out.add(g);
        if (_number[ch] case final n?) out.add(n);
      }
  }
  return out.join(' · ');
}

// --- Řečtina (Robinson) --------------------------------------------------------

const _grkPos = {
  'N': 'podstatné jméno',
  'A': 'přídavné jméno',
  'T': 'člen',
  'V': 'sloveso',
  'P': 'osobní zájmeno',
  'R': 'vztažné zájmeno',
  'C': 'zvratné zájmeno',
  'D': 'ukazovací zájmeno',
  'K': 'souvztažné zájmeno',
  'I': 'tázací zájmeno',
  'X': 'neurčité zájmeno',
  'Q': 'souvztažné zájmeno',
  'F': 'zvratné zájmeno',
  'S': 'přivlastňovací zájmeno',
  'ADV': 'příslovce',
  'CONJ': 'spojka',
  'COND': 'podmínková spojka',
  'PREP': 'předložka',
  'PRT': 'částice',
  'INJ': 'citoslovce',
  'ARAM': 'aramejské slovo',
  'HEB': 'hebrejské slovo',
};

const _case = {
  'N': '1. pád',
  'G': '2. pád',
  'D': '3. pád',
  'A': '4. pád',
  'V': '5. pád',
};
const _grkGender = {'M': 'm. r.', 'F': 'ž. r.', 'N': 's. r.'};
const _grkNumber = {'S': 'j. č.', 'P': 'mn. č.'};

const _tense = {
  'P': 'přítomný čas',
  'I': 'imperfektum',
  'F': 'budoucí čas',
  'A': 'aorist',
  'R': 'perfektum',
  'L': 'plusquamperfektum',
  '2': 'druhý',
};
const _voice = {
  'A': 'činný rod',
  'M': 'střední rod',
  'P': 'trpný rod',
  'E': 'střední/trpný',
  'D': 'střední (deponens)',
  'O': 'trpný (deponens)',
  'N': 'střední/trpný (deponens)',
};
const _mood = {
  'I': 'oznamovací způsob',
  'S': 'spojovací způsob',
  'O': 'optativ',
  'M': 'rozkazovací způsob',
  'N': 'infinitiv',
  'P': 'příčestí',
};

String _greek(String code) {
  final parts = code.split('-');
  final head = parts.first;
  final out = <String>[_grkPos[head] ?? head];
  if (head == 'V' && parts.length > 1) {
    final tvm = parts[1];
    var k = 0;
    if (tvm.isNotEmpty && tvm[0] == '2') k = 1; // 2. aorist apod.
    if (_tense[tvm.length > k ? tvm[k] : ''] case final t?) out.add(t);
    if (_voice[tvm.length > k + 1 ? tvm[k + 1] : ''] case final v?) out.add(v);
    if (_mood[tvm.length > k + 2 ? tvm[k + 2] : ''] case final m?) out.add(m);
    if (parts.length > 2) {
      final pn = parts[2];
      if (pn.length == 2 && '123'.contains(pn[0])) {
        out.add('${pn[0]}. os.');
        if (_grkNumber[pn[1]] case final n?) out.add(n);
      } else if (pn.length >= 3) {
        out.addAll(_caseNumberGender(pn));
      }
    }
  } else if (parts.length > 1) {
    final rest = parts[1];
    // Zájmena osobní: P-1GS (osoba, pád, číslo).
    if (rest.isNotEmpty && '123'.contains(rest[0])) {
      out.add('${rest[0]}. os.');
      if (_case[rest.length > 1 ? rest[1] : ''] case final c?) out.add(c);
      if (_grkNumber[rest.length > 2 ? rest[2] : ''] case final n?) out.add(n);
    } else {
      out.addAll(_caseNumberGender(rest));
    }
    if (parts.contains('P') && head == 'N') out[0] = 'vlastní jméno';
  }
  return out.join(' · ');
}

List<String> _caseNumberGender(String s) => [
  ?_case[s.isNotEmpty ? s[0] : ''],
  ?_grkNumber[s.length > 1 ? s[1] : ''],
  ?_grkGender[s.length > 2 ? s[2] : ''],
];
