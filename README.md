# list
Tiny program to list files in a directory that i made for fun. Not necessarily an ls(1) clone.

## Installation
Dependencies: mlton (only tested with mosml and mlton)  
Compile with:
```sh
make install
```

## Usage
```
list [-h|-r|-p|-i|-f|-d] [path]
  -h   show help and exit
  -r   list directories recursively
  -p   print full file paths
  -f   list only files (exclude directories)
  -d   list only directories (exclude files)
  -i   show hidden files
```

And yes, `list -fd` excludes both files and directories. **It's not a bug, it's a feature**.

