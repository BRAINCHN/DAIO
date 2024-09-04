
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DAIOGovernanceToken is ERC20Votes {
    constructor() ERC20("GOV", "DAIO") ERC20Permit("GOV") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mint 1 million tokens to the deployer
    }

    // Override functions for voting power tracking
    function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount) internal override(ERC20Votes) {
        super._mint(to, amount);
    }

    function _burn(address from, uint256 amount) internal override(ERC20Votes) {
        super._burn(from, amount);
    }
}
