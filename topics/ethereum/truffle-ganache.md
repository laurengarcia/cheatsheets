# Truffle + Ganache + Deployment

### Install Dependencies

#### Truffle CLI
Dev env, test framework, and asset pipeline to prod Ethereum:
```
$ npm install -g truffle
```

#### Ganache CLI or GUI
Ganache CLI or GUI (was called TestRPC). Runs a virtual Eth blockchain locally. Also comes in GUI form as well.
```
$ npm install -g ganache-cli
```

#### Smart Contract Dependency Flattener
When you find code in the wild you can use truffle-flattener to compile the contract with all of its dependencies into one .sol file. Install:
```
$ npm install -D truffle-flattener --save
```
Usage:
```
$ truffle-flattener ./contracts/examples/Whitelist.sol > flattend.sol
```

## Init, Test & Deploy Contract to Local Ganache
Reference: [Hackernoon tutorial](https://hackernoon.com/ethereum-development-walkthrough-part-2-truffle-ganache-geth-and-mist-8d6320e12269)

1. Init project
```
$ mkdir myproject
$ truffle init
```

2. Contract & Migrations:
- Your solidity contract file goes into the /contracts dir.
- Next, go to /migrations and create a new file:
```
$ touch migrations/2_deploy_contracts.js
```

3. Config:
Set correct network settings inside of root dir truffle_config.js file

4. Start Ganache (in new terminal)
...or run from standalone desktop application
```
$ ganache-cli -p 8545
```

5. Compile (in /myproject dir)
- Compiles solidity to bytecode for EVM.
- NOTE: you may need to rm -rf the entire ./build directory before compiling, esp when deployment or config changes. Can make this a step in your build pipeline.
```
$ truffle compile
```

6. Migration
In /migrations/2_deploy_contract.js, use something like this code (assumes Wrestling.sol is your contract in /contracts):
```
const Wrestling = artifacts.require("./Wrestling.sol")

module.exports = function(deployer) {
  deployer.deploy(Wrestling);
};
```

7. Deploy to local blockchain set in truffle-config.js by running this via cli. Contract address is spit out in terminal next to Solidity file name. In Ganache terminal, contract address is next to where it says "Contract created:"

- NOTE: If there is extra/ unused cruft code in your contracts, it may throw a spurious error related to gas. Go crop that code out (and remove it from build). You'll need to rm -rf the /build dir and re-compile/re-migrate.
```
$ truffle migrate --network development
```

8. Start Truffle console
```
$ truffle console --network development
```

9. Assign users that Ganache CLI generated via truffle cli:
```
`$ account0 = web3.eth.accounts[0]
`$ account1 = web3.eth.accounts[1]
```

10. Create contract instance from console, create an instance of the contract:
```
$ Wrestling.deployed().then(inst => { WrestlingInstance = inst })
```

11. Query contract properties. Truffle console lets you interact with the contract as if it were deployed to the public Eth blockchain. You can call functions etc. Call into contract and get current state of public properties:
```
$ WrestlingInstance.<public property>.call()
```

12. Calling contract functions. Call functions in the contract as one of the users that Ganache created and we wired up to the truffle cli above.
- `value` is used to send ether from the sender with the txn.
- `web3` is the js library used to talk to Ganache/EVM.
- `.toWei()` converts the amt in Eth to the smallest unit of Ether.
```

WrestlingInstance.wrestle({from: account0, value: web3.toWei(2, "ether")})
WrestlingInstance.wrestle({from: account1, value: web3.toWei(3, "ether")})
// End of the first round
WrestlingInstance.wrestle({from: account0, value: web3.toWei(5, "ether")})
WrestlingInstance.wrestle({from: account1, value: web3.toWei(20, "ether")})
// End of the wrestling
WrestlingInstance.withdraw({ from: account1 })
```

## Deploy to Public Network

Make sure you have gas in your Metamask account if its a testnet. There are different faucets for diff't testnets.

* [Kovan faucet link](https://faucet.kovan.network/)
* [Rinkeby faucet link](https://faucet.rinkeby.io/)

Make sure you're on the right network!

You can use different toolings deployment methods, including truffle by just configuring `truffle-config.js` in your project's home dir.

[Remix](https://remix.ethereum.org) is pretty awesome, great for debugging, and it has [great docs here](https://remix-ide.readthedocs.io/en/latest/run.html). highly recommend.

One thing to note about Remix is that you'll need to use `truffle-flattener` before deploying. See section at top for details.

