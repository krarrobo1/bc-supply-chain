const ItemManager = artifacts.require("ItemManager");

module.exports = function (deployer, network, accounts) {
  const userAddress = accounts[0];
  deployer.deploy(ItemManager, userAddress);
};
