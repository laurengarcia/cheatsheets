# Module Resolution

When you write `require('something')`, Node has to turn that string into a file on disk.
Module resolution is the set of rules it uses to find that file:

'node:fs', 'fs'         CORE module    -> built into Node, always wins
'./util', '../lib/x'    RELATIVE path  -> a file, relative to THIS file
'lodash', '@scope/pkg'  BARE name      -> a package, searched in node_modules

For `require('lodash')` called from /home/app/src/routes/index.js, Node checks in order:
- /home/app/src/routes/node_modules/lodash
- /home/app/src/node_modules/lodash
- /home/app/node_modules/lodash          <- usually found here
- /home/node_modules/lodash
- /node_modules/lodash

It stops at the first match. If none of those exist, you get Error: Cannot find module 'lodash'.
Nearest copy of the package wins.

Next layer: inside the package folder:
Once Node finds node_modules/lodash/, it still has to pick which file to load. It checks the package’s package.json:

- "main", the old way: one entry file, e.g. "main": "lib/index.js". Any other file is still reachable directly with require('pkg/lib/internal/helper.js').
- "exports" (Node 12.7+), the modern way: an explicit list of paths the package allows. Anything not listed is blocked, even though the file is sitting right there on disk:
```json
{
  "exports": {
    ".": "./lib/index.js",
    "./utils": "./lib/utils.js"
  }
}
```
