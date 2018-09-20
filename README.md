# scala-repl-vim

A Vim plugin that can send Scala source lines from one buffer to a running
Scala REPL buffer, e.g. `scala`, `sbt console`, and `spark-shell`.

## Usage

- `<localleader>w`. Opens a new REPL window.
- `<localleader>e`. Evaluates the line under the cursor in the REPL.
- `<localleader>e`. Evaluates the visually selected lines in the REPL.

