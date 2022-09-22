# findPatternInFiles3

A Haskell wrapper of the 'grep' command, allowing HTML output (thanks to 'aha').

```
$ findPattern --help
findPattern -- based on 'grep' and 'aha'

Usage: findPattern FILETYPE PATTERN [-w|--wholeword] [-i|--ignorecase] 
                   [-d|--depth DEPTH] [-m|--html]
  Find files containing a pattern.

Available options:
  -h,--help                Show this help text
  FILETYPE                 Type of the files to search in
  PATTERN                  The pattern to search
  -w,--wholeword           Match whole word
  -i,--ignorecase          Ignore case
  -d,--depth DEPTH         Depth of the search (0: current directory)
  -m,--html                HTML output
```
