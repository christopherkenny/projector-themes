#let grey-gray = rgb("#dbdbdb")
#let grey-dark-gray = rgb("#4a4a4a")

#let projector-theme(doc) = {
  // Set the default text and background colors
  set text(stroke: grey-dark-gray)
  set page(fill: grey-gray)
  show heading: it => {
    it
    v(1em)
  }
  set box(stroke: black, outset: 2em)
  doc
}

// optional:
// #import "@preview/polylux:0.3.1": *

#let title-slide(title, subtitle, authors, date) = {
  polylux-slide[
    #if title != none {
      align(center)[
        #block(inset: 1em)[
          #text(weight: "bold", size: 3em)[
            #title
          ]
          #if subtitle != none {
            linebreak()
            text(subtitle, size: 2em, weight: "semibold")
          }
        ]
      ]
    }
    #set text(size: 1.25em)

    #if authors != none and authors != [] {
      let count = authors.len()
      let ncols = calc.min(count, 3)
      grid(
        columns: (1fr,) * ncols,
        row-gutter: 1.5em,
        ..authors.map(author => align(center)[
          #author.name \
          #author.affiliation
        ])
      )
    }

    #if date != none {
      align(center)[#block(inset: 1em)[
          #date
        ]
      ]
    }
  ]
}

#let toc-slide(toc_title) = {
  polylux-slide[
    #let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    #heading(toc_title)
    #set text(size: 2em)
    // TODO 0.13 update to use new toolbox version
    #align(horizon)[
      #polylux-outline()
    ]
  ]
}

// TODO 0.13 update to slide
#let section-slide(name) = {
  polylux-slide[
    #set align(horizon)
    #set text(size: 4em)
    // TODO 0.13 update to #toolbox.register-section
    #utils.register-section(name)

    #strong(name)
  ]
}
