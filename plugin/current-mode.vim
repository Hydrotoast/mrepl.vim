" The current REPL mode.
if !exists('b:repl_mode')
  let b:repl_mode = "term"
end


" Return the REPL mode protocol.
function! ReplCurrentModeGet()
  return ReplModesGet(b:repl_mode)
endfunction


function! s:CompleteMode(A, P, L)

  " Return the available REPL modes.
  return ReplModesList()
endfunction


function! s:PromptMode()

  " Get the mode list.
  let mode_list = ReplModesList()

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

  if !ReplModesExists(a:mode)
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

