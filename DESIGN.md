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

A REPL is in one of many modes, the _REPL mode_. The mode determines the
_REPL protocol_ for reading source code from the source buffer.

A REPL protocol consists of a header and footer data for reading source code,
which are necessary before evaluation.

### System operations

Given the sytem model, the following system operations are available.

*Bind REPL.* Given a source buffer and an existing REPL, bind the source buffer
to the REPL, so that the source buffer can copy source code to it.

*Switch REPL mode.* Given a source buffer with a bound REPL, switch the REPL
mode, so that we can change the REPL protocol.

*Evaluate line.* Given a source buffer, evaluate a line in its bound REPL if it
exists. Otherwise, display a warning.

*Evaluate block of lines.* Given a source buffer, evaluate a block of lines in
its bound REPL if it exists. Otherwise, display a warning.

