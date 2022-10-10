pragma solidity ^0.8.9;

contract FeedFanToken {
  mapping(uint256 => string) public channelUrls; // Token ID => Channel URL
  mapping(uint256 => string[]) public consumedItems; // Token ID => Consumed Items  
}
