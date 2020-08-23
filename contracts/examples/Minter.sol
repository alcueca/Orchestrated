// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;
import "./IMintableERC20.sol";


contract Minter {

    /** @dev In the `erc20` contract, creates `amount` tokens and assigns them to `account`
     * - `account` cannot be the zero address.
     * - `Minter` must have been added through orchestration using `erc20.orchestrate(minter.address)`
     */
    function mint(address erc20, address account, uint256 amount)
        public
    {
        IMintableERC20(erc20).mint(account, amount);
    }
}
