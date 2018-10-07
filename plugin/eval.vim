function! s:EvalLine(...) abort

  if !exists('b:repl_channel_id')
    echoerr 'Failed to evaluate line at the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind {repl_bufname} to bind the terminal.'
    return
  end

  " Get the current REPL mode.
  let repl_mode = ReplModeGetCurrent()

  " Get the current line from the source buffer.
  let payload = getline(line('.'))

  " Prepare the frame.
  let frame = repl_mode.line.header . payload . repl_mode.line.footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)
endfunction


function! s:EvalBlock(...) abort range

  if !exists('b:repl_channel_id')
    echoerr 'Failed to evaluate block at the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind {repl_bufname} to bind the terminal.'
    return
  end

  " Get the current REPL mode.
  let repl_mode = ReplModeGetCurrent()

  " Get the visually selected lines in the source buffer.
  let lines = getline(a:firstline, a:lastline)
  let payload = join(lines, "\n") . "\n"

  " Prepare the frame.
  let frame = repl_mode.block.header . payload . repl_mode.block.footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)
endfunction


" Script mappings.
noremap <unique> <silent> <script>
      \ <Plug>ReplEvalLine
      \ :call <SID>EvalLine()<CR>
noremap <unique> <silent> <script>
      \ <Plug>ReplEvalBlock
      \ :call <SID>EvalBlock()<CR>

" Default mappings.
if !hasmapto('<Plug>ReplEvalLine')
  nmap <leader>re <Plug>ReplEvalLine
end
if !hasmapto('<Plug>ReplEvalBlock')
  vmap <leader>re <Plug>ReplEvalBlock
end

