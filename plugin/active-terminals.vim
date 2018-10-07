" Track the active terminals.
if !exists('s:terminals')
  let s:terminals = {}
end


" Returns the list of buffer names of active terminals.
function! ActiveTerminalsList()
  return map(values(s:terminals), {k, v -> v.bufname}) 
endfunction


function! s:Add(term_bufname)

  " Get the terminal attributes.
  let term_bufnr = bufnr(a:term_bufname) 

  " Fail if the buffer does not exist.
  if term_bufnr == -1
    echoerr "Failed to add terminal to the list. "
          \ . "The buffer does not exist."
    return
  end

  let term_channel_id = &channel

  " Fail if the terminal is not open.
  if !term_channel_id
    echoerr "Failed to add terminal to the list. There is no channel."
    return
  end

  " Add the terminal to the regstry.
  let s:terminals[term_bufnr] = {}
  let s:terminals[term_bufnr].channel_id = term_channel_id
  let s:terminals[term_bufnr].bufname = a:term_bufname
endfunction


function! s:Remove(term_bufname)

  " Get the buffer number of the terminal that closed.
  let term_bufnr = bufnr(a:term_bufname) 

  " Fail if the buffer does not exist.
  if term_bufnr == -1
    echoerr "Failed to add terminal to the list. "
          \ . "The buffer does not exist."
    return
  end

  " Remove the closed terminal.
  call remove(s:terminals, term_bufnr)
endfunction


" Listen for terminals that are opened and closed.
augroup active_terminals_listeners
  autocmd!

  autocmd TermOpen * call <SID>Add(expand('<afile>'))
  autocmd TermClose * call <SID>Remove(expand('<afile>'))
augroup END

