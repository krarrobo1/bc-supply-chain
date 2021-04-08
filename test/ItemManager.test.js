const ItemManager = artifacts.require('./ItemManager.sol');
contract("ItemManager", accounts =>{
    it("should create a new Item", async() =>{
        let instance = await ItemManager.deployed();
        const itemName = "test_1";
        const itemPrice = 1000;
        const result = await instance.createItem(itemName, itemPrice, { from: accounts[0] });

        assert.equal(result.logs[0].args._itemIndex, 0, "It's not the first item");

        const item = await instance.items(0);
        assert.equal(item._identifier, "test_1", "Different ID");
    });
});