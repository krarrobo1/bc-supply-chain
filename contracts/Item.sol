// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

import "./ItemManager.sol";

contract Item{
    uint public priceInWei;
    uint public pricePaid;
    uint public index;

    ItemManager parentContract;

    constructor(ItemManager _parentContract, uint _priceInWei, uint _index){
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(pricePaid == 0, "Item is already paid");
        require(priceInWei == msg.value, "Only full payments allowed");
        pricePaid += msg.value;
        // Calling 'triggerPayment' function from ItemManager contract.
        (bool success,) = address(parentContract).call{value: msg.value}(abi.encodeWithSignature("triggerPayment(uint256)", index));
        // returns true if the transaction was successful.
        require(success, "The transaction wasn't successful, cancelling");
   }

   fallback () external{}
}