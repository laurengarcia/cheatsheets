# EVM Transactions

Transactions consist of:
```
- nonce
- gasLimit
- gasPrice
- to
- value
- v
- r
- s
- data
```

Each transaction is signed.

Originator (`from`) address not included bc it is derived from the signature components (`v`,`r`,`s`).

`r` and `s` are what create the signature (ECDSA signature outputs)

`v` is required to recover the public key.
