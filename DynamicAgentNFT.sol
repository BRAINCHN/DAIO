// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./AgentManager.sol";

contract DynamicAgentNFT is ERC721URIStorage, Ownable {

    // Struct to hold upgrade history
    struct Upgrade {
        uint256 tokenId;
        string oldURI;
        string newURI;
        uint256 timestamp;
    }

    // Mapping to track upgrade history of each tokenId
    mapping(uint256 => Upgrade[]) public upgradeHistory;

    // Initial base URIs for each tokenId
    mapping(uint256 => string) public baseTokenURIs;

    // Event to log metadata upgrades
    event MetadataUpgraded(uint256 indexed tokenId, string oldURI, string newURI, uint256 timestamp);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    /**
     * @dev Mints a new NFT with an initial metadata URI.
     * @param to The address to mint the NFT to.
     * @param tokenId The token ID of the new NFT.
     * @param tokenURI The initial metadata URI of the new NFT.
     */
    function mintNFT(address to, uint256 tokenId, string memory tokenURI) public onlyOwner {
        _mint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        baseTokenURIs[tokenId] = tokenURI; // Save the base URI for future upgrades
    }

    /**
     * @dev Upgrades the NFT metadata based on agent actions.
     * @param tokenId The token ID of the NFT to upgrade.
     * @param action The action performed by the agent.
     */
    function upgradeBasedOnAction(uint256 tokenId, string memory action) internal {
        require(_exists(tokenId), "ERC721: token does not exist");

        // Get the current and new URIs for upgrade
        string memory oldTokenURI = tokenURI(tokenId);
        string memory newTokenURI = string(abi.encodePacked(baseTokenURIs[tokenId], "/", action, ".json"));

        // Update the token's metadata URI
        _setTokenURI(tokenId, newTokenURI);

        // Store upgrade history
        upgradeHistory[tokenId].push(Upgrade({
            tokenId: tokenId,
            oldURI: oldTokenURI,
            newURI: newTokenURI,
            timestamp: block.timestamp
        }));

        // Emit the upgrade event
        emit MetadataUpgraded(tokenId, oldTokenURI, newTokenURI, block.timestamp);
    }

    /**
     * @dev Called when an agent completes an action, triggers the NFT metadata upgrade.
     * @param agentAddress The address of the agent who completed the action.
     * @param action The action performed by the agent.
     */
    function onAgentActionCompleted(address agentAddress, string memory action) external {
        // Assume this contract is allowed to call the AgentManager contract
        AgentManager manager = AgentManager(msg.sender);
        uint256 tokenId = manager.agents(agentAddress).nftId;

        // Upgrade the NFT metadata based on the agent's action
        upgradeBasedOnAction(tokenId, action);
    }

    /**
     * @dev Get the full upgrade history of a token.
     * @param tokenId The token ID to get the upgrade history for.
     * @return An array of Upgrade structs containing metadata changes.
     */
    function getUpgradeHistory(uint256 tokenId) public view returns (Upgrade[] memory) {
        return upgradeHistory[tokenId];
    }
}

