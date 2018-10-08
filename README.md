## mrepl.vim

Adds a modal REPL protocol to Neovim. A REPL protocol defines a line format and
a block format for commands send to a REPL. Switching the mode will switch the
line and block formats.

### Usage

To begin using `mrepl.vim`, we need to bind the buffer to an existing terminal.

```
:ReplBind {repl_bufname}
```

Note that `{repl_bufname}` may be tab-completed.

To evaluate lines in the bound REPL, we use the default operator mappings.

- `<leader>re{motion}`. Evaluates the text moved over in the REPL.
- `<leader>re`. Evaluates the visual selection in the REPL.

See the **Configuration** section to configure the `<leader>` key.

To switch the REPL mode, we use the command

```
:ReplModeSwitch {mode}
```

where the `{mode}` is the REPL mode to switch to.

For example, we can switch to the `scala` mode to evaluate source code in a
Scala REPL or spark-shell.

```
:ReplModeSwitch scala
```

### Configuration

To use this plugin, the `mapleader` option must be set in your `~/.vimrc` (or 
`~/.config/nvim/init.vim)`. For example, we can bind it to `,`.

```
let mapleader=","
```

Note that the `<leader>` variable refers to the key bound to the `mapleader`
option in key mappings.

#### Mappings

To map keys to the behaviors, the following mappings are available.

| Mapping                 | Default        |
| ----------------------- | -------------- |
| `<Plug>ReplBind`        | `<leader>rb`  |
| `<Plug>ReplModeSwitch`  | `<leader>rs`  |
| `<Plug>ReplEval`        | `<leader>re`  |
