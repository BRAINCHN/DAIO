// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title FractionalizedNFTVoting
 * @dev Implements fractionalized NFT governance with role-based access control.
 */
contract FractionalizedNFTVoting is ERC721URIStorage, AccessControl {
    // Define roles
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant VOTER_ROLE = keccak256("VOTER_ROLE");

    // Structure representing a proposal
    struct Proposal {
        string description;
        bool executed;
        uint256 yesVotes;
        uint256 noVotes;
        uint256 abstainVotes;
        mapping(address => bool) hasVoted;
        address[] voters;
    }

    uint256 public proposalCounter; // Counter for unique proposals
    mapping(uint256 => Proposal) public proposals; // Mapping of proposals by ID

    // Events
    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter, uint8 voteType);
    event ProposalExecuted(uint256 indexed proposalId);

    /**
     * @dev Constructor to initialize the contract with an admin address.
     * @param admin The address to be assigned the DEFAULT_ADMIN_ROLE and ADMIN_ROLE.
     */
    constructor(address admin) ERC721("fractioThe code is written in Solidity, a programming language used for Ethereum smart contracts.

Error Explanation:
The DeclarationError occurs because _exists() function is not declared anywhere in this contract or its dependencies (imported OpenZeppelin contracts). The error message points to the line where it's being called with an argument (_exists(tokenId)).

Solution:

To fix this, you need to import and use the correct OpenZeppelin contract that provides _exists() function. In your case, since ERC721URIStorage is already imported from @openzeppelin/contracts/token/ERC721/extensions, it's likely that _exists() should be used directly on an instance of a token (e.g., with token._exists(tokenId)).

However, looking at the OpenZeppelin ERC-721 implementation (ERC721.sol) and its extensions like ERC721URIStorage or even your contract itself doesn't seem to have any direct reference for _exists() method. This might be because it's intended usage is not directly applicable here.

Given that this function should check if a token exists, we can simply remove the require statement altogether as you're already calling _safeMint(recipient, newTokenId) which will throw an exception when trying to mint a non-existent token ID:

function updateMetadata(uint256 tokenId, string memory newMetadataURI) external onlyOwner {
    _setTokenURI(tokenId, newMetadataURI);
    tokenMetadataURIs[tokenId] = newMetadataURI;
    emit MetadataUpdated(tokenId, newMetadataURI);
}

Alternatively (if you really need to check if the token exists), use token._exists() instead of _exists(), assuming that's how it should be called in your contract.

DeclarationError: Undeclared identifier.
--> dNFT3.sol:44:9:
|
44 | _setupRole(DEFAULT_ADMIN_ROLE, admin);
| ^^^^^^^^^^

The error occurs because DEFAULT_ADMIN_ROLE is not a valid role identifier.

In Solidity versions (which this code uses), you can't use hardcoded roles like keccak256("ADMIN_ROLE"). Instead, you should define the admin role in your contract using _setupRole() function and then pass it to other functions that require access control checks.

To fix the error:

bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
_setupRole(ADMIN_ROLE, admin);

This will define ADMIN_ROLE as a valid role identifier and assign it to your contract.

However, if you want to use DEFAULT_ADMIN_ROLE, which is provided by OpenZeppelin's AccessControl contracts (like in their examples), then simply import the correct library:The code is written in Solidity, a programming language used for Ethereum smart contracts.

Error Explanation:
The DeclarationError occurs because _exists() function is not declared anywhere in this contract or its dependencies (imported OpenZeppelin contracts). The error message points to the line where it's being called with an argument (_exists(tokenId)).

Solution:

To fix this, you need to import and use the correct OpenZeppelin contract that provides _exists() function. In your case, since ERC721URIStorage is already imported from @openzeppelin/contracts/token/ERC721/extensions, it's likely that _exists() should be used directly on an instance of a token (e.g., with token._exists(tokenId)).

However, looking at the OpenZeppelin ERC-721 implementation (ERC721.sol) and its extensions like ERC721URIStorage or even your contract itself doesn't seem to have any direct reference for _exists() method. This might be because it's intended usage is not directly applicable here.

Given that this function should check if a token exists, we can simply remove the require statement altogether as you're already calling _safeMint(recipient, newTokenId) which will throw an exception when trying to mint a non-existent token ID:

function updateMetadata(uint256 tokenId, string memory newMetadataURI) external onlyOwner {
    _setTokenURI(tokenId, newMetadataURI);
    tokenMetadataURIs[tokenId] = newMetadataURI;
    emit MetadataUpdated(tokenId, newMetadataURI);
}

Alternatively (if you really need to check if the token exists), use token._exists() instead of _exists(), assuming that's how it should be called in your contract.

DeclarationError: Undeclared identifier.
--> dNFT3.sol:44:9:
|
44 | _setupRole(DEFAULT_ADMIN_ROLE, admin);
| ^^^^^^^^^^

The error occurs because DEFAULT_ADMIN_ROLE is not a valid role identifier.

In Solidity versions (which this code uses), you can't use hardcoded roles like keccak256("ADMIN_ROLE"). Instead, you should define the admin role in your contract using _setupRole() function and then pass it to other functions that require access control checks.

To fix the error:

bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
_setupRole(ADMIN_ROLE, admin);

This will define ADMIN_ROLE as a valid role identifier and assign it to your contract.

However, if you want to use DEFAULT_ADMIN_ROLE, which is provided by OpenZeppelin's AccessControl contracts (like in their examples), then simply import the correct library:The code is written in Solidity, a programming language used for Ethereum smart contracts.

Error Explanation:
The DeclarationError occurs because _exists() function is not declared anywhere in this contract or its dependencies (imported OpenZeppelin contracts). The error message points to the line where it's being called with an argument (_exists(tokenId)).

Solution:

To fix this, you need to import and use the correct OpenZeppelin contract that provides _exists() function. In your case, since ERC721URIStorage is already imported from @openzeppelin/contracts/token/ERC721/extensions, it's likely that _exists() should be used directly on an instance of a token (e.g., with token._exists(tokenId)).

However, looking at the OpenZeppelin ERC-721 implementation (ERC721.sol) and its extensions like ERC721URIStorage or even your contract itself doesn't seem to have any direct reference for _exists() method. This might be because it's intended usage is not directly applicable here.

Given that this function should check if a token exists, we can simply remove the require statement altogether as you're already calling _safeMint(recipient, newTokenId) which will throw an exception when trying to mint a non-existent token ID:

function updateMetadata(uint256 tokenId, string memory newMetadataURI) external onlyOwner {
    _setTokenURI(tokenId, newMetadataURI);
    tokenMetadataURIs[tokenId] = newMetadataURI;
    emit MetadataUpdated(tokenId, newMetadataURI);
}

Alternatively (if you really need to check if the token exists), use token._exists() instead of _exists(), assuming that's how it should be called in your contract.

DeclarationError: Undeclared identifier.
--> dNFT3.sol:44:9:
|
44 | _setupRole(DEFAULT_ADMIN_ROLE, admin);
| ^^^^^^^^^^

The error occurs because DEFAULT_ADMIN_ROLE is not a valid role identifier.

In Solidity versions (which this code uses), you can't use hardcoded roles like keccak256("ADMIN_ROLE"). Instead, you should define the admin role in your contract using _setupRole() function and then pass it to other functions that require access control checks.

To fix the error:

bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
_setupRole(ADMIN_ROLE, admin);

This will define ADMIN_ROLE as a valid role identifier and assign it to your contract.

However, if you want to use DEFAULT_ADMIN_ROLE, which is provided by OpenZeppelin's AccessControl contracts (like in their examples), then simply import the correct library:NFT", "fNFT") {
        require(admin != address(0), "Admin address cannot be zero");

        // Grant roles
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(ADMIN_ROLE, admin);
    }

    /**
     * @dev Override supportsInterface to resolve ambiguity caused by multiple inheritance.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /**
     * @notice Create a new proposal.
     * @param description A brief description of the proposal.
     */
    function createProposal(string memory description) external onlyRole(ADMIN_ROLE) {
        require(bytes(description).length > 0, "Proposal description cannot be empty");

        Proposal storage newProposal = proposals[proposalCounter];
        newProposal.description = description;
        newProposal.executed = false;

        emit ProposalCreated(proposalCounter, description);

        proposalCounter++;
    }

    /**
     * @notice Vote on an active proposal.
     * @param proposalId The ID of the proposal to vote on.
     * @param voteType The type of vote (1 = Yes, 2 = No, 3 = Abstain).
     */
    function vote(uint256 proposalId, uint8 voteType) external onlyRole(VOTER_ROLE) {
        require(proposalId < proposalCounter, "Invalid proposal ID");
        require(voteType >= 1 && voteType <= 3, "Invalid vote type");

        Proposal storage proposal = proposals[proposalId];
        require(!proposal.hasVoted[msg.sender], "You have already voted");

        if (voteType == 1) {
            proposal.yesVotes++;
        } else if (voteType == 2) {
            proposal.noVotes++;
        } else {
            proposal.abstainVotes++;
        }

        proposal.hasVoted[msg.sender] = true;
        proposal.voters.push(msg.sender);

        emit Voted(proposalId, msg.sender, voteType);
    }

    /**
     * @notice Execute a proposal if it meets the 2/3 majority rule.
     * @param proposalId The ID of the proposal to execute.
     */
    function executeProposal(uint256 proposalId) external onlyRole(ADMIN_ROLE) {
        require(proposalId < proposalCounter, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed");

        uint256 totalVotes = proposal.yesVotes + proposal.noVotes + proposal.abstainVotes;
        require(totalVotes > 0, "No votes cast on this proposal");

        // Ensure the proposal meets the 2/3 majority requirement
        if (proposal.yesVotes * 3 > totalVotes * 2) {
            proposal.executed = true;
            emit ProposalExecuted(proposalId);
        } else {
            revert("Proposal did not meet the 2/3 majority requirement");
        }
    }

    /**
     * @notice Retrieve the details of a proposal.
     * @param proposalId The ID of the proposal.
     * @return description The description of the proposal.
     * @return executed Whether the proposal was executed.
     * @return yesVotes Total "yes" votes.
     * @return noVotes Total "no" votes.
     * @return abstainVotes Total abstain votes.
     * @return voters List of voters who participated in the proposal.
     */
    function getProposal(uint256 proposalId)
        external
        view
        returns (
            string memory description,
            bool executed,
            uint256 yesVotes,
            uint256 noVotes,
            uint256 abstainVotes,
            address[] memory voters
        )
    {
        require(proposalId < proposalCounter, "Invalid proposal ID");

        Proposal storage proposal = proposals[proposalId];
        return (
            proposal.description,
            proposal.executed,
            proposal.yesVotes,
            proposal.noVotes,
            proposal.abstainVotes,
            proposal.voters
        );
    }
}
The code is written in Solidity, a programming language used for Ethereum smart contracts.

Error Explanation:
The DeclarationError occurs because _exists() function is not declared anywhere in this contract or its dependencies (imported OpenZeppelin contracts). The error message points to the line where it's being called with an argument (_exists(tokenId)).

Solution:

To fix this, you need to import and use the correct OpenZeppelin contract that provides _exists() function. In your case, since ERC721URIStorage is already imported from @openzeppelin/contracts/token/ERC721/extensions, it's likely that _exists() should be used directly on an instance of a token (e.g., with token._exists(tokenId)).

However, looking at the OpenZeppelin ERC-721 implementation (ERC721.sol) and its extensions like ERC721URIStorage or even your contract itself doesn't seem to have any direct reference for _exists() method. This might be because it's intended usage is not directly applicable here.

Given that this function should check if a token exists, we can simply remove the require statement altogether as you're already calling _safeMint(recipient, newTokenId) which will throw an exception when trying to mint a non-existent token ID:

function updateMetadata(uint256 tokenId, string memory newMetadataURI) external onlyOwner {
    _setTokenURI(tokenId, newMetadataURI);
    tokenMetadataURIs[tokenId] = newMetadataURI;
    emit MetadataUpdated(tokenId, newMetadataURI);
}

Alternatively (if you really need to check if the token exists), use token._exists() instead of _exists(), assuming that's how it should be called in your contract.

DeclarationError: Undeclared identifier.
--> dNFT3.sol:44:9:
|
44 | _setupRole(DEFAULT_ADMIN_ROLE, admin);
| ^^^^^^^^^^

The error occurs because DEFAULT_ADMIN_ROLE is not a valid role identifier.

In Solidity versions (which this code uses), you can't use hardcoded roles like keccak256("ADMIN_ROLE"). Instead, you should define the admin role in your contract using _setupRole() function and then pass it to other functions that require access control checks.

To fix the error:

bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
_setupRole(ADMIN_ROLE, admin);

This will define ADMIN_ROLE as a valid role identifier and assign it to your contract.

However, if you want to use DEFAULT_ADMIN_ROLE, which is provided by OpenZeppelin's AccessControl contracts (like in their examples), then simply import the correct library:
