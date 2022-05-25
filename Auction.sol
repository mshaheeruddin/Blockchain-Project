//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.9.0;


//uint diff = (endDate - startDate) / 60 / 60 / 24;

contract Auction {

 address payable public owner;
 uint startTime;
 uint endTime; 

 address public highestBidder;
 uint public highestBindingBid;
 uint public biddingTime;
 uint public previousBid;
 uint public increment;
 uint incentiveAmount = 2 ether;
 
 //variable to determine if auction has ended
 bool isEnd;

 mapping (address=>uint) bids;

constructor(uint _biddingTime, address payable _owner) {
owner = _owner;
startTime = block.timestamp;
endTime = startTime + _biddingTime;
}
//only owner access
modifier onlyOwner() {
    require(msg.sender == owner);
    _;
}



//participants will use this function to place bids
function placeBid(uint _maxPledged) external payable {
   require(isEnd == false,"Auction has already ended");
   require(block.timestamp < endTime,"Auction has already ended");
   if (previousBid != 0) {
   require(msg.value > previousBid,"Low amount for  bidding");
   }
   if (highestBindingBid != 0) {
       previousBid = highestBindingBid;
       bids[highestBidder] += highestBindingBid;
   }
   highestBidder = msg.sender;
   highestBindingBid = msg.value;
   increment = previousBid - highestBindingBid;
   if (highestBindingBid == _maxPledged) {
       payable(msg.sender).transfer(incentiveAmount);   
   }
   
  }

 function cancelAuction() external onlyOwner {
         isEnd = true;
 }
 function finalizeAuction() external onlyOwner{   
       isEnd = true;
       owner.transfer(highestBindingBid);
 } 
 function withdraw() external returns (bool) {
    uint amount = bids[msg.sender];
    if (amount > 0) { 
       bids[msg.sender] = 0;
    //if unsuccessful
    if (!payable(msg.sender).send(amount)) {
     bids[msg.sender] = amount;
     return false;
    }
}
return true;
}



}
