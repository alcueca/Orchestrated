const OrchestratedERC20 = artifacts.require('OrchestratedERC20.sol');
const Minter = artifacts.require('Minter.sol');

module.exports = async (deployer, network, accounts) => {
    await deployer.deploy(OrchestratedERC20, "Name", "Symbol");
    await deployer.deploy(Minter);
}
