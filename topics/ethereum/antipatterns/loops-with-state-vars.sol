// Loops with State Vars Inside

// Costly to update state var inside of a loop
// It uses to opcode "SSTORE" to access state var, which is expensive to use.
// Instead, loop over a local variable & then update state var when complete.

contract Costly {
  uint loop_count = 100;
  uint state_variable = 0;

  function bad() external {
      for (uint i=0; i < loop_count; i++) {
          state_variable++;
      }
  }

  function good() external {
    uint local_variable = state_variable;
        for (uint i=0; i < loop_count; i++) {
            local_variable++;
        }
    state_variable = local_variable;
  }

}
