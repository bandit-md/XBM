# XBM Deployment Checklist

## Pre-Deployment
- [ ] Install Node.js ≥ 18
- [ ] Run `npm install`
- [ ] Create `.env` from `.env.example`
- [ ] Fund deployer wallet with ETH (testnet or mainnet)
- [ ] Run `npm test` — all tests must pass
- [ ] Run `npm run compile` — no errors

## Testnet Deployment (Sepolia)
- [ ] Deploy: `npm run deploy:sepolia`
- [ ] Note the contract address
- [ ] Verify on Etherscan (automatic in script)
- [ ] Test basic transfer on testnet
- [ ] Test pause/unpause
- [ ] Transfer ownership to multi-sig (recommended)

## Mainnet Deployment
- [ ] Security audit completed
- [ ] Deployer is multi-sig or hardware wallet
- [ ] Deploy: `npm run deploy:mainnet`
- [ ] Verify on Etherscan
- [ ] Add liquidity on Uniswap
- [ ] Transfer ownership to multi-sig
- [ ] Renounce or lock admin functions if desired

## Post-Deployment
- [ ] Update `python/monitor.py` with contract address
- [ ] Set up monitoring alerts
- [ ] Document contract address publicly
- [ ] Create token listing on CoinGecko/CMC (optional)
