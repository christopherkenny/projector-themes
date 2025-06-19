// Metropolis theme for Typst Polylux (Projector) – inspired by matze's Beamer Metropolis
// Polylux port by Andreas Kröpelin & Enivex (MIT License)

#import "@preview/polylux:0.4.0": *

// Color palette (Metropolis defaults)
#let bright = rgb("#eb811b") // primary accent (orange)
#let brighter = rgb("#d6c6b7") // light variant of accent (unused here)
#let header-color = rgb("#23373b") // dark header background (nearly black)

// Theme setup function with default fonts and sizes:contentReference[oaicite:1]{index=1}
#let projector-theme(doc) = {

  set text(weight: "light")

  let slide-title-header = toolbox.next-heading(h => {
    show: toolbox.full-width-block.with(fill: text.fill, inset: 1em)
    set align(horizon)
    set text(fill: page.fill, size: 1.2em)
    strong(h)
  })

  set page(
    fill: rgb("#FAFAFA"),
    header: slide-title-header,
    footer: {
      set text(size: 0.8em)
      set align(horizon)
      h(1fr)
      toolbox.slide-number
    }
  )

  let focus(body) = {
    set text(fill: bright)
    body
  }
  show emph: it => {
    focus(it.body)
  }

  show heading.where(level: 1): none
  show heading.where(level: 2): it => {
    box(
      fill: header-color,
      width: 100%,
      inset: 4pt,
    )[ #text(fill: white, weight: "bold")[ #it.body ] ]
  }

  set align(horizon + left)

  doc
}

// Title slide layout
#let title-slide(title, subtitle, authors, date) = slide[
  #set align(left + horizon)
  #text(size: 36pt, weight: "bold")[ #title ]

  #if (subtitle != none and subtitle != "") {
    text(size: 20pt)[ #subtitle ]
  }

  #rect(fill: bright, width: 100%, height: 3pt)

  #if (authors != none and authors != "") {
    text(size: 20pt)[
      #authors.map(
        author => {author.name}
      ).join(", ", last: " and ")
    ]
  }

  #if (date != none and date != "") {
    text(size: 20pt)[ #date ]
  }
]

// Table of contents slide – lists all sections
#let toc-slide(toc_title) = slide[
    // Title bar with “Agenda”
    #heading(toc_title, level: 1)
    // Enumerate all section titles (registered via section-slide)
    #toolbox.all-sections((sections, current) => {
      enum(..sections)
    })
]

#let progress-bar = toolbox.progress-ratio( ratio => {
  set grid.cell(inset: (y: .03em))
  grid(
    columns: (ratio * 100%, 1fr),
    grid.cell(fill: bright)[],
    grid.cell(fill: brighter)[],
  )
})

// Section break slide – large section title with accent rule
#let section-slide(name) = slide[
  #set align(horizon)
  #text(size: 2em)[
    #name
  ]

  #toolbox.register-section(name)
  #progress-bar
]
