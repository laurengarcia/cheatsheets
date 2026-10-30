# Heaps

Aka **priority queue**

A heap answers exactly one question fast: “what’s the most important thing right now?”

A heap is a binary tree kept perfectly filled, level by level, so its height is always about O(log n).

- Peek at the top item: O(1). It always sits at the root.
- Insert a new ticket: O(log n). It bubbles up to its correct level.
- Remove the top ticket: O(log n). The structure re-settles itself.

The heap doesn't fully sort anything. It only guarantees every parent is more important than its children. That weak promise is cheap to maintain, and it’s still enough to always know the winner.

JS has no built-in heap, so you’d write one or use a library, just like with BSTs.

## Insert works like this:

1. Put the new ticket in the next empty slot at the bottom.
2. Compare it with its parent. If it’s more urgent, swap them.
3. Repeat until its parent is more urgent, or it reaches the top.

```
insert priority 9:

        7                   7                   9
       / \                 / \                 / \
      5   6      →        9   6      →        7   6
     / \                 / \                 / \
    3   9               3   5               3   5
```

It only climbs one path, from a leaf up toward the root, and that path is at most log n long. Nothing else moves. Compare that to the sorted array, where one insert can shove n items over.
