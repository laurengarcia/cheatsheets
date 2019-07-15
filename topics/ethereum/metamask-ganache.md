To work develop smart contracts locally with Metamask and Ganache:

### Setup: Start Ganache and Connect Metamask

1. FIRST! Back up your primary Metamask seed phrase so you can recover your accounts using it.

2. Lock Metamask via "Log Out" button if you haven't already.
Start Ganache in terminal cli:
```
$ ganache-cli -p 8545
```

3. Copy seed phrase. Your dev env seed phrase will appear as "Mnemonic" under "HD Wallet" in the startup output. Copy seed phrase and open Metamask > Import using account seed phrase.

4. Select Network. In Metamask network selector, choose "Custom RPC" and enter "localhost:8545". The network selector will now say "Private Network".

5. Compile, migrate & deploy smart contract to ganache. See `truffle-ganache.md` for details.
```
$ truffle compile
$ truffle migrate --network development
```

6. Copy smart contract address from deployment output into dapp local configuration.
