# Finnexce Protocol

Finnexce is a modular DeFi protocol core focused on staking, fee routing,
and treasury management, designed for reuse across DeFi applications.

## Architecture
- FinnexceCore: core protocol logic and coordination
- Staking: staking and reward distribution
- Treasury: fee collection and fund management

## Source Code
All protocol smart contracts are located in the src/ directory.

## Network
- Current: BSC Testnet (Chapel)
- Stage: MVP / Testnet

## Status
- Deployed on testnet
- Not audited yet

## Disclaimer
This project is under active development. Testnet use only.

## Testnet Deployment

Network: BSC Testnet (Chapel)

| Contract | Address |
|---------|---------|
| FinnexceCore | 0x95D9cd3576145c6600fdb911584033fE667e6dE6 |
| Staking | 0x446689C6F6abDf12bfB2D90E9D18f042f4CBcE97|
| Treasury | 0x0A29996Cc90d4923936c46e584acB5D0A55718f1 |

### Sample Transactions
- Deployment: https://testnet.bscscan.com/tx/0x...

### Sample Transactions

- Deploy FinnexceCore  
  https://testnet.bscscan.com/tx/0x95D9cd3576145c6600fdb911584033fE667e6dE6

- Create Pool  
  https://testnet.bscscan.com/tx/0x446689C6F6abDf12bfB2D90E9D18f042f4CBcE97

- Set Treasury  
  https://testnet.bscscan.com/tx/0x0A29996Cc90d4923936c46e584acB5D0A55718f1

  ## Roadmap

### Phase 1 – MVP (Completed)
- Core / Staking / Treasury contracts
- Testnet deployment
- Pool management

### Phase 2 – Hardening
- Security review
- Gas optimization
- Fee routing refinement

### Phase 3 – Mainnet
- Audit
- Mainnet deployment
- Governance design
