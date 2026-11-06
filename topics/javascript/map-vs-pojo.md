# Map vs. POJOs in JavaScript

In JavaScript, both `Map` and POJOs (Plain Old JavaScript Objects) store data in key-value pairs, but they are optimized for entirely different use cases.

## Direct Comparison

| Feature            | Map                                | POJO (Plain Object) |
|---                 |---                                 |---|
| **Key Types**      | Any (obj, fns, primitives)         | Strings or Symbols only |
| **Key Order**      | Strictly preserves insertion order | Complex ordering (integer-like keys first in ascending order, then strings by insertion, then Symbols) |
| **Size Retrieval** | Direct via `.size` property — O(1) | Requires `Object.keys(obj).length` — O(n) |
| **Iteration**      | Directly iterable with `for...of`  | Requires `Object.keys()`, `Object.entries()`, or `for...in` |
| **JSON Support**   | Requires manual conversion         | Native support via `JSON.stringify()` |
| **Safety**         | Keys cant collide w or overwrite inherited properties | Can accidentally overwrite inherited keys (`toString`, etc.) |
| **Performance**    | Faster for frequent adds/deletes | Faster for read-heavy, static workloads |

## Key Advantages of Map

1. **Flexibility with keys:** A POJO converts all non-Symbol keys to strings. If you use an object as a key in a POJO, it gets stringified to `"[object Object]"`. A `Map` stores the actual reference to the object or function.
2. **Built-in API ergonomics:** `Map` has dedicated methods: `.set()`, `.get()`, `.has()`, and `.delete()`.
3. **Prototype safety:** POJOs inherit properties from `Object.prototype` (like `toString` or `valueOf`). If you use untrusted user input as keys, a POJO is open to accidental property overwrites and prototype pollution (e.g., a `__proto__` key). A `Map` doesn't have this problem.

## Key Advantages of POJOs

1. **Syntactic simplicity:** Writing `const user = { name: 'Alice' };` is far less verbose than creating a `Map`. You can also read fields directly with `user.name`.

## Summary Recommendations

- **Choose a POJO** when your data has a fixed, static shape (like a database record or configuration object) or when you need to send it over a network as JSON.
- **Choose a Map** when you need a dynamic dictionary, expect a very large number of keys, need non-string keys, or insert and delete entries often.

### Iteration Syntax

**Map** (directly iterable; always insertion order)

```js
const m = new Map([['a', 1], ['b', 2]]);

for (const [key, value] of m) { }         // entries, the default
for (const key of m.keys()) { }
for (const value of m.values()) { }
for (const [key, value] of m.entries()) { } // same as plain `of m`

m.forEach((value, key) => { });            // note: value FIRST
```

**POJO** (not iterable; `for...of obj` throws TypeError)

```js
const o = { a: 1, b: 2 };

for (const key of Object.keys(o)) { }
for (const value of Object.values(o)) { }
for (const [key, value] of Object.entries(o)) { }

for (const key in o) {             // also walks INHERITED
  if (Object.hasOwn(o, key)) { }   // enumerable keys; guard it; .hasOwn added in ES 2022
}

for (var key in obj) {
  if (obj.hasOwnProperty(key)) {   // old-fashioned Crockford style
    // only the object's own keys, not inherited ones
  }
}
```

Notes:
- POJO keys are stringified first; every object beceomes "[object Object]", so more than one will overwrite/ collide.
- Map is opposite; keys can hold objects/ functions/ whatever, and they collide/ are matched by identity.
- `Object.keys/values/entries` return own enumerable string keys only; Symbol keys are skipped.
- `for...in` is the odd one out: it includes inherited enumerable properties, hence the `hasOwn` guard.
- Converting: `new Map(Object.entries(o))` and `Object.fromEntries(m)`.
