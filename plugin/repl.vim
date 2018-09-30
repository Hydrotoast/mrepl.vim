" This script manages the following state per buffer.
"
" - *b:repl_channel_id* The channel id for the bound REPL buffer.
"
" The following options are available to configure how lines and blocks are
" sent to a terminal.
"
" - *b:repl_line_header* The header for a line frame.
" - *b:repl_line_footer* The footer for a line frame.
" - *b:repl_block_header* The header for a block frame.
" - *b:repl_block_footer* The footer for a block frame.

" The default frame configuration for terminals.

let b:repl_line_header = ''
let b:repl_line_footer = "\n"
let b:repl_block_header = ''
let b:repl_block_footer = "\n"

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

  " The optional header for the frame to send.
  let header = get(a:, 1, '')

  " The optional footer for the frame to send.
  let footer = get(a:, 2, '')

  " Get the current line from the source buffer.
  let payload = getline(line('.'))

  " Prepare the frame.
  let frame = b:repl_line_header . payload . b:repl_line_footer 

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

  " Get the visually selected lines in the source buffer.
  let lines = getline(a:firstline, a:lastline)
  let payload = join(lines, "\n") . "\n"

  " Prepare the frame.
  let frame = b:repl_block_header . payload . b:repl_block_footer

  " Send the frame to the REPL.
  call chansend(b:repl_channel_id, frame)

endfunction

" Binds a REPL to the current buffer by the buffer name of the REPL.
command -nargs=1 -complete=buffer ReplBind
      \ call <SID>ReplBind(<q-args>)

" Sends a line to the bound REPL.
command ReplSendLine
      \ call <SID>ReplSendLine()

" Sends a block to the bound REPL.
command -range ReplSendBlock
      \ <line1>,<line2>call <SID>ReplSendBlock()

" Default mappings.
nnoremap <silent> <buffer> <leader>e :ReplSendLine<CR>
vnoremap <silent> <buffer> <leader>e :ReplSendBlock<CR>

