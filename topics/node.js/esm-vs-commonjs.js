// CommonJS Modules
// - Legacy module system inspired by Microsoft AMD API
// - Available in Node.js since beginning
// - Can be used in Node.js and browsers
// - Depends on Node.js, npm
// - Perf: modules are loaded & processed synchronously, could get slow
// - `require` syntax affords more flexibility, can be nested in if/else
//    statements, etc but ES imports are only valid at top of file

// Export from strOpts.js
exports.removeSpace = (str) => str.removeSpace();
exports.nextLine = ‘\n’;
exports.singleWildCard = ‘?’;
exports.multiWildCard = ‘*’;

// Import to consumer.js
const stringOpsModule= require('stringOps.js');
stringOpsModule.removeSpace('This is a test for whitespaces.');

// or
const { nextLine, singleWildCard, multiWildCard } = require('./stringOps.js');

// ES Modules
// - Newer module system developed by Google
// - Easier route to writing isomorphic JavaScript (runs in browser or server)
// - Node.js didn't support until v13.2.0
// - ES modules do not have any dependencies other than the module loader itself
// - ES Modules are defined using a variety of import and export statements, but
//   Node.js uses ES modules format if file extension for module is `.mjs` or if
//   module's nearest parent folder has { "type": "module" } in its package.json
// - Node.js lets you import CommonJS modules from ES Modules
// - Is asynchronous and more performant

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

// You can define a default export with the default keyword:
export default function myLogger() {
  console.log(myNumbers, pets);
}

// Import all exported members
import * as Utils from 'app.js';
// Access members with dot notation:
Utils.myLogger();

// Import the default member by giving it a name of your choice, ex: Logger
import Logger from 'app.js';

// Import non-default members on top of the default one
import Logger, { Alligator, myNumbers } from 'app.js';
