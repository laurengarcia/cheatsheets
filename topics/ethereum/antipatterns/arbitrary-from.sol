// Arbitrary `from`

// Issue:
// `msg.sender` is not used as from in transferFrom.

function a(address from, address to, uint256 amount) public {
    erc20.transferFrom(from, to, am);
}

// Alice approves this contract to spend her ERC20 tokens.
// Bob can call `a()` and specify Alice's address as the from parameter in
// `transferFrom`, allowing him to transfer Alice's tokens to himself.
