#import "@local/ktu-paper:0.3.2": (
  ktu-paper, setup-code,
  ktu-table-of-contents, ktu-picture-list, ktu-table-list,
  ktu-heading-page-normal,
  ktu-table,
  unnumbered-heading,
  custom-ref, ref-no
)

#show: ktu-paper.with(
  font: "Times New Roman",
)
#show: setup-code.with()

#show figure: it => {
  set block(breakable: true)
  it
}
#set list(indent: 0.63cm, marker: [--])

#ktu-heading-page-normal(
    faculty: "Fakulteto pavadinimas",
    title: "Rašto darbo pavadinimas",
    subtitles: "Praktikos ataskaita / referatas ir pan. (įrašyti rašto darbo tipą)",
    authors: (
        ("Vardenis Pavardenis", "Projekto autorius"),
        ("Vardenis Pavardenis", "Vadovas"),
    ),
    place: "Kaunas",
    year: datetime.today().year(),
)
#pagebreak()

#ktu-table-of-contents()
#pagebreak()

#ktu-picture-list()
#pagebreak()

#ktu-table-list()
#pagebreak()


#unnumbered-heading[= Įvadas]

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

#pagebreak()

= Skyriaus pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam:
- Ut antiopam efficiendi deterruisset sit. 
- Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim.

An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

== Poskyrio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

#figure(
  table(
    columns: (40mm, 35mm, 44mm, auto),
    align: (x, y) => top + left,

    table.header(
    [*Stiliaus pavadinimas*], [*Stiliaus pavadinimas galerijoje*],
    [*Stiliaus formalieji reikalavimai*], [*Stiliaus naudojimo aprašymas*],
    ),

    [Antraštė non-TOC], [Antraštė non-TOC],
    [Šrifto dydis 12 pt, šriftas paryškintas, intervalas tarp eilučių -- 1,15, atstumas prieš ir po antraštės -- 10 pt, centruota lygiuotė.], [Antraštėms, kurios nėra įtraukiamos į turinį: „Turinys“.],

    [Antraštė be nr.], [Antraštė be nr.],
    [Šrifto dydis 12 pt, šriftas paryškintas, intervalas tarp eilučių -- 1,15, atstumas prieš ir po antraštės -- 10 pt, centruota lygiuotė, antraštė rašoma naujame puslapyje – po puslapio skirtuko.],
    [Antraštėms, kurios įtraukiamos į turinį, bet nėra numeruojamos: „Lentelių sąrašas“, „Paveikslų sąrašas“, „Santrumpų ir terminų sąrašas“, „Įvadas“, „Išvados“, „Literatūros sąrašas“, „Informacijos šaltinių sąrašas“, „Priedai“.],

    [\1. Heading 1,Skyrius], [Skyrius],
    [Šrifto dydis 12 pt, šriftas paryškintas, intervalas tarp eilučių -- 1,15, atstumas po antraštės -- 10 pt, abipusė lygiuotė, antraštė rašoma naujame puslapyje – po puslapio skirtuko.],
    [Skyrių antraštėms, kurios įtraukiamos į turinį ir yra numeruojamos.],

    [1.1. Heading 2,Poskyris], [Poskyris],
    table.cell(rowspan: 2)[Šrifto dydis 12 pt, šriftas paryškintas, intervalas tarp eilučių -- 1,15, atstumas prieš ir po antraštės -- 10 pt, abipusė lygiuotė, numeracija siejama su aukštesnio lygio antrašte.],
    [Poskyrių antraštėms, kurios įtraukiamos į turinį ir yra numeruojamos.],

    [1.1.1. Heading 4,Skyrelis], [Skyrelis],
    [Skyrelių antraštėms, kurios įtraukiamos į turinį ir yra numeruojamos.],

    [Tekstas], [Tekstas],
    [Šrifto dydis 12 pt, intervalas tarp eilučių -- 1,15, atstumas po pastraipos -- 10 pt, abipusė lygiuotė.],
    [Tekstui visose rašto darbo dalyse (įvade, skyriuose, poskyriuose ir t.t.).],

    [List Bullet;Sąrašas (suženklintas)], [Sąrašas (suženklintas)],
    [Pirmos pastraipos eilutės įtrauka – 0,63 cm, šrifto dydis 12 pt, intervalas tarp eilučių – 1,15, atstumas tarp tokio paties stiliaus pastraipų – 0 pt, atstumas po sąrašo – 10 pt, abipusė lygiuotė.],
    [Tekstui, kuris pateikiamas suženklintu sąrašu.],

    [List Number;Sąrašas (numeruotas)], [],
    [Šrifto dydis 12 pt, intervalas tarp eilučių – 1,15, atstumas tarp tokio paties stiliaus pastraipų – 0 pt, atstumas po sąrašo – 10 pt, abipusė lygiuotė.],
    [Tekstui, kuris pateikiamas sunumeruotu sąrašu.],

    [Footnote Text;Išnašos tekstas], [Išnašos tekstas],
    [Šrifto dydis 10 pt, intervalas tarp eilučių – 1,15, atstumas prieš ir po sąrašo – 0 pt, abipusė lygiuotė.],
    [Tekstui, kuris pateikiamas išnašose.],

    [Lentelės pavad.], [Lentelės pavad.],
    [Šrifto dydis 11 pt, intervalas tarp eilučių – 1,15, atstumas prieš pavadinimą – 10 pt, po pavadinimo – 3 pt, lygiuotė prie kairiojo krašto.],
    [Lentelių pavadinimams (numeris ir žodis lentelė rašomas paryškintu šriftu).],

    [Lentelės I eil.], [],
    [Šrifto dydis 10 pt, šriftas paryškintas, intervalas tarp eilučių – 1,15, atstumas prieš ir po pastraipos – 3 pt, lygiuotė prie kairiojo krašto.],
    [Tekstui lentelės antraštinei (pirmai) eilutei.],

    [Lentelė], [],
    [Šrifto dydis 10 pt, intervalas tarp eilučių – 1, atstumas prieš ir po pastraipos – 3 pt, lygiuotė prie kairiojo krašto.],
    [Tekstui lentelėje.],

    [Caption,Paveikslo pavad.], [],
    [Šrifto dydis 11 pt, intervalas tarp eilučių – 1,15, atstumas prieš ir po pavadinimo – 10 pt, centruota lygiuotė.],
    [Paveikslų pavadinimams (numeris ir santrumpa pav. rašoma paryškintu šriftu).],

    [Figure;Paveikslas], [],
    [Atstumas prieš ir po paveikslo – 10 pt, centruota lygiuotė.], [Paveikslui, iliustracijai .],

    [Bibliography,Bibliografija], [Bibliografija],
    [Šrifto dydis 12 pt, intervalas tarp eilučių – 1,15, atstumas tarp tokio paties stiliaus pastraipų – 2 pt,  abipusė lygiuotė.],
    [Literatūros ir Informacijos šaltinių sąrašuose nurodytiems šaltiniams.],

    [Priedas], [Priedas],
    [Šrifto dydis 12 pt, šriftas paryškintas, intervalas tarp eilučių – 1,15, atstumas prieš ir po antraštės – 10 pt, lygiuotė prie kairiojo krašto.],
    [Priedo numeriui, žodžiui _priedas_, priedo pavadinimui.],

    [TOC 1,Turinys 1], [Turinys 1],
    [Šrifto dydis 12 pt, šriftas paryškintas, intervalas tarp eilučių – 1,15, įtrauka – 0,64.],
    [Turinyje esančioms antraštėms, kurios nėra numeruojamos („Lentelių sąrašas“, „Paveikslų sąrašas“, „Santrumpų ir terminų sąrašas“, „Įvadas“, „Išvados“, „Literatūros sąrašas“, „Informacijos šaltinių sąrašas“, „Priedai“) ir numeruojamai antraštei „Skyriaus pavadinimas“.],

    [TOC 2,Turinys 2], [Turinys 2],
    [Šrifto dydis 12 pt, intervalas tarp eilučių – 1,15, įtrauka – 0,96.],
    [Turinyje esančiai antraštei „Poskyrio pavadinimas“.],

    [TOC 3,Turinys 3], [Turinys 3],
    [Šrifto dydis 12 pt, intervalas tarp eilučių – 1,15, įtrauka – 1,28.],
    [Turinyje esančiai antraštei „Skyrelio pavadinimas“. ],

    [TOC 4,Turinys 4], [Turinys 4],
    [Šrifto dydis 12 pt, intervalas tarp eilučių – 1,15, įtrauka – 0,64.],
    [Numeruotiems priedams.],
  ),
  caption: [
    Pagrindiniai rašto darbo stiliai ir jų aprašymai
  ],
) <tab-1>

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has1.

