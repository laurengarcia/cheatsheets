// State Mutability

// `view`
// Function promises not to modify state.
// Getter methods are auto-marked as `view`.
pragma solidity >=0.5.0 <0.9.0;

contract C {
    function f(uint a, uint b) public view returns (uint) {
        return a * (b + 42) + block.timestamp;
    }
}

// `pure`
// Function promises not to read from or modify the state.
// Pure fns can use `revert()` or `require()`.
pragma solidity >=0.5.0 <0.9.0;

contract C {
    function f(uint a, uint b) public pure returns (uint) {
        return a * (b + 42);
    }
}


// The following statements are considered modifying the state:

// - Writing to state variables.
// - Emitting events.
// - Creating other contracts.
// - Using selfdestruct.
// - Sending Ether via calls.
// - Calling any function not marked view or pure.
// - Using low-level calls.
// - Using inline assembly that contains certain opcodes.


// Additionally, the following are considered reading from the state:

// - Reading from state variables.
// - Accessing address(this).balance or <address>.balance.
// - Accessing any of the members of block, tx, msg (with the exception of msg.sig and msg.data).
// - Calling any function not marked pure.
// - Using inline assembly that contains certain opcodes.
