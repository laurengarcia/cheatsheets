// data location

// `storage` is persistent storage area in blockchain. Variables declared here
// persist across fn calls and contract invocations. State variables (vars 
// declared outside of functions) are default stored here. Modifying incurs 
// gas costs.

// `memory` is temporary storage area used during execution of a fn. Vars
// delcared in `memory` are created and destroyed & don't persist. Free to use
// in terms of gas, and faster. 

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
