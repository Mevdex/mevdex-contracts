var Mevdex = artifacts.require('./MevdexPair.sol')

module.exports = function (deployer) {
  deployer.deploy(Mevdex)
}
