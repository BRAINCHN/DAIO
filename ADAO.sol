// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/governance/TimelockController.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract KnowledgeHierarchyDAIO is ReentrancyGuard, Ownable {
    enum SubComponent { Development, Marketing, Community }
    enum Domain { AI, Blockchain, Finance, Healthcare }

    struct Agent {
        uint knowledgeLevel;
        Domain domain;
        bool active;
        uint lastActiveTime;
    }

    struct Proposal {
        uint256 id;
        bool executed;
        string description;
        uint256 voteCountDev;
        uint256 voteCountMarketing;
        uint256 voteCountCommunity;
        uint256 voteCountAI; // Aggregated AI agent vote
    }

    // Agents mapping
    mapping(address => Agent) public agents;

    // Proposal mapping and tracking
    mapping(uint256 => Proposal) public proposals;
    uint256 public proposalCount;

    // Timelock controller for governance-based execution
    TimelockController public timelock;
    uint public totalAgentVotes; // The total weight of AI votes
    uint constant MAX_KNOWLEDGE_LEVEL = 100;
    uint public timeout = 365 days; // Agent activity timeout period

    // Fractionalized NFT mapping for governance
    mapping(uint256 => mapping(address => uint256)) public nftVotes; // Votes by fractionalized NFT holders

    // Mapping to prevent double voting on proposals
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // Events
    event AgentUpdated(address indexed agentAddress, uint knowledgeLevel, Domain domain, bool active);
    event ProposalCreated(uint256 proposalId, string description);
    event ProposalExecuted(uint256 proposalId);
    event AIVoteAggregated(uint256 proposalId, uint256 totalVotes);

    // Modifier to allow only governance actions (timelock executor)
    modifier onlyGovernance() {
        require(timelock.hasRole(timelock.EXECUTOR_ROLE(), msg.sender), "Caller is not governance");
        _;
    }

    // Constructor to set the timelock contract
    constructor(TimelockController _timelock) {
        timelock = _timelock;
    }

    // Function to add or update agents by governance
    function addOrUpdateAgent(
        address _agentAddress,
        uint _knowledgeLevel,
        Domain _domain,
        bool _active
    ) public onlyGovernance {
        require(_knowledgeLevel <= MAX_KNOWLEDGE_LEVEL, "Knowledge level exceeds maximum");
        
        // If agent is being reactivated, reset lastActiveTime
        if (_active) {
            agents[_agentAddress].lastActiveTime = block.timestamp;
        }

        agents[_agentAddress] = Agent({
            knowledgeLevel: _knowledgeLevel,
            domain: _domain,
            active: _active,
            lastActiveTime: block.timestamp
        });
        
        emit AgentUpdated(_agentAddress, _knowledgeLevel, _domain, _active);
    }

    // Function to deactivate agents that have been inactive for a certain period
    function deactivateInactiveAgents(uint batchSize) public onlyGovernance {
        uint deactivatedCount = 0;
        
        for (uint i = 0; i < proposalCount && deactivatedCount < batchSize; i++) {
            address agentAddress = address(i); // Example: looping through addresses (this can be optimized)
            
            if (agents[agentAddress].active && block.timestamp - agents[agentAddress].lastActiveTime >= timeout) {
                agents[agentAddress].active = false;
                deactivatedCount++;
            }
        }
    }

    // Create a new proposal
    function createProposal(string memory description) public onlyGovernance {
        proposalCount++;
        proposals[proposalCount] = Proposal(proposalCount, false, description, 0, 0, 0, 0);
        emit ProposalCreated(proposalCount, description);
    }

    // Voting within subcomponents (Development, Marketing, Community)
    function voteOnProposal(
        uint256 proposalId,
        SubComponent subComponent,
        bool support
    ) public nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        // Cast vote based on the subcomponent
        if (subComponent == SubComponent.Development) {
            proposal.voteCountDev += support ? 1 : 0;
        } else if (subComponent == SubComponent.Marketing) {
            proposal.voteCountMarketing += support ? 1 : 0;
        } else if (subComponent == SubComponent.Community) {
            proposal.voteCountCommunity += support ? 1 : 0;
        }

        // Mark that this voter has voted on this proposal
        hasVoted[proposalId][msg.sender] = true;
    }

    // AI agent voting system, contributing 1/3 to total votes
    function agentVote(uint256 proposalId, bool support) public nonReentrant {
        Agent storage agent = agents[msg.sender];
        require(agent.active, "Agent must be active to vote");
        require(agent.knowledgeLevel > 0, "Agent has no voting power");
        require(!hasVoted[proposalId][msg.sender], "Already voted");

        Proposal storage proposal = proposals[proposalId];
        proposal.voteCountAI += support ? agent.knowledgeLevel : 0;
        hasVoted[proposalId][msg.sender] = true;

        emit AIVoteAggregated(proposalId, proposal.voteCountAI);
    }

    // Aggregates votes across all subcomponents and AI to determine proposal execution
    function aggregateVotes(uint256 proposalId) public view returns (bool) {
        Proposal storage proposal = proposals[proposalId];
        uint256 totalVotes = proposal.voteCountDev + proposal.voteCountMarketing + proposal.voteCountCommunity + proposal.voteCountAI;
        uint256 totalRequiredVotes = (proposal.voteCountDev + proposal.voteCountMarketing + proposal.voteCountCommunity) / 3 * 2; // 2/3 of non-AI votes
        return totalVotes >= totalRequiredVotes;
    }

    // Function to execute proposals based on votes and 1/3 AI vote contribution
    function executeProposal(uint256 proposalId) public onlyGovernance nonReentrant {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");

        if (aggregateVotes(proposalId)) {
            proposal.executed = true;
            emit ProposalExecuted(proposalId);
        }
    }

    // Fractionalized NFT vote for agent creation or proposal
    function createAgentVote(
        uint256 nftTokenId,
        address _agentAddress,
        uint256 _knowledgeLevel,
        Domain _domain
    ) public nonReentrant {
        require(nftVotes[nftTokenId][msg.sender] > 0, "You do not have voting power");

        // Create new agent if consensus is reached
        if (checkNFTConsensus(nftTokenId)) {
            addOrUpdateAgent(_agentAddress, _knowledgeLevel, _domain, true);
        }
    }

    // Function to check consensus among fractionalized NFT holders
    function checkNFTConsensus(uint256 nftTokenId) internal view returns (bool) {
        uint256 totalVotes = 0;
        uint256 voteCount = 0;

        // Loop through all votes for a specific NFT token ID
        for (uint i = 0; i < nftVotes[nftTokenId].length; i++) {
            totalVotes += nftVotes[nftTokenId][msg.sender];
            voteCount++;
        }

        // Require a 2/3 majority
        return totalVotes > 2 * voteCount / 3;
    }
}
