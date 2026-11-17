# Module Resolution

When you write `require('something')`, Node has to turn that string into a file on disk.
Module resolution is the set of rules it uses to find that file:

'node:fs', 'fs'         CORE module    -> built into Node, always wins
'./util', '../lib/x'    RELATIVE path  -> a file, relative to THIS file
'lodash', '@scope/pkg'  BARE name      -> a package, searched in node_modules

Some built-ins are node:-ONLY (node:test, node:sqlite, node:sea).
require('test') without the prefix loads an npm package named "test".
Always use the node: prefix.

For `require('lodash')` called from /home/app/src/routes/index.js, Node checks in order:
- /home/app/src/routes/node_modules/lodash
- /home/app/src/node_modules/lodash
- /home/app/node_modules/lodash          <- usually found here
- /home/node_modules/lodash
- /node_modules/lodash

It stops at the first match. If none of those exist, you get Error: Cannot find module 'lodash'.
Nearest copy of the package wins.
```
app/
├── index.js                    require('lodash')  -> 4.17.21
└── node_modules/
    ├── lodash/                 v4.17.21
    └── express/
        ├── index.js            require('lodash')  -> 4.17.15 (its own copy is nearer)
        └── node_modules/
            └── lodash/         v4.17.15
```
Both versions run side by side in the same process.


## Next layer: inside the package folder:
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
- if a package has neither "main" nor "exports", Node falls back to index.js.


## Hoisting & phantom dependencies

npm v3+ (2015) flattens: non-conflicting deps get HOISTED to the top-level node_modules (unrelated to JS variable hoisting).
Phantom dependency: your code requires a package you never declared, and it only works because some other dep's copy was hoisted.

- Breaks when that other dep drops it -> `Error: Cannot find module 'debug'` (code MODULE_NOT_FOUND; the "Require stack" shows which of YOUR files)
- Shows up when the updated package-lock.json is committed: fresh installs (npm ci) break; devs with a stale node_modules say "works on my machine"
- Fix: add it to your own package.json
- Prevent: lint rule n/no-extraneous-require; pnpm doesn't flatten, so phantoms fail immediately
