// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CustomToken is ERC20, Ownable {
    constructor(string memory name, string memory symbol, address initialOwner) ERC20(name, symbol) {
        _mint(initialOwner, 1000 * 10 ** decimals());  // Mint initial tokens to the agent
        transferOwnership(initialOwner);  // Transfer ownership to the agent
    }

    // Allow the agent to mint more tokens
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Allow the agent to burn tokens
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}

