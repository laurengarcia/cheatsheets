// Async-Await are just syntax sugar for Promises

// Async keyword
// just means the function always returns a promise
// even if a fn actually returns a non-promise value, prepending `async`
// tells js to automatically wrap value in a resolved promise
async function f() {
  return 1;
}
f().then(console.log); // 1

// Await keyword
// works inside async fns, AND at the top level of ES modules (ESM)
// ex: .mjs or "type":"module" that uses import syntax
// But, top-level await = SyntaxError in CommonJS (aka require syntax)
let value = await promise;

// fn execution pauses at the `await`, resumes when promise settles
async function f() {
  let promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve("done!"), 1000)
  });
  let result = await promise; // wait till the promise resolves (*)
  console.log(result); // "done!"
}
f();

// Execution order
// code BEFORE the first await runs synchronously, as part of the caller.
// `await` ALWAYS pauses, even on a non-promise (await null).
// the rest of the fn resumes as a MICROTASK (beats timers in the js event loop).
async function g() {
  console.log('1');
  await null;
  console.log('2');
}
setTimeout(() => console.log('4'), 0);
g();
console.log('3');
// prints 1, 3, 2, 4

// .then chains
// .then always returns a NEW promise; each link gets what the one above RETURNED
// (no return -> undefined). Links run one at a time within the same
// microtask drain; a chain only pauses when a link RETURNS an unsettled promise.
// Trap: .then(() => setTimeout(...)) returns a Timeout object, not a promise,
// so the chain does NOT wait.

// Errors in chains: they only flow DOWN
// a rejection skips every .then below it until the first .catch;
// after .catch handles it, the chain continues normally.
// a .catch ABOVE the throw catches nothing.

// Unhandled rejections
// a rejection that reaches the end of a chain with no handler:
//   Node 15+ -> treated like an uncaught exception: crash, exit code 1
//   Node <=14 -> just an UnhandledPromiseRejectionWarning
// stopgap flag: --unhandled-rejections=warn   (fix the real bug)
// visibility:   process.on('unhandledRejection', ...)

// Floating promises
// try/catch only catches promises you AWAIT
async function save() {
  try {
    writeToDb(); // BUG: not awaited -> try exits, rejection crashes later
    // await writeToDb(); // The FIX
  } catch (err) {
    /* never reached */
  }
}
// lint rule: @typescript-eslint/no-floating-promises
// calling async from a non-async fn: use .then() AND .catch(), or it floats

// return vs return await inside try
// return writeToDb();        -> rejection skips THIS catch, goes to the caller
// return await writeToDb();  -> THIS catch handles it
// (return await is NOT redundant inside try/catch)

// Sequential vs parallel
// await in a loop = one at a time (200 x 100ms = 20s)
// Promise.all(items.map(fn)) = all at once (risk: 429 rate limits,
// too many sockets / EMFILE, memory spikes)
// in between = limited concurrency:
import pLimit from 'p-limit';
const limit = pLimit(10);
await Promise.all(items.map(x => limit(() => fn(x))));   // ~2s, max 10 in flight
// Promise.all fails fast: one rejection -> you lose ALL results
// (the rest keep running; their results are discarded)
// for batches where partial success is fine, use Promise.allSettled

// Class methods: just add `async`
class Waiter {
  async wait() {
    return await Promise.resolve(1);
  }
}
new Waiter()
  .wait()
  .then(console.log); // 1

// Error handling
// Two approaches:
//   - try/catch inside of async fn
//   - .catch() handler when calling async fn
async function f() {
  try {
    let response = await fetch('/no-user-here'); // relative urls only work in browser
    let user = await response.json();
  } catch(err) {
    // catches NETWORK errors from fetch and parse errors from .json().
    // a 404/500 does NOT throw here: check response.ok (see loadJson below)
    console.error(err);
  }
}
f();
// OR
async function f() {
  let response = await fetch('http://no-such-url');
}
// f() becomes a rejected promise
f().catch(console.error); // Node: TypeError: fetch failed (see err.cause)
                          // browser: TypeError: Failed to fetch

// Await accepts Thenables
class Thenable {
  constructor(num) {
    this.num = num;
  }
  then(resolve, reject) {
    console.log(resolve); // browser prints "function() { native code }""
    // resolve with this.num*2 after 1000ms
    setTimeout(() => resolve(this.num * 2), 1000); // (*)
  }
};
async function f() {
  // waits for 1 second, then result becomes 2
  let result = await new Thenable(1);
  console.log(result);
}
f();

// Call async from non-async
// just use .then() syntax instead of `await` keyword
async function wait() {
  await new Promise(resolve => setTimeout(resolve, 1000));
  return 10;
}
function f() {
  // shows 10 after 1 second
  wait()
    .then(result => console.log(result))
    .catch(console.error);   // otherwise a rejection is unhandled
}
f();

// Example fetch request
async function loadJson(url) { // (1)
  let response = await fetch(url); // (2)
  if (response.ok) { // covers all 2xx codes
    let json = await response.json(); // (3)
    return json;
  }
  throw new Error(response.status);
}
loadJson('no-such-user.json') // relative urls only work in browser
  .catch(console.log); // Error: 404 (4)


/* The 4 Promise combinators

Promise.all(ps)         // all fulfill  -> array of values
                        // ANY rejects  -> rejects immediately (fail fast)

Promise.allSettled(ps)  // never rejects; waits for every one ->
                        // [{ status: 'fulfilled', value },
                        // { status: 'rejected',  reason }, ...]

Promise.any(ps)         // first to FULFILL wins; rejects only if ALL fail
                        // e.g. try several mirrors, take the fastest success

Promise.race(ps)        // settles like the FIRST to settle (win or fail)
                        // e.g. a fetch request vs. a timeout
                        // the catch: race never cancels the loser — the fetch keeps running,
                        // and a pending setTimeout keeps the process alive unless cleared

In practice what you ship instead of .race for the fetch: */
const res = await fetch(url, { signal: AbortSignal.timeout(5000) });
// after 5s: the request is cancelled and fetch rejects with a TimeoutError

