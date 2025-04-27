# embrace.nvim

Embrace your text.

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
  keymap = "S",         -- keymap to surround text
  cmd = "Surround",     -- user command
})
```

## Usage

The following keybindings are provided.

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

## TODO

- [ ] Add custom surrounds.

## Inspirations

- [vim-surround](https://github.com/tpope/vim-surround)
- [nvim-surround](https://github.com/kylechui/nvim-surround/tree/main)

