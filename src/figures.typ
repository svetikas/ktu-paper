// This file includes logic for displaying figures in the document, including numbering, captions, and references. It also includes logic for handling figure numbering per section or globally, based on the configuration set in `config.typ`.
#import "config.typ": __FIG_PER_SECTION

// ---------------------------------------------------------------------------
// Figure kinds
// ---------------------------------------------------------------------------

/// Localizations for the recognized referenceable figure kinds, keyed by `repr(func)`.
/// - supplement: used in captions (the caption adds the separator, e.g. "1 pav.").
/// - ref-name: used in references, e.g. "(žr. 1 pav.)".
#let __figure-kinds = (
  table: (supplement: "lentelė", ref-name: "lentelė"),
  image: (supplement: "pav", ref-name: "pav."),
  raw: (supplement: "kodo frag", ref-name: "kodo frag."),
  equation: (supplement: "lygtis", ref-name: "formulė"),
)

/// Figure kinds registered by the document author via `ktu-paper(figureKinds: ...)`.
#let __USER_FIGURE_KINDS = state("ktu-user-figure-kinds", (:))

/// Validates author-supplied kinds and fills in defaults (`ref-name` falls back
/// to `supplement`).
#let __normalize-figure-kinds(kinds) = {
  let normalized = (:)
  for (key, spec) in kinds {
    assert(
      "supplement" in spec,
      message: "figure kind `" + key + "` needs a `supplement`",
    )
    normalized.insert(key, (
      supplement: spec.supplement,
      ref-name: spec.at("ref-name", default: spec.supplement),
    ))
  }
  normalized
}

/// Recognized kinds merged with the author's. Must be called in a context.
#let __all-figure-kinds() = __figure-kinds + __USER_FIGURE_KINDS.get()

/// Resets all figure and equation counters (used when numbering per section).
/// Must be called in a context.
#let __reset-figure-counters() = {
  let custom = (..__USER_FIGURE_KINDS.get().keys(),)
  for kind in (image, table, raw, ..custom) {
    counter(figure.where(kind: kind)).update(0)
  }
  counter(math.equation).update(0)
}

/// Returns the caption supplement text for a figure kind (e.g. `table`, `math.equation`).
#let __fig-supplement(func) = __figure-kinds.at(repr(func)).supplement

/// Finds the first recognized kind ("table", "image", "raw" or "equation") inside
/// `node`, descending through wrappers (align, block, grid, stack, ...).
/// Returns the key into `__figure-kinds`, or `none` if nothing is recognized.
#let __find-figure-kind(node) = {
  if type(node) != content { return none }

  let key = repr(node.func())
  if key in __figure-kinds { return key }

  // Single-child wrappers
  for field in ("body", "child") {
    if node.has(field) {
      let found = __find-figure-kind(node.at(field))
      if found != none { return found }
    }
  }

  // Multi-child containers
  if node.has("children") {
    for child in node.children {
      let found = __find-figure-kind(child)
      if found != none { return found }
    }
  }

  none
}

/// Resolves the `__figure-kinds` key of a figure element. An explicit custom
/// (string) kind always wins; otherwise the kind is detected from the body.
#let __figure-key(fig) = {
  if type(fig.kind) == str { return fig.kind }
  let found = __find-figure-kind(fig.body)
  if found != none { found } else { repr(fig.kind) }
}

/// Returns the caption supplement of a figure element.
#let __figure-supplement-of(fig) = {
  let key = __figure-key(fig)
  let kinds = __all-figure-kinds()
  assert(
    key in kinds,
    message: "unregistered figure kind `" + key + "`: register it with ktu-paper(figureKinds: ...)",
  )
  kinds.at(key).supplement
}

// ---------------------------------------------------------------------------
// Numbering
// ---------------------------------------------------------------------------

/// Resolves a figure's number (global "1" or section-based "1.1") at `loc`,
/// returned as a string.
#let __get-figure-number(fig-item, loc) = {
  assert(
    type(fig-item) == content and fig-item.func() == figure,
    message: "can only get figure number for figure elements",
  )

  let fig-counter = counter(figure.where(kind: fig-item.kind))

  if __FIG_PER_SECTION.at(loc) {
    let chapter = counter(heading).at(loc).at(0, default: 0)
    let fig-num = fig-counter.at(loc).at(0, default: 1)
    str(chapter) + "." + str(fig-num)
  } else {
    str(fig-counter.at(loc).at(0))
  }
}

/// Resolves an equation's number (global "2" or section-based "1.2") at `loc` without parentheses.
/// `loc` is the location of the equation.
#let __get-equation-number(loc) = {
  let number = counter(math.equation).at(loc).at(0)
  if __FIG_PER_SECTION.at(loc) {
    let chapter = counter(heading).at(loc).at(0, default: 0)
    str(chapter) + "." + str(number)
  } else {
    str(number)
  }
}

