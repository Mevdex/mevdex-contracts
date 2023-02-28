const MevdexPair = artifacts.require('./MevdexPair.sol')

contract('MevdexPair', (accounts) => {
  let mevdex
  before(async () => {
    mevdex = await MevdexPair.deployed()
  })

  it('should be deployed', async () => {
    assert.notEqual(mevdex, '')
  })
})
