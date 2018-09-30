
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

" This script manages the following state per buffer.
"
" - *b:repl_channel_id* The channel id for the bound REPL buffer.
" - *b:repl_mode* The current REPL mode.

if !exists('b:repl_mode')
  let b:repl_mode = "term"
end

function! s:ReplBind(repl_bufname) abort

  " Get the buffer number of the REPL.
  let repl_buf_nr = bufnr(a:repl_bufname)

  " Get the channel of the REPL.
  execute 'b' . repl_buf_nr
  let repl_channel_id = &channel
  execute 'b#'

  if repl_channel_id == 0
    echoerr 'Failed to bind to a terminal. '
          \ . 'The selected buffer is not a terminal.'
    return
  end

  " Bind the REPL to the source buffer.
  let b:repl_channel_id = repl_channel_id

endfunction

function! s:ReplSendLine(...) abort

  if !exists('b:repl_channel_id')
    echoerr 'Failed to send line to the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind <repl_bufname> to bind the terminal.'
    return
  end

  " Get the current REPL mode.
  let repl_mode = get(s:repl_modes, b:repl_mode, 'term')

  " Get the current line from the source buffer.
  let payload = getline(line('.'))

  " Prepare the frame.
  let frame = repl_mode.line.header . payload . repl_mode.line.footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)

endfunction

function! s:ReplSendBlock(...) abort range

  if !exists('b:repl_channel_id')
    echoerr 'Failed to send block to the terminal. '
          \ . 'The terminal is not bound. '
          \ . 'Use ReplBind <repl_bufname> to bind the terminal.'
    return
  end

  " Get the current REPL mode.
  let repl_mode = get(s:repl_modes, b:repl_mode, 'term')

  " Get the visually selected lines in the source buffer.
  let lines = getline(a:firstline, a:lastline)
  let payload = join(lines, "\n") . "\n"

  " Prepare the frame.
  let frame = repl_mode.block.header . payload . repl_mode.block.footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)

endfunction

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

" Binds a REPL to the current buffer by the buffer name of the REPL.
command! -nargs=1 -complete=buffer ReplBind
      \ call <SID>ReplBind(<q-args>)

" Sends a line to the bound REPL.
command! ReplSendLine
      \ call <SID>ReplSendLine()

" Sends a block to the bound REPL.
command! -range ReplSendBlock
      \ <line1>,<line2>call <SID>ReplSendBlock()

" Switches the REPL mode.
command! -nargs=1 ReplSwitchMode
      \ call <SID>ReplSwitch(<q-args>)

" Default mappings.
nnoremap <silent> <buffer> <leader>e :ReplSendLine<CR>
vnoremap <silent> <buffer> <leader>e :ReplSendBlock<CR>

