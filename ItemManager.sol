// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./Ownable.sol";
import "./Item.sol";

contract ItemManager is Ownable{

    enum SupplyChainSteps{Created,Paid,Delivered}

    struct S_Item{
      ItemManager.SupplyChainSteps _step; //an event for the enum is created and called _step
        Item _item;
        string _identifier;
        uint _priceInWei;

    }

    mapping(uint => S_Item) public items; //items is a mapping which gives an inex to the S_items, which are events of the struct

    uint index;

    event SupplyChainStep(uint _itemIndex, uint _step, address _add);// this event is used to emit the status of an item

    function createItem(string memory _identifier , uint _priceInWei) public  onlyOwner{
        
        Item item = new Item(this, _priceInWei, index);
        items[index]._item = item;
       // items[index]._priceInWei = _priceInWei;
        items[index]._step = SupplyChainSteps.Created;
        items[index]._identifier = _identifier;
        emit SupplyChainStep(index , uint(items[index]._step), address(item));
        index++; //this increases the index of the created items
    }

    function triggerPayment(uint _index) public payable{ //the person calling this funxtion should send some amount already
        Item item = items[_index]._item;
        require(address(item) == msg.sender, "Only items are allowed to update themselves");
        require(item.priceInWei() == msg.value, "Not fully paid");
        require(items[index]._step == SupplyChainSteps.Created , "Item is further in the Supply Chain");
        items[_index]._step = SupplyChainSteps.Paid;
        emit SupplyChainStep(_index, uint(items[_index]._step),  address(item));
        
    }

    function triggerDelivery(uint _index) public onlyOwner{
        require(items[_index]._step == SupplyChainSteps.Paid, "Item is further in the Supply Chain");
        items[_index]._step = SupplyChainSteps.Delivered;
        emit  SupplyChainStep(_index, uint(items[_index]._step),address(items[_index]._item));

    }

  


}