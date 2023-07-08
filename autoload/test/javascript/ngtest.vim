if !exists('g:test#javascript#ngtest#file_pattern')
  let g:test#javascript#ngtest#file_pattern = '\v(test|spec)\.(js|jsx|ts|tsx)$'
endif

function! test#javascript#ngtest#test_file(file) abort
  if a:file =~# g:test#javascript#ngtest#file_pattern
      if exists('g:test#javascript#runner')
          return g:test#javascript#runner ==# 'ngtest'
      else
        return test#javascript#has_package('@angular/cli')
      endif
  endif
endfunction

function! test#javascript#ngtest#build_args(args) abort
  return a:args
endfunction

function! test#javascript#ngtest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = '--test-name-pattern '.shellescape(name, 1)
    endif
    return [name, '--test-path-pattern', a:position['file']]
  elseif a:type ==# 'file'
    return ['--test-path-pattern', a:position['file']]
  else
    return []
  endif
endfunction

function! test#javascript#ngtest#executable() abort
  return 'ng test'
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
