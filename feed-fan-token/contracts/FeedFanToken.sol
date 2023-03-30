// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract FeedFanToken is ERC1155, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private feedId;
    mapping(uint256 => string) private feedIdToUrl;
    mapping(string => uint256) private feedUrlToId;

    constructor() ERC1155("") {
    }

    function addFeed(string memory feedUrl) public onlyOwner {
        require(feedUrlToId[feedUrl] == 0, "Feed URL already exists");
        feedId.increment();
        uint256 currentFeedId = feedId.current();
        feedIdToUrl[currentFeedId] = feedUrl;
        feedUrlToId[feedUrl] = currentFeedId;
    }

    function subscribe(uint256 _feedId) public {
        require(bytes(feedIdToUrl[_feedId]).length > 0, "Feed does not exist");
        _mint(msg.sender, _feedId, 1, "");
    }

    function unsubscribe(uint256 _feedId) public {
        require(balanceOf(msg.sender, _feedId) > 0, "Not subscribed to the feed");
        _burn(msg.sender, _feedId, 1);
    }

    function getFeedUrl(uint256 _feedId) public view returns (string memory) {
        return feedIdToUrl[_feedId];
    }

    function getFeedId(string memory feedUrl) public view returns (uint256) {
        return feedUrlToId[feedUrl];
    }

    function isSubscribed(uint256 _feedId, address _user) public view returns (bool) {
        return balanceOf(_user, _feedId) > 0;
    }
}
