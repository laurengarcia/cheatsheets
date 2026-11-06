# Binary Search

Efficient algorithm for finding an item from a sorted list of items. It works by repeatedly dividing in half the portion of the list that could contain the item, unil you've narrowed down the possible locations to just one.

ex: Find an item in an array of star names
1. Linear search: worst case, would have to examine all `n` star names.
2. If sorted alphabetically by star names, binary search would only need to examine 22 stars in worst case.

## Binary search of an array - O(log n)
Find a given number in an array of the first 25 prime numbers (notice list is pre-sorted not random).

Pseudocode:
1. Let min = 0 and max = n-1.
2. If max < min, then stop: target is not present in array. Return -1.
3. Compute guess as the average of max and min, rounded down (so that it is an integer).
4. If array[guess] equals target, then stop. You found it! Return guess.
5. If the guess was too low, that is, array[guess] < target, then set min = guess + 1.
6. Otherwise, the guess was too high. Set max = guess - 1.
7. Go back to step 2.

```js
// Returns either the index of the location in the array,
// or -1 if the array did not contain the targetValue

var doSearch = function(array, targetValue) {
  var min = 0;
  var max = array.length - 1;
  var guess;
  while (min <= max) {
    guess = Math.floor((min + max) /2);  // calculate guess for this round
    if (array[guess] === targetValue) { return guess;} // found it!
    if (array[guess] < targetValue) {
      min = guess + 1;
    } else {
      max = guess - 1;
    }
  }

  return -1;
};

var primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];

var result = doSearch(primes, 73);
console.log("Found prime at index " + result);
```

## Runtime Calculation

- **Linear search:** O(n). In the worst case you check every item.
- **Binary search:** O(log n). Each guess cuts what's left in half.


### Worst-case guesses

- `guesses = (exponent of the largest power of 2 ≤ n) + 1`
  - exponent = how many times you can halve n down to 1
  - +1 = checking that last item
  - math notation for the same thing: `⌊log₂ n⌋ + 1`

| n   | largest power of 2 ≤ n | guesses   |
|-----|------------------------|-----------|
| 25  | 16 = 2⁴                | 4 + 1 = 5 |
| 100 | 64 = 2⁶                | 6 + 1 = 7 |
| 128 | 128 = 2⁷               | 7 + 1 = 8 |


### What's log₂?

log₂ n = how many times you halve n to reach 1.
`log₂ 128 = 7` because `2⁷ = 128`.


### Why it matters

Doubling n adds only **one** guess.

| n             | linear | binary |
|---------------|--------|--------|
| 1,000         | 1,000  | 10     |
| 1,000,000     | 1M     | 20     |
| 1,000,000,000 | 1B     | 30     |

Shortcut: 2¹⁰ ≈ 1,000, so every ×1,000 adds about 10 guesses.
