" Encapsulate the terminal registry within the script.
if !exists('s:registry')
  let s:registry = {}
end

function! s:TerminalRegistryAdd()

  " Get the terminal attributes.
  let term_bufnr = bufnr('%')
  let term_bufname = bufname('%')
  let term_channel_id = &channel

  " Fail if the terminal is not open.
  if !term_channel_id
    echoerr "Failed to add terminal to the registry. There is no channel."
    return
  end

  " Add the terminal to the regstry.
  let s:registry[term_bufnr] = {}
  let s:registry[term_bufnr].channel_id = term_channel_id
  let s:registry[term_bufnr].bufname = term_bufname
endfunction

function! s:TerminalRegistryRemove()

  " Get the buffer number of the terminal that closed.
  let term_bufnr = bufnr('%') 

  " Remove the closed terminal.
  call remove(s:registry, term_bufnr)
endfunction

function! TerminalRegistryListNumbers()

  " Return the list of buffer numbers of terminals in the registry.
  return keys(s:registry)
endfunction

function! TerminalRegistryListNames()

  " Return the list of buffer names of terminals in the registry.
  return map(values(s:registry), {k, v -> v.bufname}) 
endfunction


function! TerminalRegistryGetChannelId(term_bufnr)

  " Fail if the terminal buffer number is not in the registry.
  if !has_key(s:registry, a:term_bufnr)
    echoerr "Failed to get the channel id from the registry. "
          \ . "Invalid term_bufnr=" . a:term_bufnr
    return
  end

  " Get the channel id of the given terminal buffer number.
  s:registry[a:term_bufnr]
endfunction


" Listen for terminals that are opened and closed.
augroup terminal_registry_listeners
  autocmd!

  autocmd TermOpen * call <SID>TerminalRegistryAdd()
  autocmd TermClose * call <SID>TerminalRegistryRemove()
augroup END

