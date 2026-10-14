/// Whether to number figures per section or not.
/// If true, figures will be numbered like "1.1", "1.2", "2.1", etc.
/// If false, figures will be numbered like "1", "2", "3", etc.
///
/// TODO: figure out how to deal with numbering on sections such as
/// Appendix and other non-standard sections.
#let __FIG_PER_SECTION = state("svetikas.lt/ktu-paper/figure-numbering-per-section", false)

/// Whether to uppercase section titles or not.
/// If true, section titles will be uppercased.
/// If false, section titles will be displayed as-is.
#let __UPPERCASE_SECTION_TITLES = state("svetikas.lt/ktu-paper/uppercase-section-titles", false)

#let __DEBUG_AUTHOR_TABLE = state("$ktu-template-DEBUG_AUTHOR_TABLE", false)
#let debug-author-table() = {
  __DEBUG_AUTHOR_TABLE.update(true)
}

#let __HEADING_EXPERIMENT = state("$ktu-template-HEADING_EXPERIMENT", false)
#let enable-heading-experiment() = {
  __HEADING_EXPERIMENT.update(true)
}
