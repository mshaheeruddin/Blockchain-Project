// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./WWGToken.sol";


contract CrowdFund {

address public manager;
uint256 public amountRaised; 
uint256 public tokenPrice;
WWGToken public token; 
SafeMath public safeMath;

event Sold(address owner, uint256 totalTokens);

    constructor(WWGToken _token, uint256 _tokenPrice) {
        manager = msg.sender;
        token = _token;
        tokenPrice = _tokenPrice;
    }

    // Functions and addresses declared payable can receive token into the contract.
    function buyToken(uint256 _tokensToBePurchased) public payable {
        require(msg.value == safeMath.safeMul(_tokensToBePurchased, tokenPrice));
        require(token.balanceOf(address(this)) >= _tokensToBePurchased);
        require(token.transfer(msg.sender, _tokensToBePurchased));

        amountRaised = safeMath.safeAdd(amountRaised, _tokensToBePurchased);
        emit Sold(msg.sender, _tokensToBePurchased);
    }

    function endFunding() public {
        require(msg.sender == manager);
        //transfer to manager
        token.transfer(payable(manager), token.balanceOf(address(this)));
    }

}
