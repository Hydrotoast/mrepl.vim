" The command to start a Scala repl.
let g:scala_repl_command = 'scala'

" Initialize the job id
let s:repl_job_id = -2

" The name of the REPL buffer.
let s:repl_bufname = '__SCALA_REPL__'

function s:GetOrCreateReplBuffer()

  let repl_buf_nr = bufnr(s:repl_bufname)

  " Get the existing REPL buffer number.
  if repl_buf_nr > 0
    return repl_buf_nr

  " Create a new REPL buffer.
  elseif repl_buf_nr == -1
    belowright vnew
    let s:repl_job_id = termopen(g:scala_repl_command)
    execute 'file ' . s:repl_bufname
    return bufnr('%')
  return
endfunction

function s:OpenReplWindow()

  " Get the buffer number of the REPL buffer
  let repl_buf_nr = s:GetOrCreateReplBuffer()

  " Try to get the window number of the buffer.
  let repl_win_nr = bufwinnr(repl_buf_nr)

  " Open the buffer in a new split if a window is not already open.
  if repl_win_nr == -1 && repl_buf_nr > 0
    execute 'vert belowright sb ' . repl_buf_nr
  endif
endfunction

function s:SendSelectedLinesToRepl(visual) range

  " Open an REPL window if it does not exist.
  if bufexists(s:repl_bufname) == 0
    call s:OpenReplWindow()
  endif

  " Send many lines using paste mode.
  if a:visual
    normal! gv

    " Resolve the lines to send.
    let firstline = line("'<")
    let lastline = line("'>")
    let lines = getline(firstline, lastline)

    " Send the lines in a paste-block.
    let block = join(lines, "\n") . "\n"
    let msg = ":paste\n" . block . nr2char(4)
    call chansend(s:repl_job_id, msg)

  " Send one line.
  else
    let msg = getline(line('.')) . "\n"
    call chansend(s:repl_job_id, msg)
  endif
endfunction

nnoremap <silent> <buffer> <localleader>w :call <SID>OpenReplWindow()<CR>

nnoremap <silent> <buffer> <localleader>e :call <SID>SendSelectedLinesToRepl(0)<CR>
vnoremap <silent> <buffer> <localleader>e :call <SID>SendSelectedLinesToRepl(1)<CR>

