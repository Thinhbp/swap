// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract swap  {
    address  USDC = 0x38558FB189f9fB0a6B455064477627Fdbe3d0f1c;
    address  VUSD = 0xba7dF49529892d36f8A852d576C1343e0BfE80Ea;

    address owner ;
    constructor(){
        owner = msg.sender;
        }


    event Swap(address _address, address _token, uint _amount);

    function changeToken(address _token, uint _amount) public {
        require(_token == USDC || _token == VUSD, "Please choose type of token correctly");
        require(IERC20(_token).allowance(msg.sender, address(this)) == _amount*10**18,"You must approve in web3");
        address tokenReceived = _token == USDC ? VUSD : USDC;
        require(IERC20(tokenReceived).balanceOf(address(this)) >= _amount*10**18, "VNTC is not enough");
        require(IERC20(_token).transferFrom(msg.sender, address(this),_amount*10**18), "Transfer failed");
        IERC20(tokenReceived).transfer(msg.sender, _amount*10**18);
        emit Swap(msg.sender,  _token,  _amount);
    
    }

    function checkBalance(address _token) public view returns(uint){
        return IERC20(_token).balanceOf(address(this))/10**18;
    }

    function withdraw() public {
        require(msg.sender == owner," You are not be allowed");
        IERC20(USDC).transfer(msg.sender, IERC20(USDC).balanceOf(address(this)));
        IERC20(VUSD).transfer(msg.sender, IERC20(VUSD).balanceOf(address(this)));
    }
}
