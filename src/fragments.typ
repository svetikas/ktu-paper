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
                (align(center)[
                    #set block(below: 8pt)
                    #block[#name]
                    #block[#role]
                    
                ], [])
            }
        ))
    } else {
        align(alignment, table(
            columns: (198.5pt, 56.7pt),
            table.header(
                [], [],
            ),
            ..for author in authors {
                let (name, role) = author
                name = [*#name*]
                if not namesFirst {
                    (role, name) = (name, role)
                }
                (align(left)[
                    #set block(below: 8pt)
                    #block[#name]
                    #block[#role]
                    
                ], [], [], [])
            }
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
    align(center+bottom, block([*#place, #year*]))
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
        subTitles: ("Akademinio sąžiningumo deklaracija",) 
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
