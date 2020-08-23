// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @dev Orchestrated allows to define static access control between multiple contracts.
 * This contract would be used as a parent contract of any contract that needs to restrict access to some methods,
 * which would be marked with the `onlyOrchestrated` modifier.
 * During deployment, the contract deployer (`owner`) can register any contracts that have privileged access by calling `orchestrate`.
 * Once deployment is completed, `owner` should call `transferOwnership(address(0))` to avoid any more contracts ever gaining privileged access.
 */

contract OrchestratedV1 is Ownable {
    event GrantedAccess(address access);

    mapping(address => bool) public orchestration;

    constructor () Ownable() {}

    /// @dev Restrict usage to authorized users
    /// @param err The error to display if the validation fails 
    modifier onlyOrchestrated(string memory err) {
        require(orchestration[msg.sender], err);
        _;
    }

    /// @dev Add orchestration
    /// @param user Address of user or contract having access to this contract.
    /// It seems to me a bad idea to give access to humans, and would use this only for predictable smart contracts.
    function orchestrate(address user) public onlyOwner {
        orchestration[user] = true;
        emit GrantedAccess(user);
    }
}
