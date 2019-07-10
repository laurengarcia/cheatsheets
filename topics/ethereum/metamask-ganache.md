To work develop smart contracts locally with Metamask and Ganache:

### Setup: Start Ganache and Connect Metamask

FIRST! back up your primary Metamask seed phrase so you can recover your accounts using it.
Lock Metamask via "Log Out" button if you haven't already.
Start Ganache in terminal cli:
```
$ ganache-cli -p 8545
```
Your dev env seed phrase will appear as "Mnemonic" under "HD Wallet" in the startup output.
Copy seed phrase and open Metamask > Import using account seed phrase.
In Metamask network selector, choose "Custom RPC" and enter "localhost:8545".
The network selector will now say "Private Network".

