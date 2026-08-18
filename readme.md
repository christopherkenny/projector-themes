# Themes for `projector` <img src='https://raw.githubusercontent.com/christopherkenny/projector/refs/heads/main/projector.png' align="right" height="150" />

[`projector`](https://github.com/christopherkenny/projector) is a Quarto extension for making slides with interchangeable Typst backends, including [Polylux](https://github.com/andreasKroepelin/polylux) and [Touying](https://github.com/touying-typ/touying).
The themes in this repository work with any projector backend.

This repo contains several themes for `projector`.
Currently supported themes are listed below:

| theme      | description |
| ---------- | ----------- |
| coding     | A minimal theme using [GitHub Monaspace](https://github.com/githubnext/monaspace) fonts |
| cousteau   | A blue, nautical theme based on [`mattblackwell/cousteau`](https://github.com/mattblackwell/cousteau) for beamer |
| darker     | A dark theme with compact sans serif fonts  |
| friendly   | A theme with whimsy based on [`polylux-typ/friendly`](https://github.com/polylux-typ/friendly) |
| metropolis | A modern theme based on [`polylux-typ/metropolis`](https://github.com/polylux-typ/metropolis) and a [beamer template of the same name](https://github.com/matze/mtheme) |
| techy      | A bright, futuristic theme overusing monospace sans serif fonts |
| university | A professional, academic theme allowing for two color accents based on [`polylux-typ/polylux`'s university theme](https://github.com/polylux-typ/polylux) |

## Using a packaged theme

Install the themes extension in an existing Quarto project with:

```bash
quarto add christopherkenny/projector-themes
```

Then add the filter and select a theme by name:

```yaml
format: projector-typst
filters:
  - projector-themes
theme: metropolis
```

The filter maps the theme name to its bundled `.typ` file and supplies the theme's default Quarto options.
Document-level options override those defaults.

## Custom themes

To make a private variant, copy a bundled `.typ` file into your project, edit
it, and point `theme` at the copy:

```yaml
format: projector-typst
theme: themes/my-university.typ
```

Custom file paths are resolved relative to the `.qmd` file and do not need to be added to `projector-themes.lua` or accompanied by a YAML file.

## Contributing a theme

To contribute a theme to this collection, please submit a pull request.
The `template` folder contains a starting point for a new theme.

For each theme, include:

- `<theme>/readme.md`: a short description and any necessary attribution details.
- `_extensions/projector-themes/themes/<theme>.typ`: the Typst code for the theme. This may include copies of default definitions; remove those if you do not want to edit them.
- `<theme>/LICENSE`: any necessary licensing details. Adapting themes from TeX or other Typst templates may require attribution. If possible, use the MIT-0 license for themes of this kind.

Also register the theme's name and defaults in `projector-themes.lua`.

Then a thumbnail should be included.

To create one:

1. Render the `template.qmd` with your theme.
2. Create a png with dpi = 150 version of the first six slides in the order:

```
1 2
3 4
5 6
```

An R function to do this is:

```r
generate_thumbnail <- function(theme, pdf_file = 'template.pdf', dpi = 150) {
  if (missing(theme)) {
    stop('`theme` must be provided. e.g. `"metropolis"`.')
  }
  pages <- lapply(1:6, function(i) {
    pdftools::pdf_render_page(pdf_file, page = i, dpi = 150) |>
    magick::image_read()
  })

  thumbnail <- magick::image_append(
    c(
      magick::image_append(c(pages[[1]], pages[[3]], pages[[5]]), stack = TRUE),
      magick::image_append(c(pages[[2]], pages[[4]], pages[[6]]), stack = TRUE)
    )
  )

  magick::image_write(thumbnail, path = paste0(theme, '.png'), density = 150)
}

```

### Theme defaults

`projector` includes several custom arguments that can be supplied in the YAML header.

- `mainfont`: sets font (see options with `quarto typst fonts`)
- `codefont`: sets the font used for code
- `mathfont`: sets the font used for math
- `fontsize`: sets the base font size
- `margin`: sets page margins
- `papersize`: the paper size to use (choices listed [here](https://typst.app/docs/reference/layout/page/))
- `toc`: whether to display the table of contents
- `toc-title`: title of the table of contents
- `background-image`: the path to an image to put as the background
- `theme`: a bundled theme name or a file name containing your customizations

The filter stores each theme's defaults in `projector-themes.lua` and only
fills in options that are not already present in the document.

### Details of the `.typ` file

Within the `.typ` file, you should include all of your styling choices within a function called `projector-theme(api, doc)`.
The `api` record supplies the selected backend's slide functions and toolbox, so themes do not need backend-specific imports.
Any styling choices should be applied within the function.
The file may contain any valid Typst code, including using other packages available on [Typst Universe](https://typst.app/universe/).
The file is imported as a Typst module.

In Typst syntax, the style will be applied as follows:

```typst
#show: projector-theme.with(api)
```

The filter supplies the `theme` path, so the file must include a definition for `projector-theme(api, doc)`.

Further, all Quarto format options are applied *after* the theme file is used.
As such, if you want to edit things controlled by Quarto, such as the font, you *must* do this via the YAML, not by the `.typ` file.
Later definitions take precedence, so you will see no changes, but it will *silently* change nothing, as the code is still valid.

To modify the title, TOC, or section slides, you need to adjust them in your template file.
Redefine the functions that produce them with your own version.

For example, use the backend-neutral `api` functions like this:

```typst
#let section-slide(api, name) = (api.slide)[
  #(api.toolbox.register-section)(name)
  #name
]

#let toc-slide(api, toc_title) = (api.slide)[
  #(api.toolbox.all-sections)((sections, current) => {
    enum(..sections)
  })
]
```

The main slide functions available through `api` include `slide`, `focus-slide`, `last-slide`, `pause`, `item-by-item`, `slide-number`, `later`, and `speaker-note`.
The `api.toolbox` record also includes helpers such as `register-section`, `all-sections`, `progress-ratio`, `full-width-block`, `next-heading`, and `slide-number`.

The function signatures should be as follows:

- `title-slide(api, title, subtitle, authors, date)`
- `toc-slide(api, toc_title)`
- `section-slide(api, name)`

Each of these slide calls should return a slide, via a call to `(api.slide)[...]`.
The one exception is if you want it to *not* do anything.
For example, if you don't want a section slide, then return `{}`.
You do not need to use the arguments to these functions, but the signatures must match exactly or you'll get a compilation error.

The `toc-slide` function can use `api.toolbox.all-sections` for a backend-neutral outline.
The `section-slide` function can use `api.toolbox.register-section(name)` to register the section.

Finally, if you only want to change the title, toc, or section slides, you do not need to provide a new definition of `projector-theme`.
