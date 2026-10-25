#import "@preview/codly:1.3.0": codly, codly-init
#import "config.typ": debug-author-table, enable-heading-experiment, __HEADING_EXPERIMENT, __FIG_PER_SECTION, __UPPERCASE_SECTION_TITLES
#import "fragments.typ": (
  ktu-table,

  // building blocks
  ktu-author-table, ktu-title-header-block,
  
  ktu-heading-page, ktu-heading-page-centered, ktu-heading-page-normal,
  ktu-academic-honestly-declaration-page
)
#import "figures.typ": (
  ref-no, custom-ref,

  __caption-label,
  __reset-figure-counters,
  __equation-numbering,
  __normalize-figure-kinds,
  __USER_FIGURE_KINDS,

  __format-ref,
  __format-figure,
  __figure-kinds,

  __is-appendix-heading,
  __appendix-title,
  __appendix-number,
)

/**
 * Paruošta pagal "Rašto ..."
 */

/*
 * Further reading required:
 * - Double line spacing | https://github.com/typst/typst/issues/106
 * - Proposal: change `leading` option to `line-height` | https://github.com/typst/typst/issues/4224
 */

#let __METADATA_HEADING_ALIGN_LEFT = metadata("heading-align-left");

///
/// Insert a heading without a number.
///
/// Usually used for introductory or summary sections at the start and end.
/// - headingElement (heading): The heading's title.
/// - alignLeft (bool): Whether the heading should be left-aligned or centered.
/// ->
#let unnumbered-heading(headingElement, alignLeft: false) = {
  let fields = headingElement.fields()
  let body = fields.body
  let level = fields.at("level", default: 1)

  if alignLeft {
    body = body + __METADATA_HEADING_ALIGN_LEFT
  }

  heading(level: level, numbering: none, body)
}

/// Insert an appendix (priedas).
///
/// Appendices are numbered 1, 2, 3, ... in the order they appear in the
/// document, so place them in the order they are first mentioned in the text.
/// Each appendix should start on a new page: put a `#pagebreak()` before it.
/// "N priedas" is written in the top right
/// corner. The optional title is written below it like a chapter title (bold),
/// exactly as given: start it with a capital letter, the rest in lowercase.
/// Appendices are included in the table of contents.
///
/// Give it a label to refer to it from the text: `#appendix-item[Pavadinimas] <pr-konfig>`
/// and then `@pr-konfig` or `#custom-ref(<pr-konfig>)` gives "(žr. 1 priedą)".
/// - title (content | none): Optional appendix title.
/// -> heading
#let appendix-item(..title) = {
  assert(
    title.named().len() == 0 and title.pos().len() <= 1,
    message: "appendix-item takes at most one argument: the appendix title",
  )
  let title = title.pos().at(0, default: none)
  heading(
    if title == none { metadata("appendix-heading") } else { metadata("appendix-heading") + title },
    level: 2,
    numbering: none,
  )
}

// Utility function to round numbers with padded zeros
#let round-and-pad(number, decimals) = {
  let rounded = calc.round(number, digits: decimals)
  let s = str(rounded)
  let parts = s.split(".")
  let integer-part = parts.at(0)
  let decimal-part = if parts.len() == 2 { parts.at(1) } else { "" }

  let padded-decimal = if decimals > 0 {
    let current-decimal-length = decimal-part.len()
    let padding-needed = decimals - current-decimal-length
    let trailing-zeros = ""
    for _ in range(padding-needed) {
      trailing-zeros = trailing-zeros + "0"
    }
    if decimal-part == "" {
      "." + trailing-zeros
    } else {
      "." + decimal-part + trailing-zeros
    }.slice(0, decimals + 1)
  } else {
    ""
  }
  integer-part + padded-decimal
}


