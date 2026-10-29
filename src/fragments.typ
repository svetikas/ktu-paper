#import "config.typ": __DEBUG_AUTHOR_TABLE

/// Wrapper around the table function that returns a KTU style conformant table.
/// This includes setting text size to 10 pt.
#let ktu-table(..args) = {
  show table: it => {
    set text(size: 10pt)
    // TODO: FIXME line spacing is defined differently
    set par(leading: 1em - 0.75em) // intervalas tarp eilučių -- 1
    it
  }
  table(
    ..args
  )
}

#let ktu-author-table(
  authors: (),
  alignment: right,
  namesFirst: true, // if false, roles will be displayed first
) = context {
  // The layout should be a list of lists whose elements are (name, role) pairs.
  assert(authors.len() > 0, message: "author table must have at least one author")
  assert(authors.all(it => it.len() == 2), message: "each author entry must be a pair of name and role")

  let frame(color) = (x, y) => (
    left: 0pt,
    right: 0pt,
    top: if y == 0 { 0.5pt + color } else { 0pt },
    bottom: 0.5pt + color,
  )
  set table(
    inset: 5.4pt,
    stroke: if __DEBUG_AUTHOR_TABLE.get() {
      0.5pt + rgb("D4AF37")
    } else {
      frame(rgb("D4AF37"))
    },
  )
  show table.cell: it => context {
    [#it]
    if it.body == [] {
      v(10pt)
    } else {
      v(0pt)
    }
  }

  if alignment == center {
    align(center, table(
      columns: (198.5pt + 56.7pt),
      table.header([]),
      ..for author in authors {
        let (name, role) = author
        name = [*#name*]
        if not namesFirst {
          (role, name) = (name, role)
        }
        (
          align(center)[
            #set block(below: 8pt)
            #block[#name]
            #block[#role]

          ],
          [],
        )
      }
    ))
  } else {
    align(alignment, table(
      columns: (198.5pt, 56.7pt),
      table.header([], []),
      ..for author in authors {
        let (name, role) = author
        name = [*#name*]
        if not namesFirst {
          (role, name) = (name, role)
        }
        (
          align(left)[
            #set block(below: 8pt)
            #block[#name]
            #block[#role]

          ],
          [],
          [],
          [],
        )
      },
    ))
  }
}

/// This function constructs the title page header block for KTU reports. It includes the university logo, name, subheaders, the main and sub titles of the report.
///
/// - bigTitle (content): The main title of the report, usually the name of the work. Displayed in 18 pt font.
/// - subTitles (): Additional titles or information to be displayed under the main title, such as the type of work. Displayed in 14 pt font. If not provided, defaults to "Rašto darbo tipas".
/// - subHeaders (): Additional header information to be displayed under the university name, such as the faculty. If not provided, defaults to "Fakulteto pavadinimas".
/// ->
#let ktu-title-header-block(
  bigTitle: highlight[Didelis pavadinimas],
  subTitles: (),
  subHeaders: (),
) = {
  let parsedSubtext = if subHeaders.len() > 0 {
    subHeaders
  } else {
    (
      highlight[Fakulteto pavadinimas],
    )
  }

  let subTitles = if subTitles.len() > 0 {
    subTitles
  } else {
    (
      highlight[Rašto darbo tipas],
    )
  }

  // Top of the title page
  v(20pt)
  align(center)[
    #image("assets/ktu-logo.png", width: 2.46cm, height: 2.69cm)
    #v(25pt)
    #block[*Kauno technologijos universitetas*]
    #for value in parsedSubtext {
      block[#value]
    }
  ]

  // The title page information
  v(91pt)
  align(center)[
    #set par(justify: false)
    #set linebreak(justify: false)
    #block(text(size: 18pt, hyphenate: false)[*#bigTitle*])
    #for value in subTitles {
      block(text(size: 14pt)[#value])
    }
  ]
}

#let ktu-heading-page(
  faculty: highlight[Fakulteto pavadinimas],
  department: none, // optional
  title: highlight[Rašto darbo pavadinimas],
  subtitles: highlight[Praktikos ataskaita / referatas ir pan. (įrašyti rašto darbo tipą)],
  authors: (
    (highlight[Vardenis Pavardenis], highlight[Projekto autorius]),
    (highlight[Vardenis Pavardenis], highlight[Vadovas]),
  ),
  place: highlight[Kaunas],
  year: highlight[#datetime.today().year()],
  centerAuthors: false,
  authorNamesFirst: true, // if false, roles will be displayed first
) = {
  let subHeaders = (faculty,)
  if department != none {
    subHeaders = (faculty, department)
  }
  if type(subtitles) != array {
    subtitles = (subtitles,)
  }
  ktu-title-header-block(
    subHeaders: subHeaders,
    bigTitle: title,
    subTitles: subtitles,
  )
  v(94pt)
  if centerAuthors {
    ktu-author-table(authors: authors, namesFirst: authorNamesFirst, alignment: center)
  } else {
    ktu-author-table(authors: authors, namesFirst: authorNamesFirst)
  }
  align(center + bottom, block([*#place, #year*]))
}

#let ktu-heading-page-centered(
  faculty: highlight[Fakulteto pavadinimas],
  department: none, // optional
  title: highlight[Rašto darbo pavadinimas],
  subtitles: highlight[Praktikos ataskaita / referatas ir pan. (įrašyti rašto darbo tipą)],
  authors: (
    (highlight[Vardenis Pavardenis], highlight[Projekto autorius]),
    (highlight[Vardenis Pavardenis], highlight[Vadovas]),
  ),
  authorNamesFirst: true, // if false, roles will be displayed first
  place: highlight[Kaunas],
  year: highlight[#datetime.today().year()],
) = {
  ktu-heading-page(
    faculty: faculty,
    department: department,
    title: title,
    subtitles: subtitles,
    authors: authors,
    place: place,
    year: year,
    centerAuthors: true,
    authorNamesFirst: authorNamesFirst,
  )
}

#let ktu-heading-page-normal(
  faculty: highlight[Fakulteto pavadinimas],
  department: none, // optional
  title: highlight[Rašto darbo pavadinimas],
  subtitles: highlight[Praktikos ataskaita / referatas ir pan. (įrašyti rašto darbo tipą)],
  authors: (
    (highlight[Vardenis Pavardenis], highlight[Projekto autorius]),
    (highlight[Vardenis Pavardenis], highlight[Vadovas]),
  ),
  authorNamesFirst: true, // if false, roles will be displayed first
  place: highlight[Kaunas],
  year: highlight[#datetime.today().year()],
) = {
  ktu-heading-page(
    faculty: faculty,
    department: department,
    title: title,
    subtitles: subtitles,
    authors: authors,
    place: place,
    year: year,
    centerAuthors: false,
    authorNamesFirst: authorNamesFirst,
  )
}

#let ktu-academic-honestly-declaration-page(
  faculty: highlight[Informatikos fakultetas],
  author: highlight[Vardenis Pavardenis],
  projectTitle: highlight[Projekto pavadinimas],
) = {
  ktu-title-header-block(
    subHeaders: (faculty, author),
    bigTitle: projectTitle,
    subTitles: ("Akademinio sąžiningumo deklaracija",),
  )
  v(20pt)
  [
    Patvirtinu, kad:
    + baigiamąjį projektą parengiau savarankiškai ir sąžiningai, nepažeisdama(s) kitų asmenų autoriaus ar kitų teisių, laikydamasi(s) Lietuvos Respublikos autorių teisių ir gretutinių teisių įstatymo nuostatų, Kauno technologijos universiteto (toliau -- Universitetas) intelektinės nuosavybės valdymo ir perdavimo nuostatų bei Universiteto akademinės etikos kodekse nustatytų etikos reikalavimų;
    + baigiamajame projekte visi pateikti duomenys ir tyrimų rezultatai yra teisingi ir gauti teisėtai, nei viena šio projekto dalis nėra plagijuota nuo jokių spausdintinių ar elektroninių šaltinių, visos baigiamojo projekto tekste pateiktos citatos ir nuorodos yra nurodytos literatūros sąraše;
    + įstatymų nenumatytų piniginių sumų už baigiamąjį projektą ar jo dalis niekam nesu mokėjęs (-usi);
    + suprantu, kad išaiškėjus nesąžiningumo ar kitų asmenų teisių pažeidimo faktui, man bus taikomos akademinės nuobaudos pagal Universitete galiojančią tvarką ir būsiu pašalinta(s) iš Universiteto, o baigiamasis projektas gali būti pateiktas Akademinės etikos ir procedūrų kontrolieriaus tarnybai nagrinėjant galimą akademinės etikos pažeidimą.

    #v(10pt)
    #h(58%) #author

    #h(58%) _Patvirtinta elektroniniu būdu_
  ]
}

#let ktu-gen-ai-usage-declaration-page(
  author: highlight[Vardenis Pavardenis],
  faculty: highlight[Informatikos fakultetas],
  module: highlight[Studijų modulio pavadinimas (kodas)],
  title: highlight[Studijų darbo pavadinimas],
  type: highlight[Studijų darbo rūšis],
  usageInformation: (
    (highlight[...], highlight[...], highlight[...], highlight[...]),
  ),
  showPhysicalSignature: false,
) = {
  set text(size: 12pt)

  align(center)[
    #block([*GENERATYVINIO DIRBTINIO INTELEKTO (GenDI) NAUDOJIMO DEKLARACIJA*])
    #block[\_\_\_ \_\_\_ \_\_\_]
  ]

  [*1. Studento duomenys*]
  table(
    columns: (155pt, 1fr),
    align: (x, y) => { horizon + left },
    [*Studento vardas, pavardė*], [#author],
    [*Studento fakultetas*], [#faculty],
    [*Studijų modulis*], [#module],
    [*Studijų darbo pavadinimas*], [#title],
    [*Studijų darbo rūšis*], [#type],
  )

  [
    #set linebreak(justify: false)
    *2. GenDI naudojimo patvirtinimas*\
    _Pažymėkite vieną variantą:_
  ]
  let usedAi = usageInformation != none and usageInformation.len() > 0
  let checkbox(checked: false) = {
    box(
      width: 0.8em,
      height: 0.8em,
      stroke: 0.08em + black,
      radius: 0.15em,
      if checked {
        let size = 0.4em
        let margin = 0.2em
        // Top-left to bottom-right line
        place(top + left, dx: margin, dy: margin, line(end: (size, size), stroke: 0.08em + black))
        // Bottom-left to top-right line
        place(top + left, dx: margin, dy: margin + size, line(end: (size, -size), stroke: 0.08em + black))
      } else {
        none
      },
    )
  }
  table(
    columns: (28pt, 1fr),
    align: (x, y) => { horizon + left },
    table.cell(rowspan: 2)[#align(top, checkbox(checked: not usedAi))],
    [*Rengdamas (-a) šį studijų darbą nenaudojau generatyvinio dirbtinio intelekto įrankių*],
    [Patvirtinu, kad studijų darbe pateiktas turinys yra mano autentiškas intelektinis darbas, o naudoti šaltiniai nurodyti pagal citavimo reikalavimus.],

    table.cell(rowspan: 2)[#align(top, checkbox(checked: usedAi))],
    [*Rengdamas (-a) šį studijų darbą naudojau generatyvinio dirbtinio intelekto įrankius*],
    [Patvirtinu, kad GenDI įrankiai buvo naudojami laikantis studijų modulyje nustatytų GenDI naudojimo reikalavimų bei naudojimas yra skaidriai ir sąžiningai deklaruotas.],
  )

  [
    #set linebreak(justify: false)
    *3.	GenDI naudojimo informacija*\
    _Užpildykite, jei rengiant studijų darbą naudojote generatyvinio dirbtinio intelekto įrankius:_
  ]
  let rows = if usedAi {
    usageInformation.flatten()
  } else {
    // hide[x] gives each empty cell the height of one regular line of text
    range(3).map(_ => range(4).map(_ => hide[x])).flatten()
  }
  set par(justify: false)
  table(
    columns: (91pt, 127pt, 139pt, 1fr),
    align: (x, y) => { top + left },
    table.header(
      [
        #set linebreak(justify: false)
        *Darbo dalis*\
        _(pvz., skyrius, visas darbas)_
      ],
      [*GenDI įrankio naudojimo tikslas*],
      [*GenDI įrankio pavadinimas, versija / internetinė nuoroda*],
      [
        #set linebreak(justify: false)
        *Studento indėlis* \
        _(kaip GenDI rezultatas buvo patikrintas, redaguotas ar papildytas studento)_
      ],
    ),
    ..rows,
  )

  let field(size: 12pt, body) = {
    set text(size: size)
    align(center, body)
  }
  let underlined-field(min-width: 92pt, body) = context {
    let w = calc.max(min-width, measure(body).width)
    align(center, box(
      width: w,
      height: 1.4em,
      stroke: (bottom: 0.5pt + black),
      inset: (bottom: 2pt),
      align(center + bottom, body),
    ))
  }
  let maybe(show-it, body) = if show-it { body } else { hide(body) }
  align(bottom, table(
    stroke: 0pt,
    inset: 2pt,
    columns: (120pt, 177pt, 1fr),
    align: (x, y) => { horizon + left },
    [Studentas], [#maybe(showPhysicalSignature, [#underlined-field[]])], [#underlined-field(min-width: 126pt)[#author]],
    [], [#maybe(showPhysicalSignature, [#field(size: 10pt)[_(parašas)_]])], [#field(size: 10pt)[(_vardas, pavardė_)]],
  ))
}
