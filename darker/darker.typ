#import "@preview/polylux:0.4.0": *

#let bg-color = rgb("#000000")
#let text-color = rgb("#e0e0e0")
#let accent1 = rgb("#2BB3A3")
#let accent2 = rgb("#4ec9b0")
#let accent3 = rgb("#569cd6")

#let progress-bar = toolbox.progress-ratio(ratio => {
  set grid.cell(inset: (y: 0.03em))
  grid(
    columns: (ratio * 100%, 1fr),
    grid.cell(fill: rgb(85, 85, 85))[],
    grid.cell(fill: accent3)[],
  )
})

#let projector-theme = (doc) => {

  set page(
    fill: bg-color,
    footer: progress-bar
  )

  set text(fill: text-color)
  show raw.where(block: true): set text(fill: black)

  doc
}

#let title-slide = (title, subtitle, authors, date) => slide[
  #set align(center + horizon)

  #text(size: 2em, weight: "bold")[
    #title
  ]
  #v(0.5em)

  #if subtitle != none {
    text(size: 1.5em, fill: accent2)[#subtitle]
    v(0.5em)
  }

  #if authors != none {
    text(size: 1.25em)[
      #authors.map(a => a.name).join(", ", last: " and ")
    ]
    v(0.25em)
  }

  #if date != none {
    text(size: 1.25em)[#date]
  }
]

#let toc-slide(toc_title) = slide[
  #set align(horizon)
  #heading[#toc_title]
  #toolbox.all-sections((sections, current) => {
    enum(..sections)
  })
]

#let section-slide = (name) => slide[
  #toolbox.register-section(name)

  #set align(center + horizon)

  #toolbox.full-width-block(fill: accent1, inset: 12pt)[

    #set text(size: 3em, weight: "bold", fill: rgb(0,0,0))
    #name
  ]
]
