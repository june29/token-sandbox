// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FeedFanToken is ERC1155, Ownable {
    uint256 private feedID;
    mapping(uint256 => string) private feedURLs;

    constructor() ERC1155("") {
        feedID = 0;
    }

    function addFeed(string memory feedURL) public onlyOwner {
        feedURLs[feedID] = feedURL;
        feedID += 1;
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

    function isSubscribed(uint256 _feedID, address _user) public view returns (bool) {
        return balanceOf(_user, _feedID) > 0;
    }
}
