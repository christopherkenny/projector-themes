// Friendly theme for Typst Polylux (Projector-compatible)
// Based on: https://github.com/polylux-typ/friendly (MIT License)
// Adapted by Christopher T. Kenny, 2025

#let accent1 = rgb("#637A9F")
#let accent2 = rgb("#E8C872")
#let accent3 = rgb("#80B9AD")
#let accent4 = rgb("#B3E2A7")
#let bg-color = rgb("#fcfcfc")

#let logo = none //ex: "projector.png"

#let projector-theme(api, doc) = {

  set page(
    fill: bg-color,
    footer: {
      set align(top + right)
      set text(fill: gray)
      h(1fr)
      api.toolbox.slide-number
    }
  )

  show emph: it => {
    set text(fill: accent2)
    it.body
  }

  show heading.where(level: 1): underline.with(
    background: true,
    stroke: (thickness: .3em, paint: accent2.lighten(50%), cap: "round"),
    evade: false,
    extent: .2em,
  )
  show heading: set block(below: 1em)

  doc
}

#let title-slide(api, title, subtitle, authors, date) = {
  set page(margin: 0pt, footer: none)
  (api.slide)[
  #set align(horizon)
  #grid(
    columns: (1fr, 2fr),
    rows: (1fr,),
    gutter: 1em,
    grid.cell(
      inset: (top: 2em, bottom: 1em, left: .5em),
      align: right
    )[
      #align(bottom + right)[
        #if logo != none {
          set image(width: 75%)
          image(logo)
        }
      ]

    ],
    grid.cell(fill: accent1, inset: 1em, align: left)[
      #set text(fill: white)
      #text(size: 2em, weight: "bold", hyphenate: false)[
        #title
      ]
      #v(1em)
      #if subtitle != none and subtitle != "" {
        text(size: 1.5em, fill: accent3)[#smallcaps[#subtitle]]
      }
      #v(1em)
      #if authors != none and authors != "" {
        text(size: 1.2em)[ #authors.map(a => a.name).join(", ") ]
      }
      #v(1em)
      #if date != none and date != "" {
        text(size: 1em)[ #date ]
      }
    ]
  )
  ]
}

#let section-slide(api, name) = (api.slide)[
  #set align(center + horizon)
  #(api.toolbox.register-section)(name)
  #text(size: 2em, weight: "bold", fill: accent1)[ #name ]
  #line(stroke: (thickness: .3em, paint: accent3, cap: "round"),
  length: 40%)
]

#let toc-slide(api, toc_title) = (api.slide)[
  #heading[ #toc_title ]
  #(api.toolbox.all-sections)((sections, current) => {
    enum(..sections)
  })
]
