// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AgentFactory is Ownable, ERC721URIStorage {
    // Structure for an agent
    struct Agent {
        address agentAddress;
        bool active;
        uint createdAt;
        address tokenAddress;   // Custom ERC20 token address associated with the agent
        uint256 nftId;          // NFT ID representing the agent's governance rights
        bytes32 metadataHash;   // Storing metadata as a hash for gas optimization
    }

    // Mapping of agents by their public address
    mapping(address => Agent> public agents;

    // Governance contract that can create/destroy agents, set once during deployment and immutable thereafter
    address public immutable governanceContract;
    uint256 public agentCount; // Counter for NFT agent creation

    // Events
    event AgentCreated(address indexed agentAddress, uint timestamp, bytes32 metadataHash, address tokenAddress, uint256 nftId);
    event AgentDestroyed(address indexed agentAddress, uint timestamp);
    event AgentReactivated(address indexed agentAddress, uint timestamp);

    // Modifier to restrict access to governance systems
    modifier onlyGovernance() {
        require(msg.sender == governanceContract, "Only the governance contract can perform this action");
        _;
    }

    // Constructor to set the governance contract, immutable after deployment
    constructor(address _governanceContract) ERC721("AgentNFTCollection", "ANFT") {
        require(_governanceContract != address(0), "Invalid governance address");
        governanceContract = _governanceContract;
    }

    // Function to create an agent (restricted to governance contract)
    // Creates a custom ERC20 token for the agent and assigns a dynamic fractionalized NFT to represent the agent's governance
    function createAgent(address _agentAddress, bytes32 _metadataHash, string memory _tokenName, string memory _tokenSymbol, string memory _nftMetadata) external onlyGovernance {
        require(!agents[_agentAddress].active, "Agent already exists");

        // Create a custom token for the agent
        CustomToken customToken = new CustomToken(_tokenName, _tokenSymbol, _agentAddress);
        address tokenAddress = address(customToken);

        // Create a fractionalized dynamic NFT for the agent
        agentCount++;
        uint256 nftId = agentCount;
        _mint(_agentAddress, nftId);  // Mint the NFT
        _setTokenURI(nftId, _nftMetadata);  // Set NFT metadata

        // Store agent details
        agents[_agentAddress] = Agent({
            agentAddress: _agentAddress,
            active: true,
            createdAt: block.timestamp,
            tokenAddress: tokenAddress,
            nftId: nftId,
            metadataHash: _metadataHash
        });

        // Emit the AgentCreated event
        emit AgentCreated(_agentAddress, block.timestamp, _metadataHash, tokenAddress, nftId);
    }

    // Function to update the NFT metadata dynamically (can be called by the agent)
    function updateNFTMetadata(uint256 nftId, string memory newMetadata) external {
        require(ownerOf(nftId) == msg.sender, "Only the owner can update the metadata");
        _setTokenURI(nftId, newMetadata);
    }

    // Function to reactivate an inactive agent (restricted to governance contract)
    function reactivateAgent(address _agentAddress) external onlyGovernance {
        require(!agents[_agentAddress].active, "Agent is already active");
        require(agents[_agentAddress].agentAddress != address(0), "Agent does not exist");

        agents[_agentAddress].active = true;

        emit AgentReactivated(_agentAddress, block.timestamp);
    }

    // Function to destroy an agent (restricted to governance contract)
    function destroyAgent(address _agentAddress) external onlyGovernance {
        require(agents[_agentAddress].active, "Agent is already inactive");

        agents[_agentAddress].active = false;

        emit AgentDestroyed(_agentAddress, block.timestamp);
    }

    // Check if an agent is active
    function isAgentActive(address _agentAddress) external view returns (bool) {
        return agents[_agentAddress].active;
    }
}
