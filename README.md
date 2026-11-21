# XBM Token

**Modular Security. Fixed Supply.**

Deploy-ready ERC-20 MVP with fixed 410,000,000 supply (18 decimals).

## Live Site
**[bandit-md.github.io/XBM](https://bandit-md.github.io/XBM)**  
(Enable GitHub Pages from the `main` branch / root to activate)

## Specs
- **Ticker**: XBM
- **Decimals**: 18
- **Total Supply**: 410,000,000 (fixed, no mint)
- **Features**: Pausable, Ownable, Token/ETH Recovery
- **Stack**: OpenZeppelin + Hardhat + Python monitoring

## Quick Start
```bash
npm install
cp .env.example .env
# Fill in RPC URL + private key
npm test
npm run deploy:sepolia
```

## Structure
- `contracts/XBM.sol` — Token contract
- `scripts/deploy.js` — Deployment + verification
- `test/XBM.test.js` — Unit tests
- `python/monitor.py` — Transfer monitoring
- `index.html` — Showcase site (GitHub Pages)

## Security
- Fixed supply (no inflation)
- OpenZeppelin audited libraries
- Emergency pause
- Recovery functions
- Full test coverage

See `DEPLOYMENT.md` for the full checklist.

**MIT License**