=== Skyrelio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te:

1. Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum.
2. Sed dolorem quaerendum ne, prompta instructior ne pri.
3. Et mel partiendo suscipiantur, docendi abhorreant ea sit.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea2. In sumo inani numquam has.

===  Skyrelio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

== Poskyrio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

#pagebreak()

= Skyriaus pavadinimas
Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

== Poskyrio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

#figure(
  image("images/santaka.png", width: 11.2cm, height: 8cm),
  caption: [
    Kauno technologijos universiteto „Santakos“ slėnio fasadas
  ],
) <image-1>

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

== Poskyrio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te:
1. Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. 
2. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. 
3. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

=== Skyrelio pavadinimas
Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

- Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. 
- Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. 

An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

===  Skyrelio pavadinimas

Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

#pagebreak()

=  Skyriaus pavadinimas
Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.
== Poskyrio pavadinimas
Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.
== Poskyrio pavadinimas
Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.

Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

#pagebreak()

#unnumbered-heading[= Išvados]
1. Lorem ipsum dolor sit amet, eam ex decore persequeris, sit at illud lobortis atomorum. Sed dolorem quaerendum ne, prompta instructior ne pri. Et mel partiendo suscipiantur, docendi abhorreant ea sit. Recteque imperdiet eum te.
2. Eu eum decore inimicus consetetur, cu usu habeo corpora intellegam. Ut antiopam efficiendi deterruisset sit. Mel sint eirmod id, qui quot virtute id, dolor nemore forensibus usu id. Fugit dolore voluptatum cu vim. An vix veniam graecis insolens, sit posse iusto id. Ut vim ceteros percipit, id quo ubique recusabo, eum sint lucilius ea. In sumo inani numquam has.

#pagebreak()

#unnumbered-heading[= Literatūros sąrašas]
1. Literatūros šaltinis 
2. Literatūros šaltinis
3. Literatūros šaltinis
4. Literatūros šaltinis