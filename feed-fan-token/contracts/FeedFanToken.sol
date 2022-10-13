pragma solidity ^0.8.9;

contract FeedFanToken {
  mapping(uint256 => Subscription) public subscriptions; // Token ID => Subscription

  struct Subscription {
    string channelUrl;
    string[] consumedItems;
  }
}
