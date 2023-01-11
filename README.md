# Contracts

## Deployed Contracts

| Contract      | Network | Contract address |
| ------------- | ------- | ---------------- |
| Dispatcher    | ?       | not deployed yet |
| MembershipNFT | goerli      | 0x6F650cB99aA260e74040f6BA8E0ebC8C7fb920F2 |

### Deploy contracts

```shell
# To give our shell access to our environment variables
source .env
# To deploy and verify our contract
forge script script/<scriptname>.s.sol:<contractname> --rpc-url $GOERLI_RPC_URL  --private-key $GOERLI_PRIVATE_KEY --broadcast

# concatenate the following if you want to verify the contract
# --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv

```

### Test contracts

Using foundry

```shell
forge test
# for more details, logging with emit, add verbosity 1 up to 5 v's
forge test -vvvv
```

### Local Blockchain with Anvil (Foundry)

Set up a local blockchain like this

```shell
# set up fresh local blockchain
anvil

# if you want to fork an existing blockchain, because you need to interact with existing contracts, e.g on goerli testnet
anvil -f https://eth-goerli.g.alchemy.com/v2/<your_api_keys>
```
