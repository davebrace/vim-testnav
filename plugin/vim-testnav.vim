if exists('g:vim_test_nav_loaded') || &compatible
  finish
endif
let g:vim_test_nav_loaded = 1

function! s:RubyWarning() abort
  echohl WarningMsg
  echo 'test-nav requires Vim to be compiled with Ruby support'
  echohl none
endfunction

ruby $LOAD_PATH.unshift File.join(File.dirname(Vim.evaluate('expand("<sfile>")')), '../ruby')
ruby require test_nav

function! testnav#ToggleTestFile() abort
  if has('ruby')
    ruby $test_nav.toggle()
  endif
endfunction

nnoremap <leader>m testnav#ToggleTestFile()
