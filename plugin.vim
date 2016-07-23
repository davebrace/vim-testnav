if exists('g:vim_test_nav_loaded') || &compatible
  finish
endif
let g:vim_test_nav_loaded = 1

function! s:RubyWarning() abort
  echohl WarningMsg
  echo 'test-nav requires Vim to be compiled with Ruby support'
  echohl none
endfunction

function! testnav#ToggleTestFile() abort
  if has('ruby')
    ruby $test_nav.toggle()
  endif
endfunction
