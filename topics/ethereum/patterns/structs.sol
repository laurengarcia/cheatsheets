// Struct Types

// Custom defined types that can group several variables.
// Ex:
pragma solidity >=0.4.0 <0.9.0;

contract Ballot {
    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote;
    }
}
