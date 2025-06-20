# Themes for `projector` <img src='https://raw.githubusercontent.com/christopherkenny/projector/refs/heads/main/projector.png' align="right" height="150" />

[`projector`](https://github.com/christopherkenny/projector) is a Quarto extension for making slides with [polylux](https://github.com/andreasKroepelin/polylux).
The design of the extension does not make it compatible with Polylux's design templates.
However, styling can be done (relatively) easily through the `theme` YAML option.

This repo contains several themes for `projector`.
Currently supported themes are listed below:

| theme      | description |
| ---------- | ----------- |
| cousteau   | A blue, nautical theme based on [`mattblackwell/cousteau`](https://github.com/mattblackwell/cousteau) for beamer |
| darker     | A dark theme with compact sans serif fonts  |
| friendly   | A theme with whimsy based on [`polylux-typ/friendly`](https://github.com/polylux-typ/friendly) |
| metropolis | A modern theme based on [`polylux-typ/metropolis`](https://github.com/polylux-typ/metropolis) and a [beamer template of the same name](https://github.com/matze/mtheme) |
| techy      | A bright, futuristic theme overusing monospace sans serif fonts |

## Using a template

Each template comes with a pair of files necessary to use the theme.
The `*.yaml` will contain any settings that should be used in the YAML of your Quarto file.
The `*.typ` file should be placed in the directory of your Quarto file and then added to the `theme` YAML argument in the Quarto file.

## Contributing a theme

To contribute a theme, please submit a pull request.
The `template` folder contains a template theme file.
Each of these files should be edited to supply your theme.

- `readme.md`: This should contain a short description of the theme. If there is any necessary attribution, please include details here.
- `template.yaml`: This should set any YAML options to be used in Quarto.
- `template.typ`: This should include any relevant Typst code to set up your theme. This includes copies of default definitions. Please remove those if you do not want to edit them.
- `LICENSE`: This should contain any necessary license details. Notably, adopting themes from Tex or other Typst templates may require attribution in this. If possible, I recommend using the MIT-0 license for themes of this kind.

Then a thumbnail should be included. To create one:

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



### Details of the `.yaml` file

`projector` includes several custom arguments that can be supplied in the YAML header.

- `mainfont`: sets font (see options with `quarto typst fonts`)
- `margin`: sets page margins
- `papersize`: the paper size to use (choices listed [here](https://typst.app/docs/reference/layout/page/))
- `toc`: whether to display the table of contents
- `toc_title`: title of the table of contents
- `background-image`: the path to an image to put as the background
- `theme`: a file name containing your customizations

These arguments take precedence over any settings in the `.typ` file.
All `.yaml` files should contain a `theme` argument at a minimum.

### Details of the `.typ` file

Within the `.typ` file, you should include all of your styling choices within a function called `projector-theme(doc)`.
Any styling choices should be applied within the function.
The file may contain any valid Typst code, including using other packages available on [Typst Universe](https://typst.app/universe/).
The contents of the file will be dropped into the template verbatim.
The current definitions file imports `polylux` and `fontawesome`by default.

In Typst syntax, the style will be applied as follows:

```typst
show: projector-theme
```

If `theme` is set in the YAML, this line will be run so it must include a definition for `projector-theme(doc)`.

Further, all YAML options are applied *after* the theme file is used.
As such, if you want to edit things controlled by the YAML, such as the font, you *must* do this via the YAML, not by the `.typ` file.
Later definitions take precedence, so you will see no changes, but it will *silently* change nothing, as the code is still valid.

To modify the title, TOC, or section slides, you need to adjust them in your template file.
Redefine the functions that produce them with your own version.

The function signatures should be as follows:

- `title-slide(title, subtitle, authors, date)`
- `toc-slide(toc_title)`
- `section-slide(name)`

Each of these slide calls should return a slide, via a call to `polylux-slide[]`.
The one exception is if you want it to *not* do anything.
For example, if you don't want a section slide, then return `{}`.
You do not need to use the arguments to these functions, but the signatures must match exactly or you'll get a compilation error.

The `toc-slide` function should contain a call to `#polylux-outline()` if you want the default outline included.
The `section-slide` function should contain a call to`#utils.register-section(name)` to register the section.

Finally, if you just want to change the title, toc, or section slides, you can use a call to `projector-theme` that is empty.
Specifically, include the following:

```typst
projector-theme(doc) = {
  doc
}
```
The function must be present, but it doesn't have to do anything.
