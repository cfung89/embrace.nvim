# embrace.nvim

> embrace.nvim:
>
>     Embrace your text.

embrace.nvim allows for quick addition of surrounding characters such as quotes, brackets, tags, or any string around selected text.

## Features

- Surround visual mode selection.
- Surround visual block selection.
- Support for:
  - For brackets: `()`, `[]`, `{}`, `<>`.
  - Any single character.
  - Any string.
  - Closing HTML tags.


## Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "cfung89/embrace.nvim"
}
```

## Configuration

```lua
require("embrace").setup({
  --- default configuration
  keymaps = {
    surround = "S",             -- Surround
    surround_block = "B"        -- Surround in block mode after the above keymap
    block = "<leader>SB",       -- Surround in block mode directly
    str = "S",                  -- Input string when surrounding
  }
  
  -- Custom added/modified surround input map
  -- Must be of the form { { "<input_key>", "<opening_string>", "<closing_string" }, ... },
  -- where when input_key is entered (for example with 'S<input_key>'), the selected text will
  -- be surround with opening_string and closing string.
  surround_map = {},

  -- Custom added/modified surround block input map
  -- If nil, surround_block_map is set to surround_map.
  -- Must be of the form { { "<input_key>", "<opening_string>", "<closing_string" }, ... },
  -- where when input_key is entered (for example with 'S<input_key>'), the selected text will
  -- be surround with opening_string and closing string.
  surround_block_map = nil,
})
```

## Usage

The following default keybindings are provided.

### Visual mode

```
S(          Surround selected text with `( ` and ` )`
S)          Surround selected text with `(` and `)`
S[          Surround selected text with `[ ` and ` ]`
S]          Surround selected text with `[` and `]`
S{          Surround selected text with `{ ` and ` }`
S}          Surround selected text with `{` and `}`
S<          Surround selected text with `< ` and ` >`
S>          Surround selected text with `<` and `>`

S<char>     Surround selected text with provided input character.
SS          Surround selected text with provided input string.
```

### Visual block mode

Note: These keybindings also work in "normal" visual mode. They will surround each line within the visual selection with the specified characters.

This is generally called using the `surround` keymap followed by `surround_block`
```
SB(         Surround selected text block with `( ` and ` )`
SB)         Surround selected text block with `(` and `)`
SB[         Surround selected text block with `[ ` and ` ]`
SB]         Surround selected text block with `[` and `]`
SB{         Surround selected text block with `{ ` and ` }`
SB}         Surround selected text block with `{` and `}`
SB<         Surround selected text block with `< ` and ` >`
SB>         Surround selected text block with `<` and `>`

SB<char>    Surround selected text block with provided input character.
SBS         Surround selected text block with provided input string.
```

This can also be called directly as follows, using the `block` keymap (without the `surround` keymap).

## TODO

- [X] Fix surround visual block on lines with different tabbing.
- [X] Add custom surrounds.

## Inspirations

- [vim-surround](https://github.com/tpope/vim-surround)
- [nvim-surround](https://github.com/kylechui/nvim-surround/tree/main)

