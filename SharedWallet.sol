// SPDX-License-Identifier: MIT
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/mocks/OwnableMock.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";



pragma solidity ^0.8.0;

contract Allowance is Ownable{

    // address public owner;
    // constructor() public{
    //     owner = msg.sender;
    // }
    // modifier onlyOwner(){
    //     require(owner == msg.sender, "You are not authorised");
    // _;
    // }

    event AllowanceChanges(address indexed  _towhom, address _fromwhom, uint _oldamount, uint _newamount);
    
   function reduceAllowance(address _add, uint _amount) internal {

       emit AllowanceChanges(_add, msg.sender, allowance[_add], allowance[_add]- _amount);
       allowance[_add] -= _amount;
   }

    
    //data structure for allowance and people
    mapping(address => uint) public allowance;
    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceChanges(_who, msg.sender, allowance[_who], _amount);
        
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(uint amountt){
        require(owner() == msg.sender  || allowance[msg.sender] > amountt, "You are not allowed");
        _;
    }
    function renounceOwnership() public override onlyOwner{
        revert("Can't renounce ownership here");
    }


  
}


contract Simplewallet is Allowance{

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyRecieved(address indexed _from, uint _amount);

        function withdraw(address payable _to, uint _amount) payable public{
       if(owner() != msg.sender){
           reduceAllowance(msg.sender, _amount);
       }
       emit MoneySent(_to, _amount);
       
        _to.transfer(_amount);
    }

    receive() external payable{
        emit MoneyRecieved(msg.sender, msg.value);
          
    }

}
