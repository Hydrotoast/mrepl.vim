function! s:EvalSelection(selection) abort

  if !exists('b:repl_channel_id')
    echoerr 'Failed to evaluate block at the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind {repl_bufname} to bind the terminal.'
    return
  end

  " Choose the format type based on whether the selection has a newline.
  let has_newline = stridx(a:selection, "\n") != -1
  let format_type = has_newline ? 'block' : 'line'

  " Get the current REPL mode.
  let repl_mode = ReplCurrentModeGet()

  " Prepare the frame.
  let format = repl_mode[format_type]
  let frame = format.header . a:selection . format.footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)
endfunction


function! s:Operate(type)

  " Save the contents of the register.
  let saved_reg = @@
  let saved_selection = &selection
  let &selection = "inclusive"

  " Ignore blockwise selection types.
  if a:type ==# "<C-v>" || a:type ==# 'block'
    return
  end

  " Choose the marks based on the mode.
  let is_visual = a:type ==# 'v' || a:type ==# 'V'
  let [m1, m2] = is_visual ? ['`<', '`>'] : ['`[', '`]']

  " Infer the selection type.
  let is_line = a:type ==# 'V' || a:type ==# 'line'
  let selection_type = is_line ? 'V' : 'v'

  " Select the text.
  execute 'normal! ' . m1 . selection_type . m2 . 'y'
  let selection = @@

  " Evaluates the selection.
  call <SID>EvalSelection(selection)

  " Restore the contents of the register.
  let @@ = saved_reg
  let &selection = saved_selection
endfunction


" Script mappings.
nnoremap <silent> <script>
      \ <Plug>ReplEval
      \ :set operatorfunc=<SID>Operate<CR>g@
vnoremap <silent> <script>
      \ <Plug>ReplEval
      \ :<C-u>call <SID>Operate(visualmode())<CR>

" Default mappings.
if !hasmapto('<Plug>ReplEval')
  nmap <leader>re <Plug>ReplEval
  vmap <leader>re <Plug>ReplEval
end

