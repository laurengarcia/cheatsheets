// Forced Ether via selfdestruct method

// Step 1: Deploy Malicous contract

// Step 2: Deploy Vulnerable, set `targetContract` to deployed MaliciousContract
// VulnerableContract vulnerableContract = new VulnerableContract(maliciousContractAddress);

// Step 3: Transfer ETH to the vulnerable contract
// address(vulnerableContract).transfer(1 ether);

// Call `destroy` fn, triggering the `selfdestruct` where ETH is now stuck forever
// vulnerableContract.destroy();


// VulnerableContract.sol
pragma solidity ^0.8.0;

contract VulnerableContract {
    address payable public targetContract;

    constructor(address payable _targetContract) {
        targetContract = _targetContract;
    }

    function destroy() public {
        selfdestruct(targetContract);
    }
}


// MaliciousContract.sol
pragma solidity ^0.8.0;

contract MaliciousContract {
    constructor() payable {}

    // Missing fallback function
}
