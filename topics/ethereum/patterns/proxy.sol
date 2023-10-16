// proxy pattern

// Smart contracts are immutable out of the box in EVM.
// Upgrade smart contracts using a proxy for bug fixes, iteration, etc.
// The first contract is a simple wrapper that points to the current version.
// Users interact with proxy directly.
// Proxy forwards tx to the contract which contains the logic.

// User Tx --> Proxy --> Contract Logic

// All proxy patterns rely on low-level delegatecalls.
// msg.sender and msg.value are preserved.
// As a developer you mainly have to think about storage: always extend instead of modifying.

// Links:
// https://blog.openzeppelin.com/proxy-patterns
// https://docs.openzeppelin.com/upgrades-plugins/1.x/proxies
