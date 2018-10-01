" We keep a registry of REPL modes with state that is encapsulated by the
" script.

if !exists('s:repl_modes')
  let s:repl_modes = {}
end

function! s:ReplModeInit(mode)

  let s:repl_modes[a:mode] = {}
  let s:repl_modes[a:mode].line = {}
  let s:repl_modes[a:mode].block = {}
  let s:repl_modes[a:mode].line.header = ''
  let s:repl_modes[a:mode].line.footer = "\n"
  let s:repl_modes[a:mode].block.header = ''
  let s:repl_modes[a:mode].block.footer = "\n"

endfunction

function! s:ReplModeSetLine(mode, header, footer)

  let s:repl_modes[a:mode].line.header = a:header
  let s:repl_modes[a:mode].line.footer = a:footer

endfunction

function! s:ReplModeSetBlock(mode, header, footer)

  let s:repl_modes[a:mode].block.header = a:header
  let s:repl_modes[a:mode].block.footer = a:footer

endfunction

" Initialize the terminal REPL mode.
call <SID>ReplModeInit('term')

" Initialize the Scala REPL mode.
call <SID>ReplModeInit('scala')
call <SID>ReplModeSetBlock('scala', ":paste\n", nr2char(4))

" The current REPL mode.
if !exists('b:repl_mode')
  let b:repl_mode = "term"
end

function! s:ReplSwitch(mode) abort
  
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

function! s:ReplCompleteMode(A, P, L)

  " Return the available REPL modes.
  return ReplModeList()
endfunction

" Switches the REPL mode.
command! -nargs=1 -complete=customlist,<SID>ReplCompleteMode ReplSwitchMode
      \ call <SID>ReplSwitch(<q-args>)
