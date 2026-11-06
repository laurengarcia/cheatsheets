# Map vs. POJOs in JavaScript

In JavaScript, both `Map` and POJOs (Plain Old JavaScript Objects) store data in key-value pairs, but they are optimized for entirely different use cases.

## Direct Comparison

| Feature | Map | POJO (Plain Object) |
|---|---|---|
| **Key Types** | Any data type (objects, functions, primitives) | Strings or Symbols only |
| **Key Order** | Strictly preserves insertion order | Complex ordering (integer-like keys first in ascending order, then strings by insertion, then Symbols) |
| **Size Retrieval** | Direct via `.size` property — O(1) | Requires `Object.keys(obj).length` — O(n) |
| **Iteration** | Directly iterable with `for...of` | Requires `Object.keys()`, `Object.entries()`, or `for...in` |
| **JSON Support** | Requires manual conversion | Native support via `JSON.stringify()` |
| **Safety** | Keys can't collide with or overwrite inherited properties | Can accidentally overwrite inherited keys (`toString`, etc.) |
| **Performance** | Faster for frequent additions/deletions | Faster for read-heavy, static workloads |

## Key Advantages of Map

1. **Flexibility with keys:** A POJO converts all non-Symbol keys to strings. If you use an object as a key in a POJO, it gets stringified to `"[object Object]"`. A `Map` stores the actual reference to the object or function.
2. **Built-in API ergonomics:** `Map` has dedicated methods: `.set()`, `.get()`, `.has()`, and `.delete()`.
3. **Prototype safety:** POJOs inherit properties from `Object.prototype` (like `toString` or `valueOf`). If you use untrusted user input as keys, a POJO is open to accidental property overwrites and prototype pollution (e.g., a `__proto__` key). A `Map` doesn't have this problem.

## Key Advantages of POJOs

1. **Syntactic simplicity:** Writing `const user = { name: 'Alice' };` is far less verbose than creating a `Map`. You can also read fields directly with `user.name`.

## Summary Recommendations

- **Choose a POJO** when your data has a fixed, static shape (like a database record or configuration object) or when you need to send it over a network as JSON.
- **Choose a Map** when you need a dynamic dictionary, expect a very large number of keys, need non-string keys, or insert and delete entries often.
