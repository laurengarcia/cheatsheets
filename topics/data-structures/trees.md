# Trees

A tree is a hierarchy. One root, and each node points down to its children, with no cycles. You’ve lived in one forever: your filesystem, the DOM, and node_modules all have this shape.


## Binary Search Trees (BST)

A binary search tree (BST) adds one rule: at every node, everything smaller goes left, and everything bigger goes right.

Good for answering: “where does this fit in sorted order?”

```
          lodash
         /      \
     debug      react
     /   \          \
  chalk  express    zod
```


To find `express`: it’s before `lodash` alphabetically, so go left. It’s after `debug`, so go right. Found. Each step discards half the remaining tree, so its O(log n); like a built-in binary search that also supports fast inserts.

More precisely: BST lookup costs O(height).

- A balanced tree has height about log n, so lookup is O(log n).
- A degenerate tree that only goes one direction (right or left down) has height n, so lookup is O(n). Ex: a pre-sorted tree.

Sorted input isn’t a corner case. Alphabetical package lists, timestamps, and auto-increment IDs all arrive in order all the time.

### Self-Balancing Trees

- AVL Trees
- Red-Black Trees

After each insert, they do small local rearrangements called `rotations` to keep the height near log n.

Note: JavaScript has no built-in BST. `Map` is hash based. It remembers *insertion* order not *sorted* order. If you need sorted data with fast lookups in Node, you either sort an array and binary-search it, or pull in a library.


## Tries

A trie (from “retrieval,” usually pronounced “try”) stores strings one character per level, so words with the same prefix share the same path. The question a trie is fast at answering is “what starts with this prefix?”

Ex: Autocomplete is the classic example: type `lo`, walk two steps, and everything below that node is a match. Looking up a word in a trie costs O(L), where L is the length of the word, no matter whether the trie holds 10 or 10 million. In an autocomplete trie, the number of stored words doesn't matter, that is orthogonal to the depth aka length of the word. More words make the trie wider not deeper.

```
        (root)
        /    \
       l      r
       |      |
       o      e
      / \     |
     d   g    a
     |        |
     a        c
     |        |
     s        t
     |
     h
```

**The trade-off:** tries are memory-heavy. Every character is its own node with its own child map. You pay that when prefix questions are the main thing you ask.

