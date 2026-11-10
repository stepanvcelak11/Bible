/// Podrobnější popis plánů čtení: o čem plán je, proč ho číst, pro koho
/// je vhodný a jak s ním pracovat (vlastní texty aplikace).
class PlanInfo {
  const PlanInfo({
    required this.about,
    required this.forWhom,
    required this.tips,
  });

  /// Odstavce „O plánu“.
  final List<String> about;
  final String forWhom;
  final List<String> tips;
}

const _defaultTips = [
  'Vyberte si stálou chvíli dne – ráno s kávou, cestou do práce nebo večer.',
  'Když den vynecháte, nic se neděje. Prostě pokračujte dalším dnem.',
  'Než začnete, krátce se pomodlete: „Pane, mluv ke mně.“',
];

const customPlanInfo = PlanInfo(
  about: [
    'Vlastní plán rozdělí knihy, které jste si vybrali, rovnoměrně do '
        'zvoleného počtu dní. Každý den tedy čtete zhruba stejně dlouho.',
  ],
  forWhom:
      'Pro každého, kdo chce projít konkrétní knihu nebo část Bible '
      'svým tempem.',
  tips: _defaultTips,
);

const planInfo = <String, PlanInfo>{
  'start14': PlanInfo(
    about: [
      'Lukášovo evangelium je ideální první kniha: vypráví celý Ježíšův '
          'příběh od narození po vzkříšení a je psané pro člověka, který '
          'o víře teprve slyší. Lukáš byl lékař a pečlivý historik – sám '
          'píše, že vše „pečlivě prošel od začátku“.',
      'Najdete tu nejznámější příběhy: Vánoce, milosrdného Samaritána, '
          'ztraceného syna, Zachea i cestu do Emauz. Za dva týdny poznáte, '
          'kdo byl Ježíš a proč na něm křesťanům tolik záleží.',
    ],
    forWhom:
        'Pro začátečníky a pro každého, kdo se chce k Bibli vrátit '
        'od základů.',
    tips: [
      'Čtěte jako příběh – nemusíte rozumět všemu.',
      'Všímejte si, s kým Ježíš jí a s kým mluví.',
      'Když vás něco zaujme, zapište si to do Deníku.',
    ],
  ),
  'gospels40': PlanInfo(
    about: [
      'Čtyři evangelia vyprávějí o Ježíši čtyřmi pohledy. Matouš ukazuje '
          'Ježíše jako zaslíbeného Mesiáše a Učitele, Marek jako rázného '
          'Služebníka v akci, Lukáš jako Zachránce ztracených a Jan jako '
          'věčné Slovo, které se stalo člověkem.',
      'Za 40 dní – stejně dlouho jako trvá postní doba nebo Ježíšův pobyt '
          'na poušti – projdete celý jeho život čtyřikrát a pokaždé si '
          'všimnete něčeho jiného.',
    ],
    forWhom: 'Pro každého, kdo chce poznat Ježíše z první ruky.',
    tips: [
      'Když narazíte na stejný příběh podruhé, porovnejte, čím se liší.',
      'V aplikaci najdete Harmonii evangelií – příběhy vedle sebe.',
      'U každého evangelia si nejdřív přečtěte jeho úvod ke knize.',
    ],
  ),
  'nt90': PlanInfo(
    about: [
      'Nový zákon za tři měsíce: evangelia, Skutky apoštolů, Pavlovy '
          'a další dopisy a nakonec Zjevení. Uvidíte, jak se z malé skupiny '
          'učedníků stala církev rozšířená po celém Středomoří.',
      'Tempo kolem tří kapitol denně je zvládnutelné za čtvrt hodiny. '
          'Díky souvislému čtení pochopíte dopisy v kontextu – víte, komu '
          'a proč byly napsány.',
    ],
    forWhom:
        'Pro ty, kdo už znají základy a chtějí mít Nový zákon '
        'v celku.',
    tips: [
      'Dopisy jsou psané k přečtení najednou – když máte čas, dočtěte '
          'krátký list celý.',
      'Před každou novou knihou si otevřete její úvod (tlačítko nad '
          'kapitolou).',
      'Zkuste si jeden verš týdně uložit mezi Verše nazpaměť.',
    ],
  ),
  'paul30': PlanInfo(
    about: [
      'Třináct dopisů apoštola Pavla – od velkého výkladu víry v listu '
          'Římanům po krátký osobní dopis Filemonovi o uprchlém otrokovi. '
          'Pavel v nich řeší skutečné problémy prvních sborů: spory, '
          'pochybnosti, pronásledování i otázky každodenního života.',
      'Za měsíc uvidíte, jak Pavel stále znovu vychází z jednoho středu: '
          'z Kristovy smrti a vzkříšení a z milosti, která proměňuje život.',
    ],
    forWhom:
        'Pro ty, kdo chtějí víc rozumět křesťanské víře a jejímu '
        'praktickému žití.',
    tips: [
      'Ptejte se: jaký problém Pavel v tomto dopise řeší?',
      'Všimněte si, že dopisy mají nejdřív výklad víry a potom praktické '
          'rady.',
      'Kurz „Pavel a první církev“ ve Studiu dává dopisům kontext.',
    ],
  ),
  'psalms31': PlanInfo(
    about: [
      'Žalmy jsou modlitební kniha Bible – chvála, díky, nářek, prosby '
          'i otázky. Přísloví jsou praktická moudrost pro všední den: '
          'o slovech, penězích, práci, přátelství a lenosti.',
      'Každý den pět žalmů a jedna kapitola Přísloví (Přísloví mají 31 '
          'kapitol – jednu na každý den v měsíci). Za měsíc přečtete celý '
          'žaltář a celou knihu moudrosti.',
    ],
    forWhom:
        'Pro každého, kdo se chce naučit modlit a hledá moudrost pro '
        'běžné rozhodování.',
    tips: [
      'Zkuste některý žalm přečíst nahlas jako vlastní modlitbu.',
      'Z Přísloví si vyberte jeden verš na celý den.',
      'Plán se dá opakovat každý měsíc – pokaždé osloví něco jiného.',
    ],
  ),
  'story50': PlanInfo(
    about: [
      'Padesát klíčových kapitol, které dohromady vyprávějí velký příběh '
          'Bible: stvoření, pád, Abraham, exodus, Desatero, David, proroci, '
          'vyhnanství, narození Ježíše, kříž, vzkříšení, církev a nové '
          'stvoření.',
      'Je to mapa celé Bible – po ní se budete v jednotlivých knihách mnohem '
          'lépe orientovat. Každý den jedna kapitola, asi pět minut.',
    ],
    forWhom:
        'Pro začátečníky i pro ty, kdo chtějí vidět souvislosti '
        'celé Bible.',
    tips: [
      'Ve Studiu otevřete Souvislosti v Bibli → Příběh: uvidíte, kam '
          'dnešní kapitola patří.',
      'Ptejte se: co se v této kapitole dozvídám o Bohu?',
      'Po dokončení zkuste plán „Celá Bible za rok“.',
    ],
  ),
  'bible365': PlanInfo(
    about: [
      'Celá Bible od Genesis po Zjevení v pořadí, jak je vydaná. Za rok '
          'projdete všech 1189 kapitol – příběhy, zákony, poezii, proroky, '
          'evangelia i dopisy.',
      'Čtení od začátku do konce ukazuje, jak na sebe knihy navazují. '
          'Připravte se, že některé části (Leviticus, rodokmeny, popisy '
          'stánku) jsou náročnější – i ty ale mají svůj smysl a v aplikaci '
          'k nim najdete poznámky.',
    ],
    forWhom: 'Pro ty, kdo chtějí jednou v životě přečíst celou Bibli.',
    tips: [
      'Počítejte s 15–20 minutami denně.',
      'Když se zaseknete v náročné knize, čtěte poznámky v textu – '
          'vysvětlují, co to tehdy znamenalo.',
      'Pokud vás víc baví střídání, zvolte variantu SZ i NZ souběžně.',
    ],
  ),
  'both365': PlanInfo(
    about: [
      'Celá Bible za rok, ale každý den kousek ze Starého i Nového zákona. '
          'Čtení je pestřejší a nezůstanete týdny v jedné náročné knize.',
      'Souběžné čtení navíc ukazuje souvislosti: v jeden den čtete '
          'o Mojžíšovi a zároveň o Ježíši, který Mojžíšův zákon naplňuje.',
    ],
    forWhom:
        'Pro ty, kdo chtějí přečíst celou Bibli a mít každý den '
        'rozmanité čtení.',
    tips: [
      'Začněte Novým zákonem, pokud máte málo času – je kratší a '
          'povzbudivější.',
      'Všímejte si, kde Nový zákon cituje Starý.',
      'Počítejte s 15–20 minutami denně.',
    ],
  ),
  'advent24': PlanInfo(
    about: [
      'Advent je čas čekání. Tento plán vás provede Božími zaslíbeními '
          'od Genesis přes Izajáše a Micheáše až k narození v Betlémě – '
          'tak, jak na Mesiáše čekal Izrael.',
      'Každý den jedna kapitola, začněte 1. prosince a skončíte na Štědrý '
          'den zprávou o narození Ježíše.',
    ],
    forWhom: 'Pro každého, kdo chce prožít Vánoce s větší hloubkou.',
    tips: [
      'Zapalte si při čtení svíčku.',
      'Ptejte se: na co čekám já?',
      'Čtěte s rodinou nebo dětmi – kapitoly jsou krátké.',
    ],
  ),
  'lent40': PlanInfo(
    about: [
      'Čtyřicet dní postní doby: žalmy pokání, Markovo evangelium '
          'a poslední Ježíšovy dny podle Jana. Plán vede ke Kristovu kříži '
          'a končí velikonočním ránem.',
      'Postní doba je čas ztišení a návratu k Bohu. Kapitoly jsou vybrané '
          'tak, aby se prolínalo pokání, Ježíšův příběh a naděje.',
    ],
    forWhom: 'Pro přípravu na Velikonoce – začněte na Popeleční středu.',
    tips: [
      'Spojte čtení s malým půstem – od telefonu, sladkostí nebo hluku.',
      'O Svatém týdnu čtěte pomalu a zastavujte se u Ježíšových slov.',
      'Ve Studiu je oddíl Církevní rok s dalšími čteními.',
    ],
  ),
  'easter50': PlanInfo(
    about: [
      'Velikonoce netrvají jeden den, ale padesát – až do Letnic. Plán '
          'začíná zprávami o vzkříšení ze všech čtyř evangelií, pokračuje '
          'celými Skutky apoštolů a končí listy o novém životě.',
      'Uvidíte, jak vzkříšení proměnilo ustrašené učedníky v odvážné '
          'svědky a jak se rodila církev.',
    ],
    forWhom:
        'Pro čas po Velikonocích a pro každého, kdo potřebuje '
        'naději.',
    tips: [
      'Všímejte si, co vzkříšení mění v životech lidí.',
      'Ve Skutcích sledujte na mapě, kam se evangelium šíří.',
      'Na Letnice si přečtěte Sk 2 ještě jednou.',
    ],
  ),
};

PlanInfo planInfoFor(String id) => planInfo[id] ?? customPlanInfo;
