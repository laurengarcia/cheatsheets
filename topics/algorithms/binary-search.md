# Binary Search

Efficient algorithm for finding an item from a sorted list of items. It works by repeatedly dividing in half the portion of the list that could contain the item, unil you've narrowed down the possible locations to just one.

ex: Find an item in an array of star names
1. Linear search: worst case, would have to examine all `n` star names.
2. If sorted alphabetically by star names, binary search would only need to examine 22 stars in worst case.

## Binary search of an array
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

A **linear search** of `primes` is **O(n)**, where `n` is the number of items in the array.
For a **binary search**, the number of guesses in the worst case is:

> the number of times we can repeatedly halve, starting at `n`, until we reach 1, **plus one**.

**Formula:**
```
guesses = ⌊log₂ n⌋ + 1
```
...where `log₂ n` means "the base-2 logarithm of `n`.


### What's a logarithm?

Logarithms are the **inverse of exponentials**. Exponentials grow very fast, so logarithms grow very slowly.

If `log₂ n = x`, then `n = 2ˣ`. Ex: `log₂ 128 = 7`, because `2⁷ = 128`.

So binary search is **O(log n)**.
