function! winutils#GetBufState(mybufnr)
    let binfo = getbufinfo(a:mybufnr)[0]
    let state = ''
    if !binfo.listed
        let state .= 'u'
    endif
    if binfo.loaded
        if binfo.hidden
            let state .= 'h'
        else
            let state .= 'a'
        endif
    endif
    if !getbufvar(a:mybufnr, '&modifiable')
        let state .= '-'
    elseif getbufvar(a:mybufnr, '&readonly')
        let state .= '='
    endif
    if getbufvar(a:mybufnr, '&modified')
        let state .= '+'
    endif
    return state
endfunction

function! winutils#ListWindows()
    echo printf('%5s %5s %5s %5s %5s', 'tabnr', 'winnr', 'winid', 'bufnr', 'state')
    for mytab in range(1, tabpagenr('$'))
        for mywin in gettabinfo(mytab)[0].windows
            let winfo = getwininfo(mywin)[0]
            let binfo = getbufinfo(winfo.bufnr)[0]
            let bname = substitute(bufname(winfo.bufnr), '^\V' . expand('~'), '~', '')
            let state = winutils#GetBufState(winfo.bufnr)
            echo printf(
\               '%5d %5d %5d %5d %5s "%s" line %d',
\               mytab, winfo.winnr, winfo.winid,
\               winfo.bufnr, state, bname, binfo.lnum
\           )
        endfor
    endfor
endfunction
