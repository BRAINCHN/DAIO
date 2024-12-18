// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import OpenZeppelin contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernanceDynamicNFT is ERC721URIStorage, Ownable {
    uint256 public tokenIdCounter; // Counter for token IDs
    mapping(uint256 => string) public tokenMetadataURIs; // Store metadata URIs for each token

    // Event to notify metadata updates
    event MetadataUpdated(uint256 indexed tokenId, string newURI);

    /**
     * @notice Constructor to initialize the contract with a name, symbol, and initial owner.
     * @param initialOwner Address to be set as the initial owner of the contract.
     */
    constructor(address initialOwner) ERC721("Governance Dynamic NFT", "dNFT") Ownable(initialOwner) {}

    /**
     * @notice Mint a new dynamic NFT.
     * @param recipient The address of the recipient.
     * @param metadataURI The initial metadata URI (e.g., IPFS CID).
     */
    function mint(address recipient, string memory metadataURI) external onlyOwner {
        uint256 newTokenId = tokenIdCounter; // Generate a new token ID
        _safeMint(recipient, newTokenId); // Safely mint the token
        _setTokenURI(newTokenId, metadataURI); // Set the token's metadata URI
        tokenMetadataURIs[newTokenId] = metadataURI; // Store metadata URI in mapping
        tokenIdCounter++; // Increment token ID counter
    }

    /**
     * @notice Update the metadata URI for an existing token.
     * @param tokenId The ID of the token to update.
     * @param newMetadataURI The new metadata URI (e.g., updated IPFS CID).
     */
    function updateMetadata(uint256 tokenId, string memory newMetadataURI) external onlyOwner {
        // Check if the token exists
        require(ownerOf(tokenId) != address(0), "Token does not exist");

        _setTokenURI(tokenId, newMetadataURI); // Update the token's metadata URI
        tokenMetadataURIs[tokenId] = newMetadataURI; // Store updated metadata URI in mapping
        emit MetadataUpdated(tokenId, newMetadataURI); // Emit event for metadata update
    }
}
