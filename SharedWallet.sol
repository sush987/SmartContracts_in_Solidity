// SPDX-License-Identifier: MIT
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/mocks/OwnableMock.sol";



pragma solidity ^0.8.0;

contract SimpleWallet is Ownable{

    // address public owner;
    // constructor() public{
    //     owner = msg.sender;
    // }
    // modifier onlyOwner(){
    //     require(owner == msg.sender, "You are not authorised");
    // _;
    // }
    receive() external payable{

    }
    function withdraw(address payable _to, uint _amount) payable public{
        _to.transfer(_amount);
    }
    //data structure for allowance and people
    mapping(address => uint) public allowance;
    function addAllowance(address _who, uint _amount) public onlyOwner {
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint amountt){
        require(owner() == msg.sender || allowance[msg.sender] > amountt, "You are not allowed");
        _;
    }


  
}
