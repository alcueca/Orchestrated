// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../OrchestratedV2.sol";
import "./IMintableERC20.sol";


contract OrchestratedV2ERC20 is IMintableERC20, OrchestratedV2, ERC20 {

    /**
     * @dev Calls the constructors of OrchestratedV1 and ERC20(name, symbol)
     */
    constructor (string memory name, string memory symbol)
        OrchestratedV2()
        ERC20(name, symbol)
    { }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - caller must have been added through orchestration using `OrchestratedV1ERC20.orchestrate(caller)`
     */
    function mint(address account, uint256 amount)
        public override
        onlyOrchestrated("OrchestratedV2ERC20: mint")
    {
        _mint(account, amount);
    }
}
