## vim-mrepl

Adds modal REPL protocol to Neovim. A REPL protocol defines a format for how
line and block commands are issued to a REPL. A modal protocol changes its
behavior based on the mode.

### Configuration

To use this plugin, the `mapleader` option must be set in your `~/.vimrc` (or 
`~/.config/nvim/init.vim). For example, we can bind it to `,`.

```
let mapleader=","
```

Note that the `<leader>` variable refers to the key bound to the `mapleader`
option in key mappings.

### Usage

To begin using `vim-mrepl`, we need to bind the buffer to an existing terminal.

```
:ReplBind {repl_bufname}
```

Note that `{repl_bufname}` may be tab-completed across buffers, but only
terminal buffers are valid.

To evaluate lines in the bound REPL, we use the default bindings.

- `<leader>e`. Evaluates the line under the cursor in the REPL.
- `<leader>e`. Evaluates the selected lines in the REPL.

See the **Configuration** section to configure the `<leader>` key.

## System model

Suppose that we have a buffer with source code, the _source buffer_, and a
terminal that can evaluate lines of source code, the _REPL_. As a constraint, we
assume that the source buffer can be associated with at most on REPL, its _bound
REPL_.

Furthermore, we assume that the REPL is associated with the following Vim
components.

1. A single buffer, the _REPL buffer_.
2. A single channel, the _REPL channel_.

Note that a REPL may have many source buffers associated with it, but it is
unaware of them. As a special case, a REPL may not have any source buffers
associated with it.

### System operations

Given the sytem model, the following system operations are available.

*Bind REPL.* Given a source buffer and an existing REPL, bind the source buffer
to the REPL, so that the source buffer can copy source code to it.

*Evaluate line.* Given a source buffer, evaluate a line in its bound REPL if it
exists. Otherwise, display a warning.

*Evaluate block of lines.* Given a source buffer, evaluate a block of lines in
its bound REPL if it exists. Otherwise, display a warning.

