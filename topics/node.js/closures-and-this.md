# Closures and `this`

- Closures:  fixed where the function is WRITTEN.
- `this`:    decided where the function is CALLED (except arrows -> written).


## Closures

Closures give JS a private state without using classes.

When a function is created, it carries a backpack containing the variables that were in scope where it was born. Wherever the function goes later (passed into setTimeout, returned from another function, stored somewhere), it can still reach into that backpack.

The detail that matters: the backpack holds live references to the variables themselves, not snapshots of their values. If the variable changes after the function is created, the function sees the new value.

- `var` vs `let` in loops:
    `var` = ONE shared i for all callbacks -> 3,3,3
            (the loop exits only once i becomes 3; the callbacks run after)
    `let` = a NEW binding per iteration -> 0,1,2. (Old fix: IIFE.)
    ```js
    for (var i = 0; i < 3; i++) {
      setTimeout(() => console.log(i), 0);   // prints 3, 3, 3
    }
    for (let i = 0; i < 3; i++) {
      setTimeout(() => console.log(i), 0);   // prints 0, 1, 2
    }
    ```

- Private state works because each CALL of the outer function
  creates a new backpack (makeCounter: a and b don't share count).
  ```js
  function makeCounter() {
    let count = 0;
    return () => ++count;
  }

  const a = makeCounter();
  const b = makeCounter();
  a();
  a();
  console.log(a(), b()); // prints 3 1
  ```

- Closures keep their backpack alive -> memory leaks when a long-lived
  thing holds them (listeners added per request, uncleared intervals).
  ```js
  const handlers = []; // long-lived
  function onRequest(req) {
    const hugeBody = req.body; // say, 5MB
    handlers.push(() => {
      console.log('handled', req.id); // holds ALL of req (incl. req.body), forever
    });
  }
  // Fix: don't store per-request closures in long-lived places,
  // or just remove them when the request ends.
  ```

- Removing a listener needs the SAME function reference (===).
  emitter.off(evt, () => ...) with a new arrow silently removes nothing.
  ```js
  // BUG: two different function objects -> off() finds no match
  bus.on('update', (data) => res.write(data));
  res.on('close', () => bus.off('update', (data) => res.write(data)));

  // FIX: store it once, pass the same reference to both
  const onUpdate = (data) => res.write(data);
  bus.on('update', onUpdate);
  res.on('close', () => bus.off('update', onUpdate));
  ```

- EventEmitter allows duplicates; off() removes one copy per call.
  ```js
  const EventEmitter = require('node:events');   // ESM: import EventEmitter from 'node:events';
  const bus = new EventEmitter();

  const handler = (d) => console.log('got', d);
  bus.on('update', handler);
  bus.on('update', handler);    // allowed: now registered twice
  bus.off('update', handler);   // removes ONE copy
  console.log(bus.listenerCount('update'));   // 1
  ```


## `this`

Closures: fixed where the function is WRITTEN.
`this`:   decided where the function is CALLED (except arrows -> written).

HOW `this` IS DECIDED  (check in this order)

1. Arrow function?            -> lexical: `this` from where it was WRITTEN.
                                 Call site, call/apply/bind can't change it.
2. Called with `new`?         -> the newly created object
3. Bound with `.bind(x)`?     -> x, permanently (bind returns a fn for LATER)
4. `.call(x)` / `.apply(x)`?  -> x (apply = array of args. call/apply run NOW)
5. `obj.fn()`                 -> obj (left of the dot, at the CALL)
6. plain `fn()`               -> strict mode: `undefined`  |  sloppy: `globalThis`

Callbacks: whoever calls your function decides (3-6).
  `setTimeout` (Node)  -> the Timeout object
  `EventEmitter`       -> the emitter

Bug: passing a method as a callback loses `this`
```js
const user = {
  name: 'Lauren',
  greet() { console.log(`hi ${this.name}`); }
};
setTimeout(user.greet, 100);              // "hi undefined"  BUG: a property READ, not a call
setTimeout(user.greet.bind(user), 100);   // "hi Lauren"     fix 1: lock `this`
setTimeout(() => user.greet(), 100);      // "hi Lauren"     fix 2: you make the call
```

Arrow vs regular callback inside a method:
```js
const user = {
  name: 'Lauren',
  greetLater() {
    setTimeout(() => console.log(`hi ${this.name}`), 100);
  }
};
user.greetLater(); // "hi Lauren"
// arrow WRITTEN inside greetLater,
// where this === user

// same greetLater() method, with regular function callback:
setTimeout(function () { console.log(`hi ${this.name}`); }, 100);
// -> "hi undefined": its CALLER (the timer) decides -> Timeout object
```

Pitfall: arrow as an object method
```js
const user = {
  name: 'Lauren',
  greet: () => `hi ${this.name}`   // BUG: object braces aren't a scope,
};                                 // so `this` is the top level, not user
// use method shorthand: greet() { ... }
```
