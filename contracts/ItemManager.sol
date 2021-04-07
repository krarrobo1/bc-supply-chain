// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

import "./Item.sol";

contract ItemManager{

    enum SupplyChainState{Created, Paid, Delivered}

    struct S_Item {
        Item _item;
        string _identifier;
        uint _itemPrice;
        ItemManager.SupplyChainState _state;
    }

    mapping (uint=>S_Item) public items;
    uint itemIndex;

    event SupplyChainStep(uint _itemIndex, uint _step, address _itemAddress);

    function createItem(string memory _identifier, uint _itemPrice) public {
        Item item = new Item(this, _itemPrice, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._identifier = _identifier;
        items[itemIndex]._itemPrice = _itemPrice;
        items[itemIndex]._state = ItemManager.SupplyChainState.Created;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex++;
    }


    function triggerPayment(uint _itemIndex) public payable{
        require(items[_itemIndex]._itemPrice == msg.value, "Only full payments accepted");
        require(items[_itemIndex]._state == ItemManager.SupplyChainState.Created, "Item is further in the chain");
        items[_itemIndex]._state = ItemManager.SupplyChainState.Paid;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));
    }


    function triggerDelivery(uint _itemIndex) public {
        require(items[_itemIndex]._state == ItemManager.SupplyChainState.Paid, "Item is further in the chain");
        items[_itemIndex]._state = ItemManager.SupplyChainState.Delivered;

        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(items[itemIndex]._item));
    }

}