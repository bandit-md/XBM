// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title XBM Token
 * @notice Fixed-supply modular ERC-20 cryptocurrency
 * @dev 
 * - Decimals: 18
 * - Total Supply: 410,000,000
 * - Modular design using OpenZeppelin
 * - Owner can pause transfers in emergency
 * - Fixed supply (no mint after deployment)
 * - Recover accidentally sent tokens
 */
contract XBM is ERC20, Ownable, Pausable {
    uint256 public constant TOTAL_SUPPLY = 410_000_000 * 10**18;

    event TokensRecovered(address indexed token, uint256 amount);

    constructor(address initialOwner) 
        ERC20("XBM", "XBM") 
        Ownable(initialOwner) 
    {
        _mint(initialOwner, TOTAL_SUPPLY);
    }

    /**
     * @dev Pause all token transfers (emergency only)
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
     * @dev Override transfer to check pause status
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
     */
    function recoverERC20(address tokenAddress, uint256 tokenAmount) 
        external 
        onlyOwner 
    {
        require(tokenAddress != address(this), "Cannot recover XBM");
        IERC20(tokenAddress).transfer(owner(), tokenAmount);
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
    }

    // Allow receiving ETH
    receive() external payable {}
}
