# Security Considerations

## Design
- **Fixed Supply**: 410,000,000 XBM minted once in the constructor. No mint function exists after deployment.
- **OpenZeppelin**: Uses audited ERC20, Ownable, Pausable, and SafeERC20 from OpenZeppelin v5.
- **Pause**: Owner can pause all transfers via `_update` override. Recovery functions remain available while paused.
- **Recovery**: Owner can recover accidentally sent ERC20s (via SafeERC20) and ETH. Cannot recover the token itself.

## Centralization Risks
The owner has the following privileged functions:
- `pause()` / `unpause()`
- `recoverERC20()`
- `recoverETH()`
- `transferOwnership()` / `renounceOwnership()`

**Recommendation for mainnet**: Transfer ownership to a multi-sig (e.g. Gnosis Safe) immediately after deployment, or renounce ownership if no admin functions are needed long-term.

## Audit Status
This is an MVP. The contract is intentionally simple and based on battle-tested OpenZeppelin code, but it has **not** undergone a professional third-party audit.

Before any mainnet deployment with significant value, a formal audit is strongly recommended.

## Reporting
If you discover a vulnerability, please open an issue or contact the repository owner privately.
