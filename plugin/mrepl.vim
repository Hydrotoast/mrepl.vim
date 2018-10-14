
function! s:CompleteTerminalNames(A, P, L)

  " Retrieve the terminal names from the registry.
  return ActiveTerminalsList()
endfunction


function! s:PromptTerminalName(terminal_list)

  " Create the inputlist prompt.
  let terminal_list_prompt = map(a:terminal_list, {k, v -> (k + 1) . '. ' . v})

  " Prompt for a terminal.
  echom "Choose a terminal:"
  let choice = inputlist(terminal_list_prompt)
  let n = len(a:terminal_list)
  while choice == 0 || choice > n
    redraw!
    echo "Invalid terminal. Choose a terminal:"
    let choice = inputlist(terminal_list_prompt)
  endwhile

  " Return the terminal.
  return a:terminal_list[choice - 1]
endfunction


function! s:ChooseTerminal()

  let terminal_list = ActiveTerminalsList()

  " Nothing to do if there are no terminals.
  if empty(terminal_list)
    echo 'No active terminals to bind to'
    return
  end

  " Choose the trivial terminal if it exists.
  if len(terminal_list) == 1
    let choice = terminal_list[0]
  else
    let choice = <SID>PromptTerminalName(terminal_list)
  end

  echo 'Bound to terminal: ' . choice
  return choice
endfunction


" Binds a REPL to the current buffer by the buffer name of the REPL.
command! -nargs=1 -complete=customlist,<SID>CompleteTerminalNames
      \ ReplBind
      \ call mrepl#buffer#Bind(<q-args>)

" Script mappings.
noremap <silent> <script> <Plug>ReplBind
      \ :call mrepl#buffer#Bind(<SID>ChooseTerminal())<CR>

" Default mappings.
if !hasmapto('<Plug>ReplBind')
  nmap <leader>rb <Plug>ReplBind
end

