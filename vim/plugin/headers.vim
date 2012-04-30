
if exists("loaded_headers_plugin") || exists("g:headers_stop") || &cp
  finish
endif

if !exists('g_headers_authors')
  let g:g_headers_authors = $GIT_COMMITTER_NAME
  if g:g_headers_authors == ""
    let g:g_headers_authors = "John Do"
  endif
endif

if !exists('g_header_email_author')
  let g:g_header_email_author = $GIT_COMMITTER_EMAIL
  if  g:g_header_email_author == ""
    let g:g_header_email_author = "jd@none.com"
  endif
endif

if !exists('g_header_copyright')
  let g:g_header_copyright = ""
endif

let g:g_header_add_vim_format = 1

if !exists('g_header_cpp_namespace')
  let g:g_header_cpp_namespace = "Ktk"
endif

if exists('g_header_add_vim_format')
  let g:add_vim_format = 1
  if !exists('vim_format')
    let g:vim_format = "set et ts=2 sts=2 sw=2"
  endif
else
  let g:add_vim_format = 0
endif

if exists('g_header_add_emacs_format')
  let g:add_emacs_format = 1
  if !exists('emacs_format')
    let g:vim_format = ""
  endif
else
  let g:add_emacs_format = 0
endif

let g:login = $USER

function <SID>headers_generate_header(first_line, comment_begin, comment_middle, comment_end, filetype)
  if a:first_line != ""
    call append(line(".") - 1, a:first_line)
  endif
  call append(line(".") - 1, a:comment_begin  )
  call append(line(".") - 1, a:comment_middle . " \\file " . expand("%:t") )
  call append(line(".") - 1, a:comment_middle . " \\author " . g:g_headers_authors . " <" . g:g_header_email_author . ">" )
  call append(line(".") - 1, a:comment_middle . " \\version 0.0.1")
  call append(line(".") - 1, a:comment_middle . " \\brief")
  call append(line(".") - 1, a:comment_middle . "")
  call append(line(".") - 1, a:comment_middle . "============================================================================")
  call append(line(".") - 1, a:comment_middle . " Created  on : " . strftime("%Y-%m-%d %H:%M:%S") . " by " . g:login . " on " . system("uname -n | tr -d '\n'"))
  call append(line(".") - 1, a:comment_middle . " Last update : " . strftime("%Y-%m-%d %H:%M:%S") . " by " . g:login . " on " . system("uname -n | tr -d '\n'"))
  if g:g_header_copyright != ""
    call append(line(".") - 1, a:comment_middle . " " . g:g_header_copyright)
  endif
  call append(line(".") - 1, a:comment_middle . "")
  call append(line(".") - 1, a:comment_middle . " Description")
  call append(line(".") - 1, a:comment_end )
  call append(line(".") - 1, "")

  if g:add_emacs_format == 1
    call append(line("."), a:comment_begin . " " . g:emacs_format . " " . a:comment_end )
  endif
  if g:add_vim_format == 1
    call append(line("."), a:comment_begin . " vim:" . g:vim_format . " ft=". a:filetype . ": " . a:comment_end )
  endif
  if g:add_emacs_format == 1 || g:add_vim_format == 1
    call append(line("."), "")
  endif
endfunction

function <SID>headers_update(comment_middle)
  let s:pattern = a:comment_middle . ' Last update : '
  let s:modified = a:comment_middle . ' Last update : ' . strftime("%Y-%m-%d %H:%M:%S") . " by " . g:login . " on " . system("uname -n | tr -d '\n'") 
  if match (getline(8), s:pattern) != -1
    call setline (8, s:modified)
  elseif match (getline(9), s:pattern) != -1
    call setline (9, s:modified)
  elseif match (getline(10), s:pattern) != -1
    call setline (10, s:modified)
  elseif match (getline(11), s:pattern) != -1
    call setline (11, s:modified)
  elseif match (getline(12), s:pattern) != -1
    call setline (12, s:modified)
  endif
endfunction

function <SID>toUpper(filename)
  let a = toupper(substitute(a:filename, "\\.", "_", "g"))
  return a
endfunction

