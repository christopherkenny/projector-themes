
#import "@preview/polylux:0.4.0": *

#let accent1 = rgb("#39FF14")
#let accent2 = rgb("#00BFFF")
#let accent3 = rgb("#FF2DA3")
#let bg-color = rgb("#FFFFFF")
#let grid-color = color.mix((white, 90%), (accent1, 10%))
#let title-font = "Orbitron"

#let progress-bar = toolbox.progress-ratio(ratio => {
  set grid.cell(inset: (y: 0.03em))
  grid(
    columns: (ratio * 100%, 1fr),
    grid.cell(fill: accent1)[],
    grid.cell(fill: accent2)[],
  )
})


#let projector-theme(doc) = {

  set text(fill: rgb("#111111"))

  let highlight = (content) => {
    set text(fill: accent1)
    content
  }
  show emph: it => highlight(it.body)

  show heading.where(level: 1): it => {
    set text(fill: accent2)
    it
    v(-0.75em)
    line(length: 100%, stroke: accent3 + 2pt)
  }

  set page(fill: bg-color)

  doc
}

#let title-slide(title, subtitle, authors, date) = slide[
  #set align(left + horizon)
  // Title text (large, bold)
  #text(font: title-font, size: 2em, weight: "bold")[
    #title
  ]

  // Subtitle, if present
  #if (subtitle != none and subtitle != "") {
    text(size: 1.5em, fill: accent2)[
      #subtitle
    ]
  }

  // Neon separator line
  #rect(fill: accent1, width: 100%, height: 3pt)

  // Authors line, if any
  #if (authors != none and authors != ()) {
    text(size: 1.25em)[#read("../../../../../../1em")
      #authors.map(author => author.name).join(", ", last: " and ")
    ]
  }

  // Date line, if any
  #if (date != none and date != "") {
    text(size: 1em)[ #date ]
  }
]


#let toc-slide(toc_title) = slide[
  // Title for the TOC page
  #heading(toc_title, level: 1)

  #toolbox.all-sections((sections, current) => {
    enum(..sections)
  })
]


#let section-slide(name) = slide[
  #set page(fill: accent1.darken(30%))
  #set text(fill: white)

  #set align(center + horizon)
  #text(font: title-font, size: 2.5em, weight: "semibold")[
    #name
  ]
  #toolbox.register-section(name)  // register for TOC
  #progress-bar
]
