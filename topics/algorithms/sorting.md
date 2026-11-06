# Sorting
To analyze time efficiency we would create formulas to express # of comparisons, # of copies, and # of swaps.


## Simple Sort Algorithm - O(n^2):

- 1 Get a list of unsorted numbers
- 2 Repeat steps 3 through 6 until the unsorted list is empty
    - 3 Compare the unsorted numbers
    - 4 Select the smallest unsorted number
    - 5 Move this number to the sorted list
    - 6 Store a maximum value in the place of the smallest number
- 7 Stop


## Insertion Sort Algorithm - O(n^2):

- 1 Get a list of unsorted numbers
- 2 Set a marker for the sorted section after the first number in the list
- 3 Repeat steps 4 through 6 until the unsorted section is empty
    - 4 Select the first unsorted number
    - 5 Swap this number to left until it arrives at the correct sorted position
    - 6 Advance the marker to the right one position
- 7 Stop


## Selection Card Sort - O(n^2):

- 1 Get a list of unsorted numbers
- 2 Set a marker for the unsorted section at the front of the list
- 3 Repeat steps 4 - 6 until one number remains in the unsorted section
    - 4 Compare all unsorted numbers in order to select the smallest one
    - 5 Swap this number with the first number in the unsorted section
    - 6 Advance the marker to the right one position
- 7 Stop


## Bubble Sort Algorithm - O(n^2):

- 1 Get a list of unsorted numbers
- 2 Set a marker for the unsorted section at the end of the list
- 3 Repeat steps 4 through 6 until one number remains in the unsorted section
    - 4 Compare each pair of adjacent numbers in the unsorted section, left to right
    - 5 Swap any pair that is out of order, so the largest number moves to the end
    - 6 Advance the marker to the left one position
- 7 Stop


## Heap Sort Algorithm - O(n log n):

- 1 Get a list of unsorted numbers
- 2 Treat the list as a balanced binary tree, filled row by row from left to right:
  the number at position i (counting from 0) is a parent, and its children
  are at positions 2i+1 and 2i+2. No new structure is built; the list is the tree.
- 3 Arrange the tree into a max-heap, where every parent is at least as large as its children:
    - 4 Start at the last parent in the list, at position n/2 − 1 (rounded down)
    - 5 Sift it down, swapping it with its larger child until it is larger than both children
    - 6 Move to the previous position and repeat step 5, through the first position
- 7 Set a marker for the unsorted section at the end of the list
- 8 Repeat steps 9 through 11 until one number remains in the unsorted section
    - 9 Swap the first number (the root of the tree, so the largest) with the last number in the unsorted section
    - 10 Advance the marker to the left one position; numbers past it are no longer part of the tree
    - 11 Sift the new first number down, swapping it with its larger child until it is larger than both children
- 12 Stop

```
                       ________42________
                      /                  \
         ______17_____                    _____88_____
        /             \                  /            \
       5               63              29              71
     /    \          /    \          /    \          /    \
   94      12      36      58      3       80      47      21
  /  \    /  \    /
 66   9  75   51 33

value:    42 17 88  5 63 29 71 94 12 36 58  3 80 47 21 66  9 75 51 33  <-- the list to sort
position:  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19

row 0: position 0
row 1: positions 1–2
row 2: positions 3–6
row 3: positions 7–14
row 4: positions 15–19   (children of positions 7, 8, 9)
parents: 0–9
leaves: 10–19
last parent: 9 (value 36)
```


## Merge Sort - O(n log n):

- 1 Get a list of unsorted numbers
- 2 Treat each number as a sorted run of length one
- 3 Repeat steps 4 through 6 until one run remains
  - 4 Pair up neighboring runs from left to right; a leftover odd run waits for the next round
  - 5 Merge each pair: compare the front numbers of the two runs, copy the smaller one
    to a new list, and repeat until both runs are empty
  - 6 Replace each pair of old runs with its merged run
- 7 Stop

```
round 0:  [42] [17] [88] [ 5] [63] [29] [71] [94]
            \   /     \   /     \   /     \   /
round 1:   [17 42]   [ 5 88]   [29 63]   [71 94]
                \     /             \     /
round 2:     [ 5 17 42 88]       [29 63 71 94]
                        \         /
round 3:         [ 5 17 29 42 63 71 88 94]
```

Merge Sort, for n numbers:
- copies:       n log₂ n                 (every case)
- comparisons:  worst  n log₂ n − n + 1;
                best   (n/2) log₂ n      (one run always empties first)
- swaps:        0                        (it copies, it never swaps)
