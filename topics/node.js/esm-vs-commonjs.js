// Node has 2 module systems side by side, for historical reasons:

// |                | CommonJS (CJS)              | ES modules (ESM)
// |---             |---                          |---
// |syntax:         | require() / module.exports  | import / export
// |origin          | Node's own, 2009            | JS language standard, 2015
// |loading         | synchronous, at runtime     | parsed BEFORE running, async
// |top-level await | no                          | yes

// - ESM reads every import before any code runs, builds the whole module graph, and then executes it.
// - That’s what allows top-level await, and it’s why bundlers can remove unused code (“tree-shaking”).
// - Also means ESM can’t simply be loaded in the middle of a synchronous require()

// How Node decides which is which:
// .cjs  -> always CommonJS
// .mjs  -> always ESM
// .js   -> look at the NEAREST package.json:
//            "type": "module"   -> ESM
//            no "type" field    -> CommonJS (the default)

// Interop:
// - ESM importing CJS works. import x from './old.cjs' gives you its module.exports as the default export.
// - CJS requiring ESM was the long-standing problem.

// To import ESM to CJS
// In a CommonJS file, Node 18:
async function main() {
  const { default: fetch } = await import('node-fetch');   // assumes node-fetch v3+ which is ESM
  const res = await fetch('https://registry.npmjs.org/express');
}
main();
// Without await, import() returns a pending promise: default is undefined → TypeError: fetch is not a function”.

// More recently:
// - require() of ES modules now works in Node 22.12+ and 20.19+, enabled by default with no flag
// - You still get module.exports-style access, so for a default export it’s require('node-fetch').default
// - 1 exception: ES module that uses top-level await still can’t be loaded with require, because require has to finish synchronously. Fails with ERR_REQUIRE_ASYNC_MODULE

// ESM relative imports need the FULL file extension.
// CJS fills it in for you; ESM doesn't:
require('./utils')         // CJS: tries ./utils.js, ./utils.json, ./utils/index.js
import x from './utils'    // ESM: ERR_MODULE_NOT_FOUND. Must be './utils.js'

// __dirname / __filename don't exist in ESM
// This works in Node 20.11+ / 21.2+ (ESM only)
import.meta.dirname
import.meta.filename

// Older versions would use the long-hand version, now deprecated:
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const __filename = fileURLToPath(import.meta.url);
const __dirname  = path.dirname(__filename);



// CommonJS Modules

// - Available in Node.js since beginning
// - Legacy module system inspired by AMD RequireJS API
// - Can be used in Node.js and browsers with bundler (browserify, webpack)
// - Perf: modules are loaded & processed synchronously, could get slow
// - `require` syntax affords more flexibility, can be nested in if/else
//    statements, etc but ES imports are only valid at top of file

// Export from strOps.js
exports.removeSpace = (str) => str.replace(/\s/g, '');
exports.nextLine = '\n';
exports.singleWildCard = '?';
exports.multiWildCard = '*';

// Import to consumer.js
const stringOpsModule= require('./stringOps.js');
stringOpsModule.removeSpace('This is a test for whitespaces.');

// or
const { nextLine, singleWildCard, multiWildCard } = require('./stringOps.js');

// ES Modules
// - Newer module system developed by Google, standardized in ES2015.
// - Easier route to writing isomorphic JavaScript (runs in browser or server)
// - Node.js didn't support until v13.2.0 (without a flag; worked with --experimental-modules flag earlier)
// - ES modules do not have any dependencies other than the module loader itself
// - ES Modules are defined using a variety of import and export statements, but
//   Node.js uses ES modules format if file extension for module is `.mjs` or if
//   module's nearest parent folder has { "type": "module" } in its package.json
// - Node.js lets you import CommonJS modules from ES Modules
// - Is asynchronous

// Import using one of the following:
// - Relative specifiers:
import module1 from './module1.js';
import module2 from '../folder/module2.mjs';

// - Bare specifiers:
import lodash from 'lodash-es';
import intersection from 'lodash-es/intersection';

// - Absolute specifier:
import module from 'file:///usr/opt/module.js';

// ES Exports
export const myNumbers = [1, 2, 3, 4];
const animals = ['Panda', 'Bear', 'Eagle']; // Not available directly outside the module
export function myLogger() {
  console.log(myNumbers, animals);
}
export class Alligator {
   constructor() {
     // ...
   }
}

// Or you can export desired members in a single statement at the end of file:
export { myNumbers, myLogger, Alligator };

// Or you can define a default export with the default keyword:
export default function myLogger() {
  console.log(myNumbers, animals);
}

// Import all exported members
import * as Utils from './app.js';
// Access members with dot notation:
Utils.myLogger();

// Import the default member by giving it a name of your choice, ex: Logger
import Logger from './app.js';

// Import non-default members on top of the default one
import Logger, { Alligator, myNumbers } from './app.js';
