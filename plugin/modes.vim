" We keep a registry of REPL modes with state that is encapsulated by the
" script.
if !exists('s:repl_modes')
  let s:repl_modes = {}
end


function! s:InitMode(mode)

  let s:repl_modes[a:mode] = {}
  let s:repl_modes[a:mode].line = {}
  let s:repl_modes[a:mode].block = {}
  let s:repl_modes[a:mode].line.header = ''
  let s:repl_modes[a:mode].line.footer = "\n"
  let s:repl_modes[a:mode].block.header = ''
  let s:repl_modes[a:mode].block.footer = "\n"
endfunction


function! s:SetModeLine(mode, header, footer)

  let s:repl_modes[a:mode].line.header = a:header
  let s:repl_modes[a:mode].line.footer = a:footer
endfunction


function! s:SetModeBlock(mode, header, footer)

  let s:repl_modes[a:mode].block.header = a:header
  let s:repl_modes[a:mode].block.footer = a:footer
endfunction


" Initialize the terminal REPL mode.
if !has_key(s:repl_modes, 'term')
  call <SID>InitMode('term')
end

" Initialize the Scala REPL mode.
if !has_key(s:repl_modes, 'scala')
  call <SID>InitMode('scala')
  call <SID>SetModeBlock('scala', ":paste\n", nr2char(4))
end

" Initialize the Julia REPL mode.
if !has_key(s:repl_modes, 'julia')
  call <SID>InitMode('julia')
  call <SID>SetModeBlock('julia', '', '')
end


" The current REPL mode.
if !exists('b:repl_mode')
  let b:repl_mode = "term"
end


function! ReplModeList()

  " Return the list of REPL modes.
  return keys(s:repl_modes)
endfunction


function! ReplModeGet(mode)

  " Fail if the REPL mode does not exist.
  if !has_key(s:repl_modes, a:mode)
    echoerr 'Failed to get the REPL mode: ' . a:mode . '.'
          \ . 'The mode has not been registered.'
    return
  end

  " Return the REPL mode protocol.
  return s:repl_modes[a:mode]
endfunction


function! ReplModeGetCurrent()

  " Return the REPL mode protocol.
  return s:repl_modes[b:repl_mode]
endfunction


function! s:CompleteMode(A, P, L)

  " Return the available REPL modes.
  return ReplModeList()
endfunction


function! s:PromptMode()

  " Get the mode list.
  let mode_list = ReplModeList()

  " Create the inputlist prompt.
  let mode_list_prompt = map(copy(mode_list), {k, v -> (k + 1) . '. ' . v})

  " Prompt for a mode.
  echom "Choose a mode:"
  let choice = inputlist(mode_list_prompt)
  let n = len(mode_list)
  while choice == 0 || choice > n
    redraw!
    echo "Invalid mode. Choose a mode:"
    let choice = inputlist(mode_list_prompt)
  endwhile

  " Return the mode.
  return mode_list[choice - 1]
endfunction


function! s:SwitchMode(mode) abort
  
  if !exists('b:repl_channel_id')
    echoerr 'Failed to send block to the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind <repl_bufname> to bind the terminal.'
    return
  end

  if !has_key(s:repl_modes, a:mode)
    echoerr 'Failed to switch the REPL to ' . a:mode . '.'
          \ . 'The mode has not been registered.'
    return
  end

  let b:repl_mode = a:mode

endfunction



" Switches the REPL mode.
command! -nargs=1 -complete=customlist,<SID>CompleteMode
      \ ReplModeSwitch
      \ call <SID>SwitchMode(<q-args>)


" Script mappings.
noremap <unique> <silent> <script>
      \ <Plug>ReplModeSwitch
      \ :call <SID>SwitchMode(<SID>PromptMode())<CR>

" Default mappings.
if !hasmapto('<Plug>ReplModeSwitch')
  nmap <leader>rs <Plug>ReplModeSwitch
end

