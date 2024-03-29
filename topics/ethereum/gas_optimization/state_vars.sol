// Constant state vars cannot be modified after contract is constructed.
// Cheapest on gas to use bc its copied everywhere it will be used.
// Local optimizations therefore possible.

// Immutable state vars also cheaper.
// Only immutable when deployed.
// At construction time, can be assigned any number of times.

pragma solidity ^0.8.21;

uint constant X = 32*22 + 8;

contract C {
    string constant TEXT = "abc";
    bytes32 constant MY_HASH = keccak256("abc");
    uint immutable decimals = 18;
    uint immutable maxBalance;
    address immutable owner = msg.sender;

    constructor(uint decimals_, address ref) {
        if (decimals_ != 0)
            // Immutables are only immutable when deployed.
            // At construction time they can be assigned to any number of times.
            decimals = decimals_;

        // Assignments to immutables can even access the environment.
        maxBalance = ref.balance;
    }

    function isBalanceTooHigh(address other) public view returns (bool) {
        return other.balance > maxBalance;
    }
}
