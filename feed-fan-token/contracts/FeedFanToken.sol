// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FeedFanToken is ERC1155, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private feedID;
    mapping(uint256 => string) private feedURLs;
    mapping(string => uint256) private feedURLToID;

    constructor() ERC1155("") {
    }

    function addFeed(string memory feedURL) public onlyOwner {
        require(feedURLToID[feedURL] == 0, "Feed URL already exists");
        feedID.increment();
        uint256 currentFeedID = feedID.current();
        feedURLs[currentFeedID] = feedURL;
        feedURLToID[feedURL] = currentFeedID;
    }

    function subscribe(uint256 _feedID) public {
        require(bytes(feedURLs[_feedID]).length > 0, "Feed does not exist");
        _mint(msg.sender, _feedID, 1, "");
    }

    function unsubscribe(uint256 _feedID) public {
        require(balanceOf(msg.sender, _feedID) > 0, "Not subscribed to the feed");
        _burn(msg.sender, _feedID, 1);
    }

    function getFeedURL(uint256 _feedID) public view returns (string memory) {
        return feedURLs[_feedID];
    }

    function getFeedID(string memory feedURL) public view returns (uint256) {
        return feedURLToID[feedURL];
    }

    function isSubscribed(uint256 _feedID, address _user) public view returns (bool) {
        return balanceOf(_user, _feedID) > 0;
    }
}
