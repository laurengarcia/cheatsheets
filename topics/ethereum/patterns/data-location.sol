// Data Location

// `storage` is persistent storage area in blockchain. Variables declared here
// persist across fn calls and contract invocations. State variables (vars 
// declared outside of functions) are default stored here. Modifying incurs 
// gas costs. Also, any uninitialized var will be allocated to storage, with
// potential side-effect of clobbering vars intentionally put there.

// `memory` is temporary storage area used during execution of a fn. Vars
// delcared in `memory` are created and destroyed & don't persist. Free to use
// in terms of gas, and faster. Can be overwritten.

// `calldata` is used for input parameters and can't be changed, ensures the fn
// only gets a read-only copy of the data.


// StorageMemoryExample.sol
pragma solidity ^0.8.0;

contract StorageMemoryExample {
    uint256[] public storageArray;

    function updateStorage(uint256[] storage data) public {
        storageArray = data;
    }

    function getDouble(uint256[] calldata data) public pure returns (uint256[] memory) {
        uint256[] memory doubledArray = new uint256[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            doubledArray[i] = data[i] * 2;
        }
        return doubledArray;
    }
}

// More precisely:
// From https://docs.soliditylang.org/en/latest/types.html#data-location
pragma solidity >=0.5.0 <0.9.0;

contract C {
    // The data location of x is storage.
    // This is the only place where the
    // data location can be omitted.
    uint[] x;

    // The data location of memoryArray is memory.
    function f(uint[] memory memoryArray) public {
        x = memoryArray; // works, copies the whole array to storage
        uint[] storage y = x; // works, assigns a pointer, data location of y is storage
        y[7]; // fine, returns the 8th element
        y.pop(); // fine, modifies x through y
        delete x; // fine, clears the array, also modifies y
        // The following does not work; it would need to create a new temporary /
        // unnamed array in storage, but storage is "statically" allocated:
        // y = memoryArray;
        // Similarly, "delete y" is not valid, as assignments to local variables
        // referencing storage objects can only be made from existing storage objects.
        // It would "reset" the pointer, but there is no sensible location it could point to.
        // For more details see the documentation of the "delete" operator.
        // delete y;
        g(x); // calls g, handing over a reference to x
        h(x); // calls h and creates an independent, temporary copy in memory
    }

    function g(uint[] storage) internal pure {}
    function h(uint[] memory) public pure {}
}
