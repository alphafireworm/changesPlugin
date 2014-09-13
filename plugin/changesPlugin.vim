" ChangesPlugin.vim - Using Signs for indicating changed lines
" ---------------------------------------------------------------
" Version:  0.14
" Authors:  Christian Brabandt <cb@256bit.org>
" Last Change: Wed, 14 Aug 2013 22:10:39 +0200
" Script:  http://www.vim.org/scripts/script.php?script_id=3052
" License: VIM License
" Documentation: see :help changesPlugin.txt
" GetLatestVimScripts: 3052 14 :AutoInstall: ChangesPlugin.vim
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_changes")
 finish
endif
let g:loaded_changes       = 1
let s:keepcpo              = &cpo
set cpo&vim

" ------------------------------------------------------------------------------
" Public Interface: {{{1

" Define the Shortcuts:
com! -nargs=? -complete=file -bang EC	 EnableChanges<bang> <args>
com! DC	 DisableChanges
com! TCV ToggleChangeView
com! CC  ChangesCaption
com! CL  ChangesLinesOverview
com! CD  ChangesDiffMode
com! CT  ChangesStyleToggle
com! -bang CF ChangesFoldDiff<bang>

com! -nargs=? -complete=file -bang EnableChanges	call changes#EnableChanges(1, <q-bang>, <q-args>)
com! DisableChanges		call changes#CleanUp()
com! ToggleChangeView		call changes#TCV()
com! ChangesCaption		call changes#Output()
com! ChangesLinesOverview	call changes#EnableChanges(2, '')
com! ChangesDiffMode		call changes#EnableChanges(3, '')
com! ChangesStyleToggle		call changes#ToggleHiStyle()
com! -bang ChangesFoldDifferences call changes#FoldDifferences(<q-bang>)

if get(g:, 'changes_autocmd', 1)
    exe ":call changes#AuCmd(1)"
endif

if get(g:, 'changes_fixed_sign_column', 0)
    " Make sure, a dummy sign is placed
    exe ":call changes#Init()"
endif

" Mappings:  "{{{1
if !hasmapto("[h")
    map <expr> <silent> [h changes#MoveToNextChange(0, v:count1)
endif
if !hasmapto("]h")
    map <expr> <silent> ]h changes#MoveToNextChange(1, v:count1)
endif

" Text-object: A hunk
if !hasmapto("ah", 'v')
    vmap <expr> <silent> ah changes#CurrentHunk()
endif

if !hasmapto("ah", 'o')
    omap <silent> ah :norm Vah<cr>
endif

" In Insert mode, when <cr> is pressed, update the signs immediately
"
if !get(g:, 'changes_fast', 1)
    inoremap <expr> <cr> changes#MapCR()
endif
    
" =====================================================================
" Restoration And Modelines: {{{1
" vim: fdm=marker
let &cpo= s:keepcpo
unlet s:keepcpo

" Modeline
" vi:fdm=marker fdl=0
