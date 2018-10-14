function! s:CompleteMode(A, P, L)

  " Return the available REPL modes.
  return mrepl#modes#List()
endfunction


function! s:PromptMode()

  " Get the mode list.
  let mode_list = mrepl#modes#List()

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


" Switches the REPL mode.
command! -nargs=1 -complete=customlist,<SID>CompleteMode
      \ ReplModeSwitch
      \ call mrepl#buffer#SwitchMode(<q-args>)


" Script mappings.
noremap <silent> <script>
      \ <Plug>ReplModeSwitch
      \ :call mrepl#buffer#SwitchMode(<SID>PromptMode())<CR>

" Default mappings.
if !hasmapto('<Plug>ReplModeSwitch')
  nmap <leader>rs <Plug>ReplModeSwitch
end

