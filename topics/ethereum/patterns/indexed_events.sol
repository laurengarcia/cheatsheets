// Indexed Events

// The indexed parameters for logged events will allow you to search for these
// events using the indexed parameters as filters.
// The `indexed` keyword is only relevant to logged events:

event Transfer(address indexed from, address indexed to, uint256 value);

// You can use `indexed` to up to 3 params.
// It adds them to a special data stucture called `topics`
// `topics` can only hold a single word (bytes32)
// anything longer is stored as keccak-256 hash instead.


// Ex:
// Uses the web3.js subscribe("logs") method to filter logs that match a
// topic with a certain address value:
```javascript

var options = {
    fromBlock: 0,
    address: web3.eth.defaultAccount,
    topics: ["0x0000000000000000000000000000000000000000000000000000000000000000", null, null]
};
web3.eth.subscribe("logs", options, function (error, result) {
    if (!error)
        console.log(result);
})
    .on("data", function (log) {
        console.log(log);
    })
    .on("changed", function (log) {
});

```
