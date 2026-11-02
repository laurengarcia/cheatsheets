# Node.js Threads

## Single Thread = One Barista

Picture a coffee counter with one barista. That’s your JavaScript thread.

- She works on one order at a time, and she never stops mid-order. Whatever she starts, she finishes before looking up. This is called run-to-completion.
- Slow work (grinding beans, steaming milk) goes to machines. She starts the machine and moves on immediately. She doesn’t stand there waiting.
- When a machine finishes, it doesn’t interrupt her. It puts a ticket on the rail.
- Only when her hands are empty does she check the rail, take the next ticket, and run its callback to completion.

The rail-checking routine, repeated forever, is the event loop.

### Mapping it to Node

Barista                            Node.js
--                                 --
The barista’s current task stack   Call stack: the functions running right now
The machines                       libuv and the OS: sockets via the OS’s async APIs;
                                     fs, dns.lookup, crypto, and zlib via libuv’s thread pool
                                     4 threads by default
Tickets on the rail                Callback queues: callbacks waiting for the stack to empty
“Hands empty, check the rail”      The event loop


“Node is single-threaded” is only true for your JavaScript. Node as a whole uses several threads. Your code just never runs on two of them at once, which is why you rarely need locks.

The flip side matters: the barista can be hogged. If one order is a giant synchronous loop or a huge JSON.parse, every ticket on the rail waits, including ones that are “already done.” That’s what “blocking the event loop” means, and it’s behind a lot of “the server hangs randomly” tickets.


## Event Loop

The rule: a callback can never run until every line of the current synchronous code has finished. Delay 0 (treated as 1ms) or 100ms just changes when the ticket gets posted, not when the barista is free.

```js
console.log('A');
setTimeout(() => console.log('B'), 0);
console.log('C');
```
Prints: A, C, B.

```js
// b.js
setTimeout(() => console.log('B timer'), 0);
console.log('B sync');

// a.js  (you run: node a.js)
console.log('A1');
require('./b');
console.log('A2');
```
Prints: A1, B sync, A2, B timer


### Not all tickets are equal: Macrotasks vs. Microtasks

Until now there’s been one rail. In reality the barista has two places to check:

1. **Microtasks:** A sticky note on her hand - promise callbacks (`.then`, `.catch`, code after `await`) and `queueMicrotask`.
2. **Macrotasks:** The rail - timers, I/O callbacks, setImmediate. These are the tickets we’ve been talking about.

The rule: after every order finishes, before she even glances at the rail, she does everything on the sticky note, including anything that gets added to it while she’s working through it. Only when the note is completely empty does she take the next rail ticket.

So microtasks always cut ahead of macrotasks. A promise that resolves “later” still beats a setTimeout(..., 0) that was scheduled first.

The danger version: if each microtask adds another microtask, the note never empties and the rail starves. Timers and I/O never run. It’s a subtler version of blocking the loop: no busy-wait anywhere, but the server still freezes.

```js
console.log('1');
setTimeout(() => console.log('2'), 0);
Promise.resolve().then(() => console.log('3'));
console.log('4');
```
Prints: 1, 4, 3, 2.
Correct: 1, 4, 3, 2. Both sync lines, then the sticky note (3), then the rail (2).


### process.nextTick

Node adds one more queue that browsers don’t have. Picture it as a note written directly on the barista’s wrist, checked even before the sticky note.

After each order finishes, Node drains, in this order:

1. `process.nextTick` queue, all of it
2. `Promise` microtask queue, all of it
3. Repeat 1–2 until both are empty, then check the rail for Macrotasks

So `nextTick` callbacks beat promise callbacks, which beat timers.
`nextTick` doesn’t wait for the next tick of the loop. It runs before the loop moves on at all.
Same danger as before, but worse: recursive `nextTick` starves not only the rail (Macrotasks) but promises too (Microtasks).

```js
Promise.resolve().then(() => console.log('promise'));
process.nextTick(() => console.log('tick'));
console.log('sync');
```
Prints: sync, tick, promise.


### One tick

Until now we've been calling “the rail” (Macrotasks) one queue. In reality the event loop walks through a fixed rotation of stations, and each one holds a different kind of ticket. Each lap around is one tick of the loop:

```
   ┌─► timers         setTimeout / setInterval callbacks that are due
   │   pending        some deferred system callbacks (rarely matters)
   │   poll           I/O callbacks: fs, network; waits here if nothing else to do
   │   check          setImmediate callbacks
   └── close          'close' events (socket.on('close'))
```

Between every single callback at any station, the wrist note (nextTick) and the sticky note (promises) get drained, exactly as you’ve been doing.

So `setImmediate` doesn’t mean “immediately.” It means “at the check station, right after the poll station on this lap.”

```js
console.log('1');
setImmediate(() => console.log('3'));
Promise.resolve().then(() => {
  console.log('4');
  process.nextTick(() => console.log('5'));
});
process.nextTick(() => console.log('6'));
console.log('7');
```
Prints: 1, 7, 6, 4, 5, 3.

