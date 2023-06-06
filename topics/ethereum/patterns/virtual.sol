// `virtual` keyword

// DerivedContract inherits from BaseContract but can override `foo` fn due to
// use of `virtual override` keywords used together.

// BaseContract.sol
pragma solidity ^0.8.0;

contract BaseContract {
    function foo() public virtual {
        // Base implementation of foo()
    }
}

// DerivedContract.sol
pragma solidity ^0.8.0;

import "./BaseContract.sol";

contract DerivedContract is BaseContract {
    function foo() public virtual override {
        // Custom implementation of foo() in the derived contract
    }
}





