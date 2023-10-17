// Visibility
// Making something `private` or `internal` only prevents other contracts from
// reading or modifying it, but it will still be visible outside of EVM.


// -- State Variables Visibility

// `public`
// Is default if not marked otherwise.
// Compiler auto-generates getters, visible to other contracts.
// When used inside of contract, reference via external access via `this.x`
// Internal access to `x` comes directly from storage.
// Setter functions not generated.

// `internal`
// Only visible from inside the contract & derived contracts.
// --> This is the default visibility level for state vars.

// `private`
// Similar to internal ones, but not visibile to derived contracts.


// -- Functions Visibility

// `external`
// Part of ABI, can be called by other contracts or txns.
// An external function cant be called internally, is only avail via `this.f()`

// `public`
// Is default if not marked otherwise.
// Part of ABI, can be called internally or via message calls.

// `internal`
// Cannot be called externally.
// Only called from inside contract or derived contracts.
// Can take parameters of internal types like mappings or storage refs.

// `private`
// Like internal but not visible to derived contracts.


// Ex:
pragma solidity >=0.4.16 <0.9.0;

contract C {
    uint private data;

    function f(uint a) private pure returns(uint b) { return a + 1; }
    function setData(uint a) public { data = a; }
    function getData() public view returns(uint) { return data; }
    function compute(uint a, uint b) internal pure returns (uint) { return a + b; }
}

// This will not compile
contract D {
    function readData() public {
        C c = new C();
        uint local = c.f(7); // error: member `f` is not visible
        c.setData(3);
        local = c.getData();
        local = c.compute(3, 5); // error: member `compute` is not visible
    }
}

contract E is C {
    function g() public {
        C c = new C();
        uint val = compute(3, 5); // access to internal member (from derived to parent contract)
    }
}
