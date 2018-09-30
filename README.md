## vim-mrepl

Adds modal REPL protocol to Neovim. A REPL protocol defines a format for how
line and block commands are issued to a REPL. A modal protocol changes its
behavior based on the mode.

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

To switch the REPL mode, we use the command

```
:ReplSwitch {mode}
```

where the `{mode}` is the REPL mode to switch to.

For example, we can switch to the `scala` mode to evaluate source code in a
Scala REPL or spark-shell.

```
:ReplSwitch scala
```

### Configuration

To use this plugin, the `mapleader` option must be set in your `~/.vimrc` (or 
`~/.config/nvim/init.vim). For example, we can bind it to `,`.

```
let mapleader=","
```

Note that the `<leader>` variable refers to the key bound to the `mapleader`
option in key mappings.

**Repl modes.** We declare new REPL modes as follows.

```
ReplMode {mode}
ReplModeLine {mode} {header} {footer}
ReplModeBlock {mode} {header} {footer}
```

