// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title XBM Token
 * @notice Fixed-supply modular ERC-20 cryptocurrency
 * @dev
 * - Decimals: 18
 * - Total Supply: 410,000,000 (fixed, minted once)
 * - Modular design using OpenZeppelin
 * - Owner can pause transfers in emergency
 * - Safe recovery of accidentally sent tokens/ETH
 */
contract XBM is ERC20, Ownable, Pausable {
    using SafeERC20 for IERC20;

    uint256 public constant TOTAL_SUPPLY = 410_000_000 * 10**18;

    event TokensRecovered(address indexed token, uint256 amount);
    event ETHRecovered(uint256 amount);

    constructor(address initialOwner)
        ERC20("XBM", "XBM")
        Ownable(initialOwner)
    {
        _mint(initialOwner, TOTAL_SUPPLY);
    }

    /**
     * @dev Pause all token transfers (emergency only)
     * Note: Recovery functions remain available while paused
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev Unpause token transfers
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev Override to enforce pause on all transfers, mints, and burns
     */
    function _update(address from, address to, uint256 value)
        internal
        override
        whenNotPaused
    {
        super._update(from, to, value);
    }

    /**
     * @dev Recover ERC20 tokens accidentally sent to this contract
     * Uses SafeERC20 to handle non-standard tokens safely
     */
    function recoverERC20(address tokenAddress, uint256 tokenAmount)
        external
        onlyOwner
    {
        require(tokenAddress != address(this), "Cannot recover XBM");
        IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
        emit TokensRecovered(tokenAddress, tokenAmount);
    }

    /**
     * @dev Recover ETH accidentally sent to this contract
     */
    function recoverETH() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to recover");
        (bool success, ) = owner().call{value: balance}("");
        require(success, "ETH recovery failed");
        emit ETHRecovered(balance);
    }

    // Allow receiving ETH
    receive() external payable {}
}
