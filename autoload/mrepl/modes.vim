" Encapsulate the REPL mode registry.
if !exists('s:repl_modes')
  let s:repl_modes = {}
end


" Returns the list of REPL mode names.
function! mrepl#modes#List()
  return copy(keys(s:repl_modes))
endfunction


" Returns the REPL mode by name.
function! mrepl#modes#Get(mode)
  return copy(s:repl_modes[a:mode])
endfunction


" Checks if the REPL mode exists by name.
function! mrepl#modes#Exists(mode)
  return has_key(s:repl_modes, a:mode)
endfunction


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

