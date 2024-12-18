// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Import OpenZeppelin libraries
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract AIEnhancedContract is Initializable, AccessControlUpgradeable, UUPSUpgradeable {
    bytes32 public constant EXECUTOR_ROLE = keccak256("EXECUTOR_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    string public decision;
    mapping(bytes32 => string) public decisionLog;

    event DecisionExecuted(
        bytes32 indexed queryHash,
        string query,
        string decision,
        address indexed executor
    );

    constructor() {
        _disableInitializers();
    }

    function initialize(address admin) public initializer {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        // Assign roles using `grantRole` instead of `_setupRole`
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(UPGRADER_ROLE, admin);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

    function addExecutor(address executor) external onlyRole(DEFAULT_ADMIN_ROLE) {
        grantRole(EXECUTOR_ROLE, executor);
    }

    function removeExecutor(address executor) external onlyRole(DEFAULT_ADMIN_ROLE) {
        revokeRole(EXECUTOR_ROLE, executor);
    }

    function executeDecision(string memory _query, bytes memory _llmOutput) external onlyRole(EXECUTOR_ROLE) {
        require(bytes(_query).length > 0, "Query cannot be empty");
        require(_llmOutput.length > 0, "LLM output cannot be empty");

        string memory processedDecision = _processLLMOutput(_llmOutput);
        decision = processedDecision;

        bytes32 queryHash = keccak256(abi.encodePacked(_query));
        decisionLog[queryHash] = processedDecision;

        emit DecisionExecuted(queryHash, _query, processedDecision, msg.sender);
    }

    function _processLLMOutput(bytes memory _llmOutput) private pure returns (string memory) {
        return string(_llmOutput);
    }

    function getDecision(bytes32 queryHash) external view returns (string memory) {
        return decisionLog[queryHash];
    }
}

