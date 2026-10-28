# Arrays

Operation                       JS                       Cost             Why
--                              --                       --               --
Read or write by index          arr[i]                   O(1)             Direct jump
Add or remove at the end        push, pop                O(1) amortized   Nobody else moves
Add or remove at the front      unshift, shift           O(n)             Every item shifts over one
Insert or remove in the middle  splice                   O(n)             Everything after it shifts
Search by value                 includes, indexOf, find  O(n)             One by one
Copy                            slice, [...arr]          O(n)             Every item gets copied

**The rule underneath it all:** changes at the end are cheap, and changes anywhere else make everyone behind them move.

**The Node-specific layer,** V8 doesn’t always store JS arrays as a literal. A dense array of same-typed items is stored efficiently. If you punch holes in it (`arr[1000000] = x` on an empty array) or mix types, V8 can fall back to a slower dictionary-like representation. Keep arrays dense and same-typed for V8/ Node-scaling.


## Read Pointers and Queues

Use read pointers aka "head index". Instead of `shift()` aka removing items from the front:
```js
const queue = [root];
for (let head = 0; head < queue.length; head++) {
  const pkg = queue[head];  // <-- O(1) read, instead of shift()
  for (const dep of deps[pkg]) {
    if (!visited.has(dep)) {
      visited.add(dep);
      queue.push(dep);
    }
  }
}
```
- `queue.length` is re-checked on every pass, so anything pushed during the loop gets reached. That’s the queue behavior you want.
- The trade-off: processed items never leave the array, so memory isn’t freed as you go. For a long-running job queue that never ends, it would be a slow leak, and you’d want a real queue structure. That’s a good thing to flag out loud.
