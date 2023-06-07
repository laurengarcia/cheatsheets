// `now` keyword

// The `now` keyword is a global variable that represents the current timestamp
// of the current block. It returns the number of seconds that have passed since
// the Unix epoch (January 1, 1970).

// TimeBasedContract.sol
pragma solidity ^0.8.0;

contract TimeBasedContract {
    uint256 public startTime;

    constructor() {
        startTime = now;
    }

    function hasTimeElapsed(uint256 duration) public view returns (bool) {
        uint256 elapsedTime = now - startTime;
        return elapsedTime >= duration;
    }
}
