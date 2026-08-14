// GitHub-Inspired Polylux Theme for projector

// Color palette
#let bg = rgb("ffffff")
#let basecolor = rgb("#24292f")
#let accent = rgb("#0969da")
#let muted = rgb("#57606a")
#let borders = rgb("#d0d7de")

// Progress bar
#let progress = (api) => (api.toolbox.progress-ratio)(ratio => {
  grid(
    columns: (ratio * 100%, 1fr),
    grid.cell(fill: accent)[],
    grid.cell(fill: borders)[],
  )
})

#let projector-theme = (api, doc) => {
  set page(
    paper: "presentation-16-9",
    margin: 2em,
    fill: bg,
    footer: progress(api),
  )
  set text(fill: basecolor, size: 1em)
  show raw: set text(fill: accent)
  doc
}

#let title-slide = (api, title, subtitle, authors, date) => (api.slide)[
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

#let toc-slide = (api, toc_title) => (api.slide)[
  #set align(left + horizon)
  #text(size: 1.5em, weight: "bold")[#toc_title]
  #v(0.8em)
  #(api.toolbox.all-sections)((sections, current) => {
    enum(..sections)
  })
]

#let section-slide = (api, name) => (api.slide)[
  #(api.toolbox.register-section)(name)
  #set align(left + horizon)
  #text(size: 1.75em, weight: "bold")[#name]
  #rect(height: 1pt, width: 100%, fill: borders)
]
