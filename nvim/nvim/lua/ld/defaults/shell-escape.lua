local is_windows = require("ld.utils.functions").is_windows

if is_windows() then
  vim.cmd([[
    " Unescape 'shell' option in case that the user escaped it.
    function! UnescapeShell(shell)
      if (has('win32')) && a:shell =~# '^".\+"$'
        " de-quote
        return a:shell[1:-2]
      endif
      return a:shell
    endfunction

    " Escape 'shell' option
    function! EscapeShell(shell)
      if a:shell =~# ' '
        if  (has('win32'))
          " quote
          return '"' . a:shell . '"'
        endif
      endif
      return a:shell
    endfunction

    " If shell is supported, return 1. Else, return 0.
    function! SetShell(shell)
      let shell = UnescapeShell(a:shell)
      let tail = fnamemodify(shell, ':t')

      if tail =~# '^cmd\.exe'
        let &shellredir = '>%s 2>&1'
        if has('quickfix')
          let &shellpipe = &shellredir
        endif
        set shellquote= noshellslash

        let &shellcmdflag = '/s /c'
        let &shellxquote= '"'
        set shellxescape=
      elseif tail =~# '^powershell\.exe' || tail =~# '^pwsh'
        let &shellcmdflag = '-NoProfile -NoLogo -ExecutionPolicy RemoteSigned -Command'
        if has('win32') || has('win32unix')
          let &shellcmdflag = ' ' . &shellcmdflag
        endif
        set shellxescape= shellquote= noshellslash
        let &shellredir = '| Out-File -Encoding UTF8'
        if has('quickfix')
          let &shellpipe = '|'
        endif

        set shellxquote=
      elseif (tail =~# '^sh' || tail =~# '^bash' || tail =~# '^dash')
      \ && (!has('win32') || tail =~# '\.exe$')
        let &shellcmdflag = '-c'
        set shellquote= shellslash shellxescape=
        let &shellredir = '>%s 2>&1'
        if has('quickfix')
          let &shellpipe = '2>&1 | tee'
        endif

        let &shellxquote = (!has('nvim') && has('win32')) ? '"' : ''
      else
        echoerr a:shell 'is not supported in Vim' v:version
        return 0
      endif
      let &shell = EscapeShell(shell)
      return 1
    endfunction

    let s:shells = filter(
    \ has('win32') ? [escape($COMSPEC, '\'), 'cmd.exe'] :
    \ [$SHELL, 'sh'],
    \ 'executable(v:val)')
    for s:shell in s:shells
      if SetShell(s:shell)
        break
      endif
    endfor
    unlet s:shell s:shells
  ]])
end
