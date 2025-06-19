// Metropolis theme for Projector (Quarto + Polylux)
// Based on Matt Blackwell's cousteau

#import "@preview/polylux:0.4.0": *

#let cousteau-seablue  = rgb("#3498db")
#let cousteau-shipgrey = rgb("#2c3e50")
#let cousteau-skyblue  = rgb("#ecf0f1")
#let cousteau-capred   = rgb("#e74c3c")
#let cousteau-orange   = rgb("#e27520")

#let projector-theme(doc) = {
  // Set the default text and background colors
  set text(fill: black, weight: "light")

  let slide-header = toolbox.next-heading(txt => {
    show: toolbox.full-width-block.with(fill: cousteau-seablue, inset: 2em)
    set align(horizon)
    set text(fill: cousteau-skyblue, size: 1.5em, weight: "semibold")
    txt
  })

  set page(
    fill: cousteau-skyblue,
    header: slide-header,
    footer: {
      set text(size: 0.6em)
      place(bottom + right, dy: -1em, dx: 5em)[
        #toolbox.slide-number/#toolbox.last-slide-number
      ]
    }
  )

  set enum(spacing: 1em)

  show heading.where(level: 1): none

  show emph: set text(fill: cousteau-capred)
  show underline: set text(fill: cousteau-orange)

  set box(stroke: none, outset: 2em)
  doc
}

// required if setting any custom slide styles below:
#import "@preview/polylux:0.4.0": *

#let title-slide(title, subtitle, authors, date) = {
  slide[
    #set align(left + horizon)

    #if title != none {
      text(weight: "bold", size: 2.5em, fill: cousteau-seablue)[
        #title #linebreak()
      ]

      if subtitle != none {
        v(0.25em)
        text(subtitle, size: 1.25em, weight: "semibold", fill: cousteau-seablue)
        v(0.25em)
      }
    }
    #set text(size: 1em)
    #v(1em)

    #if (date != none and date != "") {
      date
    }

    #if authors != none and authors != [] {
      let count = authors.len()
      let ncols = calc.min(count, 3)
      grid(
        columns: ncols,
        align: left,
        row-gutter: 1.5em,
        column-gutter: 1em,
        ..authors.map(author => [
          #author.name \
          #author.affiliation
        ])
      )
    }

  ]
}

#let toc-slide(toc_title) = {
  slide[
    #let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    #heading(toc_title)
    #text(size: 2em, fill: cousteau-seablue)[
      #toolbox.all-sections((sections, current) => {
        enum(..sections)
      })
    ]
  ]
}

#let section-slide(name) = {
  slide[
    #align(horizon)[
      #text(size: 2em, fill: cousteau-seablue)[
        #strong(name)
      ]
    ]
    #toolbox.register-section(name)
  ]
}