/// Numbering function for `math.equation`: "(2)" or, when numbering per
/// section, "(1.2)".
#let __equation-numbering(..nums) = context {
  let number = nums.pos().first()
  if __FIG_PER_SECTION.get() {
    let chapter = counter(heading).get().at(0, default: 0)
    // TODO: this is a hack to prevent the numbers from being completely
    // part of a regex match against math.equation.
    // It would be better to render math equation numbers as a separate element, so that regexes don't see them at all.
    [(#box[#chapter].#box[#number])]
  } else {
    [(#number)]
  }
}

/// Returns the number of a located figure element as a string, formatted
/// according to the current numbering scheme.
#let __get-locatable-element-number(element) = context {
  assert(type(element) == content, message: "can only reference elements of type content")
  assert(element.func() == figure, message: "referenced element does not have a figure function")
  __get-figure-number(element, element.location())
}

/// Appendix headings carry an "appendix-heading" metadata marker as their
/// first child and are numbered differently from normal headings.
#let __is-appendix-heading(item) = {
  let body = item.body
  body.has("children") and body.children.at(0, default: none) == metadata("appendix-heading")
}

/// Parses a dotted number such as "12" or "1.12.5" into an array of ints.
/// Returns `none` if any part is not purely numeric.
#let __parse-number(value) = {
  let parts = value.split(".")
  if parts.all(p => p.match(regex("^\\d+$")) != none) {
    parts.map(int)
  } else {
    none
  }
}

/// Sorts `(location, number)` entries. If every number is numeric (optionally
/// dotted, e.g. "1.12.5"), sorts component-wise numerically; otherwise falls
/// back to plain string ordering.
#let __sort-entries(entries) = {
  let keys = entries.map(e => __parse-number(e.at(1)))
  if keys.all(k => k != none) {
    entries.zip(keys).sorted(key: pair => pair.at(1)).map(pair => pair.at(0))
  } else {
    entries.sorted(key: e => e.at(1))
  }
}

// ---------------------------------------------------------------------------
// References
// ---------------------------------------------------------------------------

/// Returns a number for the given reference target.
/// - target (label): Label to get the reference number for.
#let ref-no(target) = context {
  if type(target) != label {
    panic("ref-no expects a label as input")
  }

  let item = query(target).first()
  let loc = item.location()
  let kind = item.func()

  let number = if kind == figure {
    __get-figure-number(item, loc)
  } else if kind == math.equation {
    "(" + __get-equation-number(loc) + ")"
  } else if kind == heading {
    let numbers = counter(heading).at(loc)
    if __is-appendix-heading(item) {
      str(numbers.at(1))
    } else {
      numbers.map(str).join(".")
    }
  } else {
    panic("referencing unknown type: " + repr(kind))
  }

  link(loc, number)
}

/// Create a custom reference for multiple targets of the same type.
/// - targets (label...): Labels to create a custom reference for.
#let custom-ref(..targets) = context {
  let group-name = none
  let entries = () // (location, number) pairs

  for target in targets.pos() {
    let item = query(target).first()
    let loc = item.location()

    let (name, number) = if item.func() == math.equation {
      (__figure-kinds.equation.ref-name, __get-equation-number(loc))
    } else if item.func() == figure {
      let kind = __figure-key(item)
      let kinds = __all-figure-kinds()
      if kind not in kinds {
        panic("unregistered figure kind `" + kind + "`: register it with ktu-paper(figureKinds: ...)")
      }
      (kinds.at(kind).ref-name, __get-figure-number(item, loc))
    } else {
      panic("referencing unknown type: " + repr(item.func()))
    }

    if group-name != none and group-name != name {
      panic("custom-ref does not support grouping different elements together")
    }
    group-name = name
    entries.push((loc, number))
  }

  if entries.len() > 0 {
    let links = __sort-entries(entries).map(e => link(e.at(0), e.at(1)))
    [(žr. #links.join(", ") #group-name)]
  }
}

/// Show rule for `@label` references. Equations render as a bare "(1.2)";
/// figures delegate to `custom-ref`, so "(žr. 1 pav.)" is built in one place.
/// Anything else (headings, citations, unregistered figure kinds) keeps
/// Typst's default rendering.
#let __format-ref(it) = {
  let el = it.element
  if el == none { return it }

  if el.func() == math.equation {
    let loc = el.location()
    link(loc, "(" + __get-equation-number(loc) + ")")
  } else if el.func() == figure and __figure-key(el) in __all-figure-kinds() {
    custom-ref(it.target)
  } else {
    it
  }
}

// ---------------------------------------------------------------------------
// Figure layout
// ---------------------------------------------------------------------------

/// Formats a figure with a caption and number.
#let __format-figure(it) = {
  let caption = it.caption

  // If caption is not provided, just show the figure body
  if caption == none { return it.body }

  set text(size: 11pt)

  let supplement = __figure-supplement-of(it)
  let separator = [.]
  let fig-num = context __get-figure-number(it, here())
  let caption-line = [*#fig-num #supplement#separator* #caption.body]

  // Tables have captions at the top
  if it.kind == table {
    align(left, caption-line)
    it.body
  } else {
    it.body
    align(center, caption-line)
  }
}
