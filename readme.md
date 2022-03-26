LuaJIT-Backend
==============

### Quickstart

```
$ mkdir helloworld && cd helloworld
$ git init
$ git submodule add git@github.com:LankyCyril/luajit-backend.git luajit-backend
$ git submodule update --init --recursive
$ mkdir src && echo 'print("Hello world!")' > src/main.lua
$ echo -e '_cwd=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
  $_cwd/luajit-backend/wrapper $_cwd/src/main.lua "$@"' > hello
$ ./hello
```


### Bundled interpreters and libraries

* The OpenResty branch of LuaJIT: https://github.com/openresty/luajit2
* Argparse: https://github.com/luarocks/argparse
* Effil: https://github.com/effil/effil
* Kahlua: https://github.com/LankyCyril/kahlua


### Options

* `./hello --rebuild-backend` (re)builds the LuaJIT backend and submodules.  
   If `-t` is specified (number of threads), interprets it as the number of GNU
   Make jobs.  
   The backend is also built unconditionally on the very first run.
* `./hello --repl` ignores all other options and runs the LuaJIT repl.
* All other options (including the aforementioned `-t`) are passed to the Lua
  entrypoint script (`src/main.lua` in the quickstart example).
