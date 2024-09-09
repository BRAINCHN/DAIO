// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AgentFactory {
    // Structure for an agent
    struct Agent {
        address agentAddress;
        bool active;
        uint createdAt;
        bytes32 metadataHash; // Storing metadata as a hash for gas optimization
    }

    // Mapping of agents by their public address
    mapping(address => Agent) public agents;

    // Governance contract that can create/destroy agents, set once during deployment and immutable thereafter
    address public immutable governanceContract;

    // Events
    event AgentCreated(address indexed agentAddress, uint timestamp, bytes32 metadataHash);
    event AgentDestroyed(address indexed agentAddress, uint timestamp);
    event AgentReactivated(address indexed agentAddress, uint timestamp);

    // Modifier to restrict access to governance systems
    modifier onlyGovernance() {
        require(msg.sender == governanceContract, "Only the governance contract can perform this action");
        _;
    }

    // Constructor to set the governance contract, immutable after deployment
    constructor(address _governanceContract) {
        require(_governanceContract != address(0), "Invalid governance address");
        governanceContract = _governanceContract;
    }

    // Function to create an agent (restricted to governance contract)
    function createAgent(address _agentAddress, bytes32 _metadataHash) external onlyGovernance {
        require(!agents[_agentAddress].active, "Agent already exists");

        agents[_agentAddress] = Agent({
            agentAddress: _agentAddress,
            active: true,
            createdAt: block.timestamp,
            metadataHash: _metadataHash
        });

        emit AgentCreated(_agentAddress, block.timestamp, _metadataHash);
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
