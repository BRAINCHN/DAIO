
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/governance/TimelockController.sol";

contract DAIOTimeLock is TimelockController {
    constructor(
        uint256 _minDelay,  // Minimum delay before a proposal can be executed
        address[] memory proposers,  // Addresses allowed to propose
        address[] memory executors  // Addresses allowed to execute
    )
        TimelockController(_minDelay, proposers, executors) 
    {}
}
