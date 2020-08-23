const ERC20 = artifacts.require('OrchestratedV1ERC20')
const Minter = artifacts.require('Minter')

// @ts-ignore
import { expectRevert } from '@openzeppelin/test-helpers'
import { keccak256, toUtf8Bytes } from 'ethers/lib/utils'
import { assert } from 'chai'

contract('OrchestratedV1', async (accounts: string[]) => {
  let [owner, user] = accounts

  let erc20: any
  let minter: any

  beforeEach(async () => {
    erc20 = await ERC20.new('Name', 'Symbol', { from: owner })
    minter = await Minter.new({ from: owner })
  })

  it('does not allow minting to unknown addresses', async () => {
    await expectRevert(
        minter.mint(erc20.address, owner, 1, { from: owner }),
        'OrchestratedV1ERC20: mint'
      )
  })

  it('allows minting to orchestrated addresses', async () => {
    await erc20.orchestrate(minter.address, { from: owner })
    await minter.mint(erc20.address, owner, 1, { from: owner })
    assert.equal(await erc20.balanceOf(owner), 1)
  })
})
