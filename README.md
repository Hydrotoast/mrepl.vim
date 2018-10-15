## mrepl.vim

Adds a modal REPL protocol to Neovim. A REPL protocol defines a line format and
a block format for statements to be evaluated in a REPL. Switching the mode
will switch the line and block formats.

### Installation

Depending on your plugin manager, the installation procedure may vary. We list
some common plugin manager configurations below.

For [vim-plug][vim-plug], add the following configuration.
```
Plug 'Hydrotoast/mrepl.vim'
```

For [Vundle][vundle], add the following configuration.
```
Plugin 'Hydrotoast/mrepl.vim'
```

### Usage

To begin using `mrepl.vim`, we bind the current buffer to an existing termianl
and switch to the appropriate REPL mode.

- `<leader>rb`. Binds the current buffer to an existing terminal.
- `<leader>rs`. Switches the REPL mode.

To evaluate selections in the bound REPL, we use the default operator mappings.

- `<leader>re{motion}`. Evaluates the selection in the REPL.
- `<leader>re`. Evaluates the visual selection in the REPL.

### Mappings

To map keys to the behaviors, the following mappings are available.

| Mapping                 | Default       | Description                     |
| ----------------------- | ------------- | ------------------------------- |
| `<Plug>ReplBind`        | `<leader>rb`  | Binds the buffer to a terminal. |
| `<Plug>ReplSwitchMode`  | `<leader>rs`  | Switches the REPL mode.         |
| `<Plug>ReplEval`        | `<leader>re`  | Evaluates selections.           |

[vim-plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/VundleVim/Vundle.vim
