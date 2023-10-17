// Checks-Effects-Interactions Pattern
// Used to prevent re-entrancy

// Functions should in this order:
// 1- Check: who called fn, are arguments good, did they send enough Eth, etc.
// 2- Effects: if checks pass, change state vars within current contract
// 3- Interactions: interact w other contracts

// Failure to do in this order may result in re-entrancy attacks.
