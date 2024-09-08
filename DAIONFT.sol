
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title DAIONFT
 * @dev This contract represents the core DAIO NFT, which can later be fractionalized for governance purposes.
 */
contract DAIONFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address public owner;

    constructor() ERC721("DAIONFT", "DAIO") {
        owner = msg.sender; // Contract creator is the owner
    }

    /**
     * @dev Mint a new DAIONFT to the recipient address.
     * Only the owner of the contract can mint new NFTs.
     */
    function mintNFT(address recipient) public returns (uint256) {
        require(msg.sender == owner, "Only owner can mint NFTs");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);

        return newItemId;
    }
}
