"""Velký příběh Bible: období, knihy, které o nich vyprávějí, a knihy,
které k nim patří (vlastní texty aplikace).

Datace jsou přibližné; u starších období se odborníci rozcházejí.
"""

# id, název, doba, shrnutí, vyprávějí [zkratky], větve [(popisek,
# [zkratky])], klíčová místa [(odkaz, popisek)]
ERAS = [
    ("creation", "Stvoření a pád", "počátek",
     "Bůh tvoří dobrý svět a člověka ke svému obrazu. Lidé však Bohu "
     "nedůvěřují a hřích se šíří – od Kaina přes potopu až k Babylonské "
     "věži. Otázka zní: jak Bůh svět zachrání?",
     ["Gn"], [],
     [("Gn 1", "Stvoření"), ("Gn 3", "Pád"), ("Gn 6", "Potopa"),
      ("Gn 11", "Babylonská věž")]),
    ("patriarchs", "Praotcové", "asi 2000–1700 př. Kr.",
     "Bůh povolává Abrahama a slibuje mu zemi, potomstvo a požehnání pro "
     "všechny národy. Slib se předává Izákovi, Jákobovi a jeho dvanácti "
     "synům. Josef se dostane do Egypta a zachrání rodinu před hladem.",
     ["Gn"],
     [("Jób – příběh z podobně dávné doby", ["Jb"])],
     [("Gn 12", "Povolání Abrahama"), ("Gn 22", "Obětování Izáka"),
      ("Gn 28", "Jákobův žebřík"), ("Gn 45", "Josef se dává poznat")]),
    ("exodus", "Vyjití a putování pouští", "asi 15.–13. stol. př. Kr.",
     "Izraelité se v Egyptě stali otroky. Bůh je skrze Mojžíše vyvádí, "
     "na Sinaji s nimi uzavírá smlouvu a dává Zákon. Kvůli nedůvěře "
     "putují čtyřicet let pouští.",
     ["Ex", "Lv", "Nu", "Dt"], [],
     [("Ex 3", "Hořící keř"), ("Ex 14", "Přechod moře"),
      ("Ex 20", "Desatero"), ("Dt 6", "Slyš, Izraeli")]),
    ("land", "Země zaslíbená a soudci", "asi 13.–11. stol. př. Kr.",
     "Pod Jozuovým vedením vstupuje Izrael do země. Pak přichází doba "
     "soudců: lid opakovaně opouští Boha, upadá do útlaku a Bůh posílá "
     "zachránce. Uprostřed temné doby svítí příběh věrné Rút.",
     ["Joz", "Sd", "Rt"], [],
     [("Joz 1", "Buď rozhodný a statečný"), ("Joz 24", "Volba: komu "
      "sloužit"), ("Sd 2", "Kruh odpadnutí"), ("Rt 1", "Věrnost Rút")]),
    ("kingdom", "Sjednocené království", "asi 1050–930 př. Kr.",
     "Izrael chce krále. Po Saulovi přichází David, kterému Bůh slibuje "
     "věčný trůn. Jeho syn Šalomoun staví v Jeruzalémě chrám. Je to "
     "zlatý věk – ale už v něm klíčí rozpad.",
     ["1S", "2S", "1Kr", "1Pa", "2Pa"],
     [("Žalmy a moudrost – spojené s Davidem a Šalomounem",
       ["Ž", "Př", "Kaz", "Pís"])],
     [("1S 16", "Pomazání Davida"), ("1S 17", "David a Goliáš"),
      ("2S 7", "Slib věčného trůnu"), ("1Kr 8", "Posvěcení chrámu")]),
    ("divided", "Rozdělené království", "930–586 př. Kr.",
     "Po Šalomounovi se říše rozpadne na Izrael (sever) a Judu (jih). "
     "Většina králů vede lid k modlám. Bůh posílá proroky, kteří volají "
     "k návratu. Sever padne roku 722 př. Kr. pod Asýrii, Jeruzalém roku "
     "586 př. Kr. pod Babylon.",
     ["1Kr", "2Kr", "2Pa"],
     [("Proroci této doby", ["Iz", "Jr", "Oz", "Am", "Jon", "Mi", "Na",
                             "Abk", "Sf"]),
      ("Doba sepsání nejistá", ["Jl", "Abd"])],
     [("1Kr 12", "Rozdělení říše"), ("1Kr 18", "Eliáš na Karmelu"),
      ("2Kr 17", "Pád Samaří"), ("2Kr 25", "Pád Jeruzaléma")]),
    ("exile", "Babylonské zajetí", "586–538 př. Kr.",
     "Chrám leží v troskách, lid žije v cizině. Zdá se, že Boží sliby "
     "skončily. Proroci však v zajetí ohlašují naději: Bůh svůj lid "
     "neopustil a přivede ho zpět.",
     ["2Kr", "Da"],
     [("Nářek a naděje v zajetí", ["Pl", "Ez", "Da"])],
     [("Ž 137", "U řek babylonských"), ("Ez 37", "Údolí suchých kostí"),
      ("Da 6", "Daniel v jámě lvové"), ("Iz 40", "Potěšte můj lid")]),
    ("return", "Návrat a obnova", "538–asi 430 př. Kr.",
     "Perský král Kýros dovolí návrat. Lid obnovuje chrám a hradby "
     "Jeruzaléma a znovu čte Zákon. Ester zatím v Persii zachraňuje svůj "
     "národ. Proroci povzbuzují, ale velký Mesiáš ještě nepřišel.",
     ["Ezd", "Neh", "Est"],
     [("Proroci po návratu", ["Ag", "Za", "Mal"])],
     [("Ezd 3", "Základy chrámu"), ("Neh 8", "Čtení Zákona"),
      ("Est 4", "„Pro takovou chvíli“"), ("Mal 3", "Posel před Pánem")]),
    ("silence", "Mezi zákony", "asi 430–5 př. Kr.",
     "Asi čtyři sta let bez nových knih hebrejské Bible. Vládnou Peršané, "
     "Řekové a nakonec Římané. Vznikají synagogy, Písmo se překládá do "
     "řečtiny a lid čeká na zaslíbeného Mesiáše.",
     [], [], []),
    ("jesus", "Ježíš", "asi 5 př. Kr. – 30 po Kr.",
     "V Betlémě se narodí Ježíš. Káže o Božím království, uzdravuje, "
     "odpouští a povolává učedníky. Je ukřižován v Jeruzalémě a třetího "
     "dne vstává z mrtvých. V něm se setkávají nitě celého Starého "
     "zákona.",
     ["Mt", "Mk", "L", "J"], [],
     [("L 2", "Narození"), ("Mt 5", "Kázání na hoře"),
      ("J 3", "Rozhovor s Nikodémem"), ("J 19", "Kříž"),
      ("L 24", "Vzkříšení")]),
    ("church", "Církev", "asi 30–100 po Kr.",
     "O Letnicích sestupuje Duch svatý a z Jeruzaléma se zvěst šíří "
     "do celé římské říše. Pavel zakládá sbory a píše jim dopisy. "
     "Evangelium přestává být věcí jednoho národa.",
     ["Sk"],
     [("Pavlovy listy", ["Ř", "1K", "2K", "Ga", "Ef", "Fp", "Ko", "1Te",
                         "2Te", "1Tm", "2Tm", "Tt", "Fm"]),
      ("Další listy", ["Žd", "Jk", "1Pt", "2Pt", "1J", "2J", "3J", "Ju"])],
     [("Sk 2", "Letnice"), ("Sk 9", "Obrácení Pavla"),
      ("Sk 15", "Sněm v Jeruzalémě"), ("Sk 28", "Pavel v Římě")]),
    ("newcreation", "Nové stvoření", "naděje do budoucna",
     "Bible končí tam, kde začala – ale lépe: nové nebe a nová země, Bůh "
     "bydlí s lidmi, strom života a řeka vody života. Zlo, smrt a pláč "
     "skončí.",
     ["Zj"], [],
     [("Zj 1", "Vidění Krista"), ("Zj 5", "Beránek"),
      ("Zj 21", "Nové nebe a nová země"), ("Zj 22", "Strom života")]),
]
