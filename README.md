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
:Telescope bntp documents
```

# Additional Mappings

`<c-l>` in insert or normal mode to insert a `markdown` link to the selected document.
