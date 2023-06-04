// Denial of Service Attack

// The vulnerable code uses a loop that iterates an extremely large number of
// times (2**256). This loop consumes an enormous amount of gas, exceeding the
// maximum gas limit that Ethereum allows for a single transaction. As a result,
// executing the increment() function will cause the transaction to run out of gas,
// resulting in the contract becoming unresponsive.


// VulnerableContract.sol
pragma solidity ^0.8.0;

contract VulnerableContract {
    uint public counter;

    function increment() public {
        // Vulnerable code: This loop consumes excessive gas
        for (uint i = 0; i < 2**256; i++) {
            counter++;
        }
    }
}
