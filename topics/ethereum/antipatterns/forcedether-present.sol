// Forced Ether via pre-sent method

// Anyone can calculate what a contract’s address will be before it is created
// and send ETH to that address. When the contract is created it will have a
// nonzero ETH balance.

// Contract addresses are deterministic, calculated from the Keccak-256 (commonly
// synonymous with SHA-3) hash of the address creating the contract and the
// transaction nonce that creates the contract:
// `address = sha3(rlp.encode([account_address,transaction_nonce]))`

// Poor use of `this.balance` can result in unexpected states. Contract logic,
// when possible, should avoid depending on exact values of the balance of the
// contract, bc it can be artificially manipulated.
// If applying logic based on this.balance, you have to cope with unexpected balances.


contract EtherGame {

    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether;
    uint public finalReward = 5 ether;

    mapping(address => uint) redeemableEther;

    // Users pay 0.5 ether. At specific milestones, credit their accounts.
    function play() external payable {
        require(msg.value == 0.5 ether); // each play is 0.5 ether
        uint currentBalance = this.balance + msg.value;
        // ensure no players after the game has finished
        require(currentBalance <= finalMileStone);
        // if at a milestone, credit the player's account
        if (currentBalance == payoutMileStone1) {
            redeemableEther[msg.sender] += mileStone1Reward;
        }
        else if (currentBalance == payoutMileStone2) {
            redeemableEther[msg.sender] += mileStone2Reward;
        }
        else if (currentBalance == finalMileStone ) {
            redeemableEther[msg.sender] += finalReward;
        }
        return;
    }

    function claimReward() public {
        // ensure the game is complete
        require(this.balance == finalMileStone); // <-- BUG IS HERE
        // ensure there is a reward to give
        require(redeemableEther[msg.sender] > 0);
        uint transferValue = redeemableEther[msg.sender];
        redeemableEther[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
 }
