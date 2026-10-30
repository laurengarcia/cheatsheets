# Graphs

A tree is a graph with strict rules: one root, one parent per node, no cycles. A graph drops those rules. Any node can point to any other node. The questions a graph is good at answering are about relationships: what depends on this? Can I get from A to B? Is there a cycle?

An npm dependency graph is a good example of what that allows:

- **Directed:** arrows have a direction. express → debug means “express depends on debug,” not the other way around.
- **Shared nodes:** lodash can have many parents. That’s why you needed visited.
- **Cycles:** possible, and real in npm (a pkg can have a dep that also depends on original pkg; a cycle exists when something downstream of a node depends back on that node, directly or thru a chain)


Cycles:
```
a → b → c → a        cycle (a reaches itself)
x → x                cycle too (a self-loop)
```

What’s not a cycle, and this trips people up, is a shared node (a “diamond”). Two paths converge on lodash, but following the arrows, you can never get back to app or express. Arrows only go one way.
```
app → express → lodash
app ──────────→ lodash
```

## How you store a graph

Two standard options:

1. **Adjacency list:** each node maps to a list of its neighbors. Ex:
```js
{ app: ['express', 'lodash'], express: ['debug', 'lodash'], debug: ['ms'], ... }
```

2. **Adjacency matrix:** a V × V grid where cell [A][B] is 1 if A → B exists.
```
         app express lodash debug ms
app       0     1      1      0    0
express   0     0      1      1    0
...
```

**Ex Question:** an npm project has 2,000 packages, and each one depends on about 5 others. Which representation would you pick, and why? Think about how much memory each one uses.

The precise count: the adjacency list holds every node plus every edge, so it’s V + E = 2,000 + 10,000 = about 12,000 entries. The matrix is V² = 4,000,000 cells, and only 10,000 of them are 1s. That’s 99.75% zeros, memory spent recording that packages don’t depend on each other.

So for sparse graphs (E is much smaller than V, has shared nodes, possibly cycles), you want to reach for the adjacency list. For something like a subway map where many vertices <> many vertices, reach for the adjacency matrix.

When the matrix wins: dense graphs, or when your main question is “does A → B exist?” The matrix answers that in O(1) by checking one cell. A list has to scan A’s neighbors. For npm, that’s never worth 4 million cells.
