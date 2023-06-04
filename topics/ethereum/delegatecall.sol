// Target.sol
pragma solidity ^0.8.0;

contract Target {
    uint public value;

    function setValue(uint _newValue) public {
        value = _newValue;
    }
}

// Caller.sol
pragma solidity ^0.8.0;

contract Caller {
    address public targetAddress;

    function setTarget(address _targetAddress) public {
        targetAddress = _targetAddress;
    }

    function callSetValue(uint _newValue) public {
        
        // Using DELEGATECALL, Caller executes `setValue` fn of Target
        // modifying Target's `value` while keeping own storage intact.
        // Target code will execute in the context of the Caller!
        //   `success` will be true if delegate call is successful
        //   `result` will be return value (if any) of the called function
        (bool success, bytes memory result) = targetAddress.delegatecall(

            // Encode the fn signature & arguments of `setValue(uint256)`
            abi.encodeWithSignature("setValue(uint256)", _newValue)
        
        );

        require(success, "Delegatecall failed");
    }
}
