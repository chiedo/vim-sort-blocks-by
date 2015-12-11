"Vim Sort Blocks By

" Converts Selected pixels to ems vice versa.
" - sorter: The word to sort by
" - start_line: The first line to search.
" - end_line: The last line to search
function! VimSortBlocksBy(sorter,start_line, end_line)
  " Execute the command to search for the word under the cursor

  if exists(a:start_line)
    let start_line= "."
  else
    let start_line= a:start_line
  endif

  if exists(a:end_line)
      let end_line= "."
  else
    let end_line= a:end_line
  endif

  " We will use this to recreate our newlines later
  let newline_place_holder= "YOUR_FAILURE_IS_NOW_COMPLETE"
  "We will use this to find the end of the data we are sorting as we reformat
  let end_pointer= "THE_FORCE_IS_STRONG_WITH_THIS_ONE"

  " Good practice
  execute "normal! *"

  " Set a pointer at the end of the selection that we can reference later
  silent execute end_line . "s/".'\n'."/".'\r\r'.end_pointer."/g"

  " Replace all newlines with our placeholder
  silent execute start_line . "," . end_line ."s/".'\n'."/". newline_place_holder."/g"

  " Separate our one line of text to multiple lines starting with each sorter
  silent execute start_line . "s/".a:sorter."/".'\r'. a:sorter."/g"

  " Get the last line of the data we are manipulating based on the pointer we
  " set
  let tmp_last_line = search(end_pointer) - 1

  "Get rid of the last holder reference  as we will not need it
  silent execute start_line . "," . tmp_last_line ."s/".'.*\zs'.newline_place_holder."//g"

  " Sort our selection
  silent execute start_line . "," . tmp_last_line ."sort"

  " Remove our newline place holders and put back the newlines
  silent execute start_line . "," . tmp_last_line ."s/".newline_place_holder."/".'\r'."/g"

  " Get a couple more pointers
  let tmp_last_line = search(end_pointer)
  let tmp_last_line_2 = tmp_last_line - 1

  " Reformat our selection
  silent execute start_line . "," . tmp_last_line ."normal! =="

  " Remove our end pointer
  silent execute tmp_last_line . "s/".end_pointer."/".'\r'."/g"
  silent execute tmp_last_line_2 . "s/".'\n'."//g"

  " Get rid of the space before the first line
  silent execute start_line . "s/".'\n'."//g"

  "Remove any trailing white spaces that appeared
  silent execute start_line . "," . tmp_last_line ."s/".'\s\+$'."//g"

endfunction

"Available commands
command! -nargs=1 -range SortBlocksBy call VimSortBlocksBy(<f-args>,<line1>,<line2>)