/// Returns a KTU template-conformant outline.
/// - depth (int | none): Same as outline depth.
/// - indent (auto | function | relative): Same as outline indent.
/// - target (function | label | location | selector): Same as outline target.
/// - title (auto | content | none): Same as outline title.
/// -> outline
#let __ktu_outline(
  depth: none,
  indent: 0em, // Disable the default outline indenting
  target: heading,
  title: auto,
) = {
  // TODO: įtrauka
  set block(spacing: 0em)
  // genius solution by @two_horus on Discord (364397430059302912)
  show outline: o => context {
    // If it's a heading, show the default outline with bold text
    if (o.target == selector(heading)) {
      // Determine whether to uppercase section titles based on the global setting
      let isUpper = __UPPERCASE_SECTION_TITLES.get()

      // Define known target widths based on KTU template
      let targets = (0.64cm, 0.96cm, 1.28cm, 1.6cm, 1.92cm)

      // Apply custom outline entry formatting
      show outline.entry: it => {
        // Recompute the gap based on the prefix content, so that the outline entry is indented
        // from the left regardless of the length of the prefix (based on the requirement)
        let isAppendix = __is-appendix-heading(it.element)

        // Appendices are listed as "N priedas. Pavadinimas", the number being the prefix
        let prefixContent = if isAppendix {
          context [#__appendix-number(it.element)]
        } else {
          it.prefix()
        }
        let measurement = measure(prefixContent)
        let target = if isAppendix { 0.64cm } else { targets.at(it.level - 1, default: 0.64cm) }
        let newGap = target - measurement.width

        // Uppercase body if need be
        let bodyContent = it.element.body
        if isAppendix {
          let title = __appendix-title(it.element)
          let name = __figure-kinds.appendix.supplement
          bodyContent = if title == none { [#name] } else { [#name. #title] }
        } else if isUpper and (it.level == 1 or it.element.numbering == none) {
          bodyContent = upper(bodyContent)
        }

        // Reconstruct the it.inner content with the new body
        let formattedInner = {
          bodyContent
          [ ] // whitespace is required for backwards compat
          box(width: 1fr, it.fill)
          [ ] // whitespace is required for backwards compat
          it.page()
        }

        link(
          it.element.location(),
          it.indented(prefixContent, formattedInner, gap: newGap),
        )
      }

      show outline.entry.where(level: 1): e => {
        strong(e)
      }
      o

    // If it's an image
    } else if (o.target == figure.where(kind: image)) {
      show outline.entry: it => link(
        it.element.location(),
        it.indented(
          [*#__caption-label(it.element)*],
          [ #it.inner()], gap: 0pt
        ),
      )
      o

    // If it is a table, show table formatting
    } else if (o.target == figure.where(kind: table)) {
      show outline.entry: it => link(
        it.element.location(),
        it.indented(
          [*#__caption-label(it.element)*],
          [ #it.inner()], gap: 0pt
        ),
      )
      o

    // If it is a table, show table formatting
    } else if (o.target == figure.where(kind: raw)) {
      show outline.entry: it => link(
        it.element.location(),
        it.indented(
          [*#__caption-label(it.element)*],
          [ #it.inner()], gap: 0pt
        ),
      )
      o

    // Otherwise, try to determine what kind of outline it is
    } else {

      /*[
        #o.target #type(o.target),
        #(o.target == "heading")
        #(o.target == heading)
        #(o.target == figure.where(kind: heading))
        #(o.target == heading.where())
        #(o.target == selector(heading))
      ]*/

      // Any other figure kind (generally, user defined kinds)
      show outline.entry: it => link(
        it.element.location(),
        it.indented(
          [*#__caption-label(it.element)*],
          [ #it.inner()], gap: 0pt
        ),
      )
      o
    }
  }
  outline(depth: depth, indent: indent, target: target, title: title)
}

// Doesn't work in Typst 0.12.0 due to relative paths
#let bibliography-list(path) = {
  bibliography(path, title: "Literatūros sąrašas", full: true)
}

/// Returns a KTU style conformant outline.
/// - depth (int | none): Same as outline depth.
/// - indent (auto | function | relative): Same as outline indent.
/// - target (function | label | location | selector): Same as outline target.
/// - title (auto | content | none): Same as outline title.
/// -> outline
#let ktu-outline(
  depth: none,
  indent: 0em, // Disable the default outline indenting
  target: heading,
  title: auto,
) = {
  __ktu_outline(depth: depth, indent: indent, target: target, title: title)
}

#let ktu-table-of-contents(depth: 3) = {
  ktu-outline(target: heading, title: "Turinys", depth: depth)
}

#let ktu-table-list() = {
  ktu-outline(title: heading("Lentelių sąrašas", outlined: true), target: figure.where(kind: table))
}

#let ktu-picture-list() = {
  ktu-outline(title: heading("Paveikslų sąrašas", outlined: true), target: figure.where(kind: image))
}

#let ktu-code-list() = {
  ktu-outline(title: heading("Kodo fragmentų sąrašas", outlined: true), target: figure.where(kind: raw))
}

/// Define a custom outline for a specific figure type.
/// This function creates an outline entry with a specified title and figure type.
/// The outline entry will link to the figure of the specified type.
/// - title (str): Title of the outline
/// - kind (str): Type of the figure
#let custom-list(title, kind) = {
  __ktu_outline(title: heading(title, outlined: true), target: figure.where(kind: kind))
}

#let setup-code(body) = {
  show: codly-init.with()
  codly(
    fill: white,
    zebra-fill: none,
    stroke: none,
    display-name: false,
    display-icon: false,
  )
  show raw: set text(font: "Hack", spacing: 80%)
  body
}

#let __page_rules(font: "Times New Roman", body) = {
  // Page size and margins
  set page(
    paper: "a4",
    width: 210mm,
    height: 297mm,
    margin: (
      left: 30mm,
      right: 10mm,
      bottom: 20mm,
      top: 20mm,
    ),
  )
  set page(width: 595pt, height: 842pt)

  // Numbering rules
  set page(numbering: none, number-align: right)

  // Use Lithuanian quotes
  set smartquote(quotes: "„“")

  // Heading numbering
  set heading(numbering: "1.")

  // Number equations
  set math.equation(numbering: __equation-numbering)

  // Set text font
  set text(
    font: font,
    size: 12pt,
    lang: "lt",
    // Change where the bounding box is drawn for the text
    top-edge: "ascender",
    bottom-edge: "descender",
    kerning: false, // Disable kerning
  )

  // Text line interval, defined differently in Typst
  let leading = 1.15em // Your line spacing (1, 1.5, 2, etc.)
  let leading = leading - 0.75em // "Normalization"
  set par(leading: leading)

  // Indentation for lists and enumerations
  set enum(indent: 12pt)
  set list(indent: 12pt)

  body
}

#let setup-page(
  font: "Times New Roman",
  uppercaseSectionTitles: false,
  unnumberedHeadingAlignment: center,
  body,
) = {
  show: __page_rules.with(font: font)

  // Pagal formaliuosius rašto darbų reikalavimus

  // Tarpas tarp teksto pastraipų
  set par(spacing: 10pt)
  set block(below: 10pt)

  // Teksto lygiuotė, abipusė
  set par(justify: true)
  set linebreak(justify: true)

  let maybe-uppercase(body) = {
    if uppercaseSectionTitles {
      upper(body)
    } else {
      body
    }
  }

  // Antraštės
  // Force them into blocks so they don't count as paragraphs
  show heading: it => {
    // Align everything left
    set align(left)

    // Visų antraščių teksto dydis vienodas
    // Visų antraščių teksto šifras paryškintas
    set text(size: 12pt)
    set block(below: 10pt)

    let useExperiment = __HEADING_EXPERIMENT.get()

    // TODO: intervalas tarp eilučių – 1,15 kiekvienai antraštei

    // Priedas: kiekvienas pradedamas naujame lape, dešiniajame viršutiniame
    // kampe rašoma "N priedas", pavadinimas (jei yra) – kaip skyriaus pavadinimas
    if __is-appendix-heading(it) {
      align(right, block(below: 10pt, text(weight: "regular")[
        #__appendix-number(it) #__figure-kinds.appendix.supplement
      ]))
      let title = __appendix-title(it)
      if title != none {
        block(below: 10pt, title)
      }
      return
    }

    // Antraštė be nr.
    if it.numbering == none {
      // Centruota lygiuotė by default, but can be overridden by the user
      let explicitlyAlignLeft = (
        it.body.has("children")
          and it.body.children.len() > 1
          and it.body.children.at(1) == __METADATA_HEADING_ALIGN_LEFT
      )

      // If the user explicitly set alignLeft to true, we should align left regardless of the global setting
      let targetAlign = if explicitlyAlignLeft { left } else { unnumberedHeadingAlignment }

      set align(targetAlign)

      // atstumas prieš ir po antraštės - 10 pt
      block[#maybe-uppercase(it.body)]
      if useExperiment {
        v(10pt)
      }
    }

    // Skyrius
    if it.numbering != none and it.level == 1 {
      // abipusė lygiuotė
      set par(justify: true)

      // Reset figure counters if numbering per section is enabled
      if __FIG_PER_SECTION.get() {
        __reset-figure-counters()
      }

      // po antraštės - 10 pt
      block[#counter(heading).display() #maybe-uppercase(it.body)]
      if useExperiment {
        v(10pt)
      }
    }

    // Poskyris ir skyrelis
    if it.numbering != none and it.level != 1 {
      // abipusė lygiuotė
      set par(justify: true)

      // prieš ir po antraštės - 10 pt
      if useExperiment {
        v(10pt)
      }
      block[#counter(heading).display() #it.body]
      if useExperiment {
        v(10pt)
      }
    }
  }

  // Reference style and numbering
  show ref: it => __format-ref(it)

  // Figure captions and numbering
  show figure: it => __format-figure(it)

  // Bibliography citing style
  set bibliography(style: "assets/iso690-numeric-lt.csl")

  // Block equations are left-aligned
  show math.equation.where(block: true): it => {
    align(left, it)
  }

  body
}

/// Configure the template for a KTU paper.
/// - font (str): Text font to use for the paper.
/// - figureNumberingPerSection (bool): Whether to number figures per section rather than globally.
/// - uppercaseSectionTitles (bool): Whether to uppercase section titles.
/// - unnumberedHeadingAlignment (alignment): Alignment for unnumbered headings.
/// - figureKinds (dictionary): Extra figure kinds, e.g.
///   `(command: (supplement: "komanda", ref-name: "komanda", single-name: "komanda"))`.
///   Use them with `figure(kind: "command", ...)`. Keys:
///   - `supplement` (required): text after the number in captions, e.g. "1 komanda.".
///   - `ref-name`: text used in references, e.g. "(žr. 1 komanda)". Defaults to `supplement`.
///     Can also be a function `count => string`, called with the number of elements
///     referenced together, for kinds whose wording depends on it, e.g.
///     `count => if count == 1 { "komandą" } else { "komandas" }`.
///   - `single-name`: full word used when the figure is the only one of its kind
///     and is left unnumbered, e.g. "Komanda." and "(žr. komanda)". Defaults to `supplement`.
///     Currently only tables and images are left unnumbered when single, so this only matters for kinds added there.
#let ktu-paper(
  font: "Times New Roman",
  figureNumberingPerSection: false,
  figureKinds: (:),
  // Not sure about formal conformity of deviating
  // from the defaults of the next options,
  // but some modules may require them
  uppercaseSectionTitles: false,
  unnumberedHeadingAlignment: center,
  body,
) = context {
  show: setup-page.with(
    font: font,
    uppercaseSectionTitles: uppercaseSectionTitles,
    unnumberedHeadingAlignment: unnumberedHeadingAlignment,
  )
  __FIG_PER_SECTION.update(figureNumberingPerSection)
  __USER_FIGURE_KINDS.update(__normalize-figure-kinds(figureKinds))
  __UPPERCASE_SECTION_TITLES.update(uppercaseSectionTitles)
  body
}
