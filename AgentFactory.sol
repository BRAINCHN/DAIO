// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AgentFactory {
    // Structure for an agent
    struct Agent {
        address agentAddress;
        bool active;
        uint createdAt;
        string metadata;
    }

    // Mapping of agents by their public address
    mapping(address => Agent) public agents;

    // Events
    event AgentCreated(address indexed agentAddress, uint timestamp);
    event AgentDestroyed(address indexed agentAddress, uint timestamp);

    // Modifier to restrict access to governance systems
    address public governanceContract;

    constructor(address _governanceContract) {
        governanceContract = _governanceContract;
    }

    modifier onlyGovernance() {
        require(msg.sender == governanceContract, "Only the governance contract can perform this action");
        _;
    }

    // Function to create an agent (restricted to DAIO governance)
    function createAgent(address _agentAddress, string memory _metadata) external onlyGovernance {
        require(!agents[_agentAddress].active, "Agent already exists");

        agents[_agentAddress] = Agent({
            agentAddress: _agentAddress,
            active: true,
            createdAt: block.timestamp,
            metadata: _metadata
        });

        emit AgentCreated(_agentAddress, block.timestamp);
    }

    // Function to destroy an agent (restricted to DAIO governance)
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
