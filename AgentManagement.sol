// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AgentFactory.sol";

contract AgentManagement {
    AgentFactory public agentFactory;
    uint public inactivityTimeout = 365 days;  // Default inactivity timeout

    // Events
    event AgentUpdated(address indexed agentAddress, bool active, uint timestamp);
    event AgentDeactivatedDueToInactivity(address indexed agentAddress, uint timestamp);

    constructor(AgentFactory _agentFactory) {
        agentFactory = _agentFactory;
    }

    // Update agent metadata (only by governance)
    function updateAgentMetadata(address _agentAddress, string memory _newMetadata) external {
        require(agentFactory.isAgentActive(_agentAddress), "Agent is not active");
        
        // Update the metadata in AgentFactory
        agentFactory.updateMetadata(_agentAddress, _newMetadata);

        // Emit an update event
        emit AgentUpdated(_agentAddress, true, block.timestamp);
    }

    // Deactivate agent due to inactivity
    function deactivateInactiveAgent(address _agentAddress) external {
        AgentFactory.Agent memory agent = agentFactory.agents(_agentAddress);
        require(agent.active, "Agent is already inactive");

        // Check if the agent has been inactive for too long
        if (block.timestamp - agent.lastActivity > inactivityTimeout) {
            // Mark agent as inactive (destroyed)
            agentFactory.destroyAgent(_agentAddress);

            // Emit event
            emit AgentDeactivatedDueToInactivity(_agentAddress, block.timestamp);
        }
    }
}
