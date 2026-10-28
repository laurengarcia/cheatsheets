# Strings

A string is an array of characters, with one big difference: its frozen. In JS, strings are immutable. You can't change a character in place. Every “change” (+, .replace(), .slice(), .toUpperCase()) builds a brand-new string and copies characters into it. That copy is O(length).

str[i] is O(1), and str.includes('x') is O(n). But anything that modifies quietly pays for a full copy.

Ex:
```js
let report = '';
for (const pkg of pkgs) {
  report += pkg + '\n'; // <-- only efficient due to V8 ropes
}
```
It loops thru n items in pkgs, and inside the loop it will quietly pay for a new copy of report, so this loop is O(n^2).

In Node, this loop is fast. V8 doesn’t actually copy on every +=. It builds a *rope*, a lightweight tree of “this string plus that string,” and only flattens it into one real string when you read it. So the textbook answer is O(n²), and the practical answer is that modern engines optimize it away.

The idiomatic answer, which works in every engine: collect the pieces and join once.
```
const report = pkgs.join('\n'); // O(total length): one copy`
```
