# DAIO: Decentralized Autonomous Intelligent Organization

This project is alpha and is posted for research purposes only. There are intentional errors in the compile to make sure this does not get set free before the audit

a framework for Decentralized Agency

The Decentralized Autonomous Intelligent Organization (DAIO) is an advanced governance model that combines fractionalized NFT voting and token-based ERC20 governance with AI influence. The system is designed to enable decentralized decision-making for organizations where both human and AI votes play a role in reaching consensus.

This repository contains two distinct governance contracts:

    FractionalizedNFTVoting: A governance model where voting power is based on fractionalized NFTs, with 2/3 AI voting influence in each subcomponent (Development, Marketing, and Community).
    ERC20AgentGovernance: A governance model using ERC20 tokens for voting on proposals, including creating agents, with AI having voting power in each subcomponent.

The repository also includes the full DAIO White Paper, which describes the overarching architecture, goals, and use cases for the DAIO system.

Project Structure
```bash
├── contracts/
│   ├── FractionalizedNFTVoting.sol     # Governance contract using fractionalized NFTs with AI voting
│   ├── ERC20AgentGovernance.sol        # Governance contract using ERC20 token-based voting for agent creation
├── README.md                           # Project documentation
├── DAIO-Whitepaper.md                  # The complete DAIO whitepaper
```
Core Components

    FractionalizedNFTVoting.sol:
        This contract implements a governance system based on fractionalized NFTs. The governance is divided into three subcomponents—Development, Marketing, and Community. AI holds one vote in each subcomponent, ensuring that decisions are made based on both human and AI votes.
        A proposal passes if 2/3 subcomponents (e.g., Development and Marketing) approve it, and within each subcomponent, 2/3 of the votes must be in favor.

    ERC20AgentGovernance.sol:
        This contract is based on the OpenZeppelin Governor contract, extended with token-based governance (ERC20Votes). It introduces a governance system for proposing and creating new agents via the AgentFactory contract.
        Proposals are voted on using ERC20 tokens, and AI has a 1/3 voting share in each subcomponent (Development, Marketing, and Community). A proposal passes with 2/3 subcomponent approval, and it uses Timelock to enforce time delays between proposal passing and execution.

    DAIO-Whitepaper.md:
        The white paper describes the DAIO architecture, including the philosophical approach behind the fusion of decentralized human governance with AI-driven decision-making. It details the use cases, technical architecture, and potential future directions for the DAIO.

Contracts Breakdown
FractionalizedNFTVoting.sol

This contract implements a voting system where governance power is derived from fractionalized NFTs. Each proposal is voted on by three subcomponents: Development, Marketing, and Community. AI has one vote in each subcomponent, and a proposal passes if 2 out of 3 subcomponents approve it.

    createProposal(string description): This function allows users to create new proposals.
    voteOnProposal(uint256 proposalId, SubComponent subComponent, bool support, bool isAI): This function allows subcomponents (and AI) to vote on proposals.
    aiVote(uint256 proposalId, SubComponent subComponent, bool support): This function allows AI to cast its vote in each subcomponent.
    executeProposal(uint256 proposalId): This function executes the proposal if 2/3 subcomponents approve it.

ERC20AgentGovernance.sol

This contract builds on OpenZeppelin's governance model using ERC20Votes for proposal voting. It's used to govern the creation of new agents within the DAIO ecosystem. The voting process includes AI participation and uses a timelock for execution.

    proposeAgentCreation(address agentAddress, string memory metadata, string memory description): Allows users to propose the creation of new agents.
    aiVote(uint256 proposalId, SubComponent subComponent, bool support): AI's voting mechanism, applied in the three subcomponents.
    _execute(uint256 proposalId, address[] memory targets, uint256[] memory values, bytes[] memory calldatas, bytes32 descriptionHash): Executes proposals after the voting and timelock period has passed.


Use Case Example:

    FractionalizedNFTVoting:
        Scenario: A DAIO governed by NFTs votes on a proposal to upgrade the system. Each subcomponent (Development, Marketing, Community) votes, including AI. If the proposal is approved by 2/3 subcomponents, it is executed.

    ERC20AgentGovernance:
        Scenario: Token holders propose to create a new agent in the DAIO system. The proposal undergoes voting using ERC20 tokens, and AI participates in each subcomponent (Development, Marketing, Community). A timelock ensures a delay before execution, allowing time for review and potential vetoes.

Whitepaper

The white paper is included in the repository as DAIO-Whitepaper.md, detailing the following:

    Introduction: Describes the purpose of the DAIO, its vision, and how it integrates AI with decentralized governance.
    Governance Models: Explains both the fractionalized NFT voting system and the ERC20 token-based governance system, including the unique AI influence in each.
    Voting Mechanism: Outlines how AI participates in voting alongside human voters and how the 2/3 majority rule is applied across subcomponents (Development, Marketing, and Community).
    Future Directions: Discusses potential future implementations, including cross-chain governance, advanced AI models, and tokenomics improvements.

