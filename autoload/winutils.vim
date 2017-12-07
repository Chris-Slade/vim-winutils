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

function! winutils#ShowWinInfo(bufname)
    let winids = win_findbuf(bufnr(a:bufname))
    if empty(winids)
        echoerr 'No windows found'
        return
    endif
    redraw
    echo printf('%3s %5s %5s', 'tab', 'winnr', 'winid')
    for winid in winids
        let tabwin = win_id2tabwin(winid)
        echo printf('%3d %5d %5d', tabwin[0], tabwin[1], winid)
    endfor
endfunction

function! s:MakeConfirmString(winids)
    let cs = [ '&Abort' ]
    for i in range(len(a:winids))
        let tabwin = win_id2tabwin(a:winids[i])
        call add(cs, printf(
\           '&%d Tab %d window %d (%d)',
\           i + 1, tabwin[0], tabwin[1], a:winids[i]
\       ))
    endfor
    return join(cs, "\n")
endfunction

function! winutils#GotoWin(bufname)
    let winids = win_findbuf(bufnr(a:bufname))
    if empty(winids)
        echoerr 'No windows found'
    elseif len(winids) == 1
        call win_gotoid(winids[0])
    else
        let confirmstring = s:MakeConfirmString(winids)
        let choice = confirm('Select a window', confirmstring, 0)
        if choice > 1
            call win_gotoid(winids[choice - 2])
        endif
    endif
endfunction
