// `unchecked` keyword

// - Solidity version 0.8+
// - Can only be used in a function body.
// - Must be followed by a block of code.
// - Code inside the unchecked block not checked for integer overflow or underflow.
// - Integer overflow or underflow inside the unchecked block will not be reverted.
// - Use with caution.

function add(uint a, uint b) public pure returns (uint) {
  // `unchecked` keyword disables the default behavior of Solidity 0.8+
  // which now reverts the txn on integer overflow or underflow.
  unchecked {
    return a + b;
  }
}

