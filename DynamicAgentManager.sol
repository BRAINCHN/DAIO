// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DynamicAgentNFT.sol";

contract AgentManager {
    struct Agent {
        address agentAddress;
        bool active;
        uint createdAt;
        uint256 nftId; // Associated NFT ID
        string metadata; // Metadata for agent details
    }

    // Mapping of agents by their address
    mapping(address => Agent) public agents;

    DynamicAgentNFT public nftContract;

    event AgentCreated(address indexed agentAddress, uint256 nftId, uint timestamp);
    event AgentActionCompleted(address indexed agentAddress, string action, uint timestamp);

    constructor(DynamicAgentNFT _nftContract) {
        nftContract = _nftContract;
    }

    /**
     * @dev Creates a new agent associated with a specific NFT.
     * @param _agentAddress The address of the agent to be created.
     * @param _nftId The associated NFT ID.
     * @param _metadata Metadata describing the agent.
     */
    function createAgent(address _agentAddress, uint256 _nftId, string memory _metadata) external {
        require(agents[_agentAddress].agentAddress == address(0), "Agent already exists");

        agents[_agentAddress] = Agent({
            agentAddress: _agentAddress,
            active: true,
            createdAt: block.timestamp,
            nftId: _nftId,
            metadata: _metadata
        });

        emit AgentCreated(_agentAddress, _nftId, block.timestamp);
    }

    /**
     * @dev Logs an action performed by the agent, which triggers the NFT upgrade process.
     * @param _agentAddress The address of the agent performing the action.
     * @param action A string describing the action performed.
     */
    function logAgentAction(address _agentAddress, string memory action) external {
        require(agents[_agentAddress].active, "Agent is not active");

        emit AgentActionCompleted(_agentAddress, action, block.timestamp);

        // Trigger the NFT upgrade based on the agent's action
        nftContract.onAgentActionCompleted(_agentAddress, action);
    }
}

