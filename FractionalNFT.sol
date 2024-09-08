// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/**
 * @title FractionalNFT
 * @dev This contract fractionalizes the ERC721 NFT into ERC20 tokens, representing ownership fractions.
 */
contract FractionalNFT is ERC20 {
    address public nftAddress;
    uint256 public nftId;
    uint256 public totalFractions;

    /**
     * @dev Initializes the fractionalization of the NFT.
     * @param _nftAddress Address of the original NFT contract.
     * @param _nftId ID of the NFT being fractionalized.
     * @param _totalFractions Total number of fractions to be created.
     */
    constructor(address _nftAddress, uint256 _nftId, uint256 _totalFractions)
        ERC20("FractionalNFT", "F-NFT")
    {
        nftAddress = _nftAddress;
        nftId = _nftId;
        totalFractions = _totalFractions;

        // Mint totalFractions ERC20 tokens to the contract creator.
        _mint(msg.sender, totalFractions);
    }

    /**
     * @dev Redeem function allows a holder to redeem fractions and claim the full NFT if they hold all fractions.
     */
    function redeemNFT() public {
        require(balanceOf(msg.sender) == totalSupply(), "You need all the fractions to redeem the NFT");

        // Transfer ownership of the NFT back to the redeemer.
        IERC721(nftAddress).transferFrom(address(this), msg.sender, nftId);
    }
}

