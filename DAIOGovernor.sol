// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/Governor.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorSettings.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotes.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorVotesQuorumFraction.sol";
import "@openzeppelin/contracts/governance/extensions/GovernorTimelockControl.sol";
import "./AgentFactory.sol";

contract DAIOGovernor is Governor, GovernorSettings, GovernorVotes, GovernorVotesQuorumFraction, GovernorTimelockControl {
    AgentFactory public agentFactory;

    constructor(
        ERC20Votes _token,
        TimelockController _timelock,
        AgentFactory _agentFactory
    )
        Governor("DAIOGovernor")
        GovernorSettings(1 /* 1 block */, 45818 /* 1 week */, 1) // Voting delay, voting period, proposal threshold
        GovernorVotes(_token)
        GovernorVotesQuorumFraction(4) // 4% quorum for proposals
        GovernorTimelockControl(_timelock)
    {
        agentFactory = _agentFactory;
    }

    // Example proposal to create a new agent
    function proposeAgentCreation(
        address _agentAddress, 
        string memory _metadata, 
        string memory description
    ) public returns (uint256) {
        address[] memory targets = new address[](1);
        targets[0] = address(agentFactory);

        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = abi.encodeWithSignature("createAgent(address,string)", _agentAddress, _metadata);

        return propose(targets, new uint , calldatas, description);
    }

    // Override functions for voting, quorum, execution, etc., as necessary
    function _execute(
        uint256 proposalId, 
        address[] memory targets, 
        uint256[] memory values, 
        bytes[] memory calldatas, 
        bytes32 descriptionHash
    ) internal override(Governor, GovernorTimelockControl) {
        super._execute(proposalId, targets, values, calldatas, descriptionHash);
    }

    function _executor() internal view override(Governor, GovernorTimelockControl) returns (address) {
        return super._executor();
    }
}

