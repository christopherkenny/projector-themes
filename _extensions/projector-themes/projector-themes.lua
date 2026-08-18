local themes = {
  coding = {
    file = "themes/coding.typ",
    defaults = {
      mainfont = "Monaspace Argon",
      codefont = "Monaspace Krypton",
      mathfont = "Monaspace Neon",
      fontsize = "16pt",
    },
  },
  cousteau = {
    file = "themes/cousteau.typ",
    defaults = {
      mainfont = "Fira Sans",
      codefont = "Fira Mono",
      mathfont = "Latin Modern Math",
      fontsize = "16pt",
    },
  },
  darker = {
    file = "themes/darker.typ",
    defaults = {
      mainfont = "Lexend",
      codefont = "JetBrains Mono",
      mathfont = "Noto Sans",
      fontsize = "14pt",
      ["toc-title"] = "Agenda",
    },
  },
  friendly = {
    file = "themes/friendly.typ",
    defaults = {
      mainfont = "Andika",
      codefont = "Fantasque Sans Mono",
      mathfont = "Lete Sans Math",
      fontsize = "14pt",
      ["toc-title"] = "Goals",
    },
  },
  metropolis = {
    file = "themes/metropolis.typ",
    defaults = {
      mainfont = "Fira Sans",
      codefont = "Fira Code",
      mathfont = "Fira Math",
      fontsize = "16pt",
      ["toc-title"] = "Agenda",
    },
  },
  techy = {
    file = "themes/techy.typ",
    defaults = {
      mainfont = "Titillium Web",
      codefont = "Roboto Mono",
      mathfont = "Noto Sans",
      fontsize = "14pt",
      ["toc-title"] = "Objectives",
    },
  },
  university = {
    file = "themes/university.typ",
    defaults = {
      fontsize = "16pt",
    },
  },
}

local function normalize_path(path)
  return path:gsub("\\", "/")
end

local function document_relative_path(path)
  path = normalize_path(path)
  if pandoc.path.is_absolute(path) or quarto.doc.input_file == nil then
    return path
  end

  local input_dir = pandoc.path.directory(quarto.doc.input_file)
  local resolved = pandoc.path.join({ input_dir, path })
  return normalize_path(pandoc.path.make_relative(resolved, input_dir, true))
end

local function bundled_theme_path(path)
  path = quarto.utils.resolve_path(path)
  if quarto.doc.input_file == nil then
    return normalize_path(path)
  end

  local input_dir = pandoc.path.directory(quarto.doc.input_file)
  return normalize_path(pandoc.path.make_relative(path, input_dir, true))
end

function Meta(meta)
  if meta["theme"] == nil then
    return meta
  end

  local name = pandoc.utils.stringify(meta["theme"])
  local theme = themes[name]
  if theme == nil then
    meta["theme"] = pandoc.MetaString(document_relative_path(name))
    return meta
  end

  meta["theme"] = pandoc.MetaString(bundled_theme_path(theme.file))
  for key, value in pairs(theme.defaults) do
    if meta[key] == nil then
      meta[key] = pandoc.MetaString(value)
    end
  end

  return meta
end

return {{ Meta = Meta }}
