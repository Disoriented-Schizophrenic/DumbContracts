// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract tokenStorage is Ownable {

    // calling SafeMath will add extra functions to the uint data type
    using SafeMath for uint; // you can make a call like myUint.add(123)
    

    // amount of ether you deposited is saved in balances
    mapping(address => uint) public Eth_DepositedAmount;
    
    function ERC20_TokenBalance(IERC20 token) public view returns(uint256) {
        return token.balanceOf(address(this));
    }
    
    function depositEth() external payable {

        //update balance
        Eth_DepositedAmount[msg.sender] +=msg.value;

    }
    
    function Eth_withdrawAll() public {

        // check that the sender has ether deposited in this contract in the mapping and the balance is >0
        require(Eth_DepositedAmount[msg.sender] > 0, "insufficient funds");
      
      
        // update the balance
        uint amount = Eth_DepositedAmount[msg.sender];
        Eth_DepositedAmount[msg.sender] = 0;

       
        // send the ether back to the sender
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ether");

    }


     function ERC20_withdrawAmount(IERC20 token, uint256 amount) public onlyOwner {
      require(token.transfer(msg.sender, amount), "Transfer failed");
    }   
    
     function ERC20_withdrawAll(IERC20 token) public onlyOwner {
      require(token.transfer(msg.sender, token.balanceOf(address(this))), "Transfer failed");
    }   
    
}