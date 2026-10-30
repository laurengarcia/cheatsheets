# Stacks & Queues

Both are lists with one rule about which end you take from:

1. **Stack:** last in, first out (LIFO). A pile of plates: you take from the top, which is the last plate you added. In JS, use .push() and .pop(), both O(1).

- A stack answers “what’s the most recent unfinished thing?”
- Ex: stack traces on errors. Every fn call pushes a stack frame: a record holding what fn it is, its local vars, and where to return once its done. Every return pops that frame off. Every fn call pushes and every return pops.
```
Error: boom
    at c   ← top: the most recent unfinished call
    at b   ← called c, still waiting on it
    at a   ← called b, still waiting on it
```
So `RangeError: Maximum call stack size exceeded` is exactly this: endless recursion kept pushing frames and never popped, until the stack ran out of room.


2. **Queue:** first in, first out (FIFO). A line at a coffee shop: whoever arrived first gets served first. .shift() is O(n), which is why you used a head index.

- A queue answers “what’s been waiting longest?”
