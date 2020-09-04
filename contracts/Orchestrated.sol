// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;


/**
 * @dev Orchestrated allows to define static access control between multiple contracts.
 * This contract would be used as a parent contract of any contract that needs to restrict access to some methods,
 * which would be marked with the `onlyOrchestrated` modifier.
 * During deployment, the contract deployer (`owner`) can register any contracts that have privileged access by calling `orchestrate`.
 * Once deployment is completed, `owner` should call `transferOwnership(address(0))` to avoid any more contracts ever gaining privileged access.
 */

contract Orchestrated {
    event GrantedAccess(address access);
    event TransferredConductor(address indexed oldConductor, address indexed newConductor);

    address public conductor;
    mapping(address => mapping (bytes4 => bool)) public orchestration;

    /// @dev Resrict usage to the conductor.
    modifier onlyConductor() {
        require(conductor == msg.sender, "Orchestrated: ");
        _;
    }

    /// @dev Restrict usage to authorized users
    /// @param err The error to display if the validation fails
    modifier onlyOrchestrated(string memory err) {
        require(orchestration[msg.sender][msg.sig], err);
        _;
    }

    /// @dev Initializes the contract setting the deployer as the initial conductor.
    constructor() {
        conductor = msg.sender;
    }

    /// @dev Add orchestration
    /// @param user Address of user or contract having access to this contract.
    /// @param signature bytes4 signature of the function we are giving orchestrated access to.
    /// It seems to me a bad idea to give access to humans, and would use this only for predictable smart contracts.
    function orchestrate(address user, bytes4 signature) external onlyConductor {
        orchestration[user][signature] = true;
        emit GrantedAccess(user);
    }

    /// @dev Leaves the contract without conductor, so it will not be possible to call
    /// `onlyConductor` functions anymore. Can only be called by the current conductor.
    function renounceConductor() external onlyConductor {
        emit TransferredConductor(conductor, address(0x00));
        conductor = address(0x00);
    }

    /// @dev Transfers the conductor of the contract to a new account (`newConductor`).
    /// Can only be called by the current conductor.
    /// @param newConductor The acount of the new conductor.
    function transferConductor(address newConductor) external onlyConductor {
        require(newConductor != address(0x00), "Orchestrator: Zero Address");
        emit TransferredConductor(conductor, newConductor);
        conductor = newConductor;
    }
}
