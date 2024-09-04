// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AgentFactory {
    // Structure for an agent
    struct Agent {
        address agentAddress;  // The agent's public address (derived from private key)
        bool active;           // Status of the agent (active/inactive)
        uint createdAt;        // Timestamp when the agent was created
        string metadata;       // Additional metadata related to the agent (off-chain)
    }

    // Mapping of agents by their public address
    mapping(address => Agent) public agents;

    // Events
    event AgentCreated(address indexed agentAddress, uint timestamp);
    event AgentDestroyed(address indexed agentAddress, uint timestamp);

    // Create a new agent
    function createAgent(address _agentAddress, string memory _metadata) external {
        require(agents[_agentAddress].agentAddress == address(0), "Agent already exists");

        // Add the agent's public key and other details
        agents[_agentAddress] = Agent({
            agentAddress: _agentAddress,
            active: true,
            createdAt: block.timestamp,
            metadata: _metadata
        });

        // Emit an event for the creation of a new agent
        emit AgentCreated(_agentAddress, block.timestamp);
    }

    // Destroy an existing agent
    function destroyAgent(address _agentAddress) external {
        require(agents[_agentAddress].active, "Agent is already inactive");

        // Mark the agent as inactive (agent destroyed)
        agents[_agentAddress].active = false;

        // Emit an event for the destruction of the agent
        emit AgentDestroyed(_agentAddress, block.timestamp);
    }

    // Check if an agent is active
    function isAgentActive(address _agentAddress) external view returns (bool) {
        return agents[_agentAddress].active;
    }
}
