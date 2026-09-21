// This file includes logic for displaying figures in the document, including numbering, captions, and references. It also includes logic for handling figure numbering per section or globally, based on the configuration set in `config.typ`.
#import "config.typ": __FIG_PER_SECTION

/// Localizations for various recognized referenceable figure types.
/// This is used to provide the correct supplement text for each type of figure
/// when generating references, captions and outlines.
#let __figureNames = (
    table: (
        supplement: "lentelė",
    ),
    image: (
        supplement: "pav",
    ),
    raw: (
        supplement: "kodo frag",
    ),
    equation: (
        supplement: "lygtis",
    ),
)

/// Helper function to get the supplement text for a given figure type.
#let __fig-supplement(func) = {
    return __figureNames.at(repr(func)).supplement
}

#let __fig-func-to-name(func) = {
    if func == table {
        return "lentelė"
    }
    if func == image {
        return "pav."
    }
    if func == grid {
        return "pav."
    }
    return func
}

/// Helper function to resolve figure numbers (either global "1" or section-based "1.1").
/// It takes a figure item and referenced location and returns the appropriate number as a string.
#let __get-figure-number(fig-item, loc) = {
    if type(fig-item) != content {
        panic("can only get figure number for content elements")
    }

    if fig-item.func() != figure {
        panic("can only get figure number for figure elements")
    }

    let perSection = __FIG_PER_SECTION.at(loc)
    if perSection {
        let chapter = counter(heading).at(loc).at(0, default: 0)
        let figNum = counter(figure.where(kind: fig-item.kind)).at(loc).at(0, default: 1)
        str(chapter) + "." + str(figNum)
    } else {
        let caption = fig-item.caption
        if caption != none and caption.numbering != none {
            str(caption.counter.at(loc).at(0))
        } else {
            str(counter(figure.where(kind: fig-item.kind)).at(loc).at(0))
        }
    }
}

/// Helper function to get the number of a locatable element (figure, table, etc.)
/// based on its location in the document. It returns the number as a string, formatted according to the current numbering scheme.
#let __get-locatable-element-number(element) = context {
    if type(element) != content {
        panic("can only reference elements of type content")
    }
    let loc = element.location()
    let elem = query(loc)
    let fig = elem.at(0)
    if fig.func() != figure {
        panic("referenced element does not have a figure function")
    }
    __get-figure-number(fig, loc)
}

/// Formats a reference to a figure, table, or other numbered element.
#let __format-ref(it) = {
    let el = it.element
    if el == none {
        return it
    }

    // Override equation references
    if el.func() == math.equation {
        link(
            el.location(),
            numbering(el.numbering, ..counter(math.equation).at(el.location()))
        )
    // Override references to figures
    } else if el.func() == figure {
        let fig = el.body
        let figType = fig.func()
        let numStr = __get-figure-number(el, el.location())
        link(el.location(), [
            (žr. #numStr #__fig-func-to-name(figType))
        ])
    } else {
        it
    }
}

/// Formats a figure with a caption and number.
#let __format-figure(it) = {
    let separator = [.]
    let caption = it.caption

    // If caption is not provided, just show the figure body
    if caption == none {
        return it.body
    }

    let counter = caption.counter  
    let supplement = caption.supplement

    if it.body.func() == math.equation {
        supplement = __fig-supplement("equation")
    } else {
        supplement = __fig-supplement(it.kind)
    }
    set text(size: 11pt)

    let fig-num = context __get-figure-number(it, here())

    // Tables have captions at the top
    if it.kind == table {
        align(left)[*#fig-num #supplement#separator* #caption.body]
        it.body
    } else {
        it.body
        align(center)[*#fig-num #supplement#separator* #caption.body]
    }
}