function! Headers_insert_c()
  mark d
  let s:first_line = "/* -*-c++-*- */"
  let s:comment_begin  = "/**"
  let s:comment_middle = " * "
  let s:comment_end    = " */"
  let s:ft = "cpp"
  call <SID>headers_generate_header(s:first_line, s:comment_begin, s:comment_middle, s:comment_end, s:ft)
  if expand("%:e") == "h" || expand("%:e") == "hpp" || expand("%:e") == "hxx"
    let s:filename = <SID>toUpper(expand("%:t"))
    call append(line(".")-1 , "#ifndef __" . s:filename . "__")
    call append(line(".")-1 , "# define __" . s:filename . "__")
    call append(line(".")-1 , ""  )
    call append(line(".")-1 , "\/* ---------------------------- included header files ---------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- global definitions ------------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- global macros ------------------------------ *\/" )
    call append(line(".")-1 , "")
    if exists('g:g_header_cpp_namespace')
      call append(line(".") - 1, "namespace " . g:g_header_cpp_namespace)
      call append(line(".") - 1, "{")
    endif
    call append(line(".")-1 , "\/* ---------------------------- forward declarations ----------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- type definitions --------------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- exported variables (globals) --------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- interface functions ------------------------ *\/" )
    call append(line(".")-1 , "")
    call append(line(".") , "#endif /* !__" . s:filename . "__ */"  )
    unlet s:filename
  elseif match(expand("%:e"), "c") != -1
    call append(line(".")-1 , "\/* ---------------------------- included header files ---------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1, '#include "' . substitute(expand("%:t"), "\\.c", ".h", "g") . '"')
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- local macros ------------------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- imports ------------------------------------ *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- included code files ------------------------ *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- local types -------------------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- forward declarations ----------------------- *\/" )
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- local variables ---------------------------- *\/")
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- exported variables (globals) --------------- *\/")
    call append(line(".")-1 , "")
    call append(line(".")-1 , "\/* ---------------------------- local functions ---------------------------- *\/")
    call append(line(".")-1 , "")
    if exists('g:g_header_cpp_namespace')
      call append(line(".") - 1, "namespace " . g:g_header_cpp_namespace)
      call append(line(".") - 1, "{")
    endif
  endif
  if exists('g:g_header_cpp_namespace')
    call append(line(".")    , "")
    call append(line(".")    , "}")
  endif
endfunction

function! Headers_insert_py()
  let s:first_line = "#!" . system ("which python | tr -d '\n'")
  let s:comment_begin  = '"""'
  let s:comment_middle = '   '
  let s:comment_end    = '"""'
  let s:ft = "python"
  call <SID>headers_generate_header(s:first_line, s:comment_begin, s:comment_middle, s:comment_end, s:ft)
  call append(line(".")-1, "import sys")
  call append(line(".")-1, "")
  call append(line(".")-1, "def main(argv):")
  call append(line(".")-1, "  \"\"\"The Main Function\"\"\"")
  call append(line("."), "  main(sys.argv)")
  call append(line("."), "if __name__ == '__main__':")
  call append(line("."), "")
  call append(line("."), "  sys.exit(0)")
endfunction

function! Headers_insert_sh()
  let s:first_line = "#!" . system ("which sh | tr -d '\n'")
  let s:comment_begin  = '###'
  let s:comment_middle = '#  '
  let s:comment_end    = '###'
  let s:ft = "sh"
  call <SID>headers_generate_header(s:first_line, s:comment_begin, s:comment_middle, s:comment_end, s:ft)
  "call append(line(".")-1, "if __name__ == '__main__':")
  "call append(line(".")-1, "  return 0")
endfunction

function! Headers_insert_vim()
  let s:first_line = ""
  let s:comment_begin  = '"'
  let s:comment_middle = '"'
  let s:comment_end    = '"'
  let s:ft = "vim"
  call <SID>headers_generate_header(s:first_line, s:comment_begin, s:comment_middle, s:comment_end, s:ft)
endfunction


autocmd BufNewFile *.c,*.h,*.cpp,*.hpp,*.cxx,*.hxx call Headers_insert_c()
autocmd BufWritePre *.c,*.h,*.cpp,*.hpp,*.cxx,*.hxx call <SID>headers_update(' * ')

autocmd BufNewFile *.py call Headers_insert_py()
autocmd BufWritePre *.py call <SID>headers_update('   ')

autocmd BufNewFile *.sh call Headers_insert_sh()
autocmd BufWritePre *.sh call <SID>headers_update('#  ')

autocmd BufNewFile *.vim call Headers_insert_vim()
autocmd BufWritePre *.vim call <SID>headers_update('"')

let loaded_headers_plugin = 1

