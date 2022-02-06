// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Swap is  ERC20 {

    address owner ;
    constructor() public ERC20("vusd", "VUSD") { 
        owner = msg.sender;
    }


    address  USDC = 0x38558FB189f9fB0a6B455064477627Fdbe3d0f1c;

    event buy(address _address, uint _amount);
    event sell(address _address, uint _amount);


    function buyVUSD(uint _amount) public {
        require(_amount > 0);
        require(IERC20(USDC).allowance(msg.sender, address(this)) == _amount*10**18,"You must approve in web3");
        require(IERC20(USDC).transferFrom(msg.sender, address(this),_amount*10**18), "Transfer failed");
        _mint(msg.sender, _amount*10**18);
        emit buy(msg.sender, _amount);

    }

    function sellVUSD(uint _amount) public {
        require(_amount > 0);
        require(IERC20(USDC).balanceOf(address(this))>= _amount*10**18, "Balance is not enought");
        require(transfer(address(this), _amount*10**18), "Transfer failed");
        IERC20(USDC).transfer(msg.sender, _amount*10**18);
        emit sell(msg.sender, _amount);

    }

    function checkBalance(address _token) public view returns(uint){
       return IERC20(_token).balanceOf(address(this))/10**18;
    }

    function withdraw(uint _amount) public {
        require(_amount > 0);
        require(IERC20(USDC).balanceOf(address(this))>= _amount*10**18, "Balance is not enought");
        require(msg.sender == owner," You are not be allowed");
        IERC20(USDC).transfer(msg.sender, _amount*10**18);
    }


}

