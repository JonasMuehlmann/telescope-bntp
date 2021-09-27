# telescope-bntp
telescope.nvim finders for https://github.com/JonasMuehlmann/bntp.go

# Setup

Add the following line somewhere after `require('telescope').setup()`.
```lua
require('telescope').load_extension('bntp')
```

# Available commands

```vim
-- List documents
:Telescope bntp documents

-- List a document's links
:Telescope bntp links

-- List a document's backlinks
:Telescope bntp backlinks

-- List a document's related pages
:Telescope bntp related_pages

-- List a document's sources
:Telescope bntp sources
```

# Additional Mappings

`documents` picker: `<c-l>` in insert or normal mode to insert a `markdown` link to the selected document.
