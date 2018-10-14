function! mrepl#eval#Selection(selection, repl_mode) abort

  if !exists('b:repl_channel_id')
    echoerr 'Failed to evaluate block at the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind {repl_bufname} to bind the terminal.'
    return
  end

  " Choose the format type based on whether the selection has a newline.
  let has_newline = stridx(a:selection, "\n") != -1
  let format_type = has_newline ? 'block' : 'line'

  " Prepare the frame.
  let format = a:repl_mode[format_type]
  let frame = format.header . a:selection . format.footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)
endfunction

