// GitHub-Inspired Polylux Theme for projector

#import "@preview/polylux:0.4.0": *

// Color palette
#let bg = rgb("ffffff")
#let basecolor = rgb("#24292f")
#let accent = rgb("#0969da")
#let muted = rgb("#57606a")
#let borders = rgb("#d0d7de")

// Progress bar
#let progress = toolbox.progress-ratio(ratio => {
  grid(
    columns: (ratio * 100%, 1fr),
    grid.cell(fill: accent)[],
    grid.cell(fill: borders)[],
  )
})

#let projector-theme = (doc) => {
  set page(
    paper: "presentation-16-9",
    margin: 2em,
    fill: bg,
    footer: progress,
  )
  set text(fill: basecolor, size: 1em)
  show raw: set text(fill: accent)
  doc
}

#let title-slide = (title, subtitle, authors, date) => slide[
  #set align(left + horizon)
  #text(size: 2em, weight: "bold")[#title]
  #rect(height: 1pt, width: 100%, fill: borders)
  #v(1em)

  #if subtitle != none and subtitle != "" {
    text(size: 1.25em, weight: "semibold", fill: accent)[#subtitle]
    v(0.8em)
  }

  #if authors != none and authors != () {
    text(size: 0.9em, fill: muted)[#authors.map(a => a.name).join(", ", last: " and ")]
    v(0.5em)
  }

  #if date != none and date != "" {
    text(size: 0.9em, fill: muted)[#date]
  }
]

#let toc-slide = (toc_title) => slide[
  #set align(left + horizon)
  #text(size: 1.5em, weight: "bold")[#toc_title]
  #v(0.8em)
  #toolbox.all-sections((sections, current) => {
    enum(..sections)
  })
]

#let section-slide = (name) => slide[
  #toolbox.register-section(name)
  #set align(left + horizon)
  #text(size: 1.75em, weight: "bold")[#name]
  #rect(height: 1pt, width: 100%, fill: borders)
]
