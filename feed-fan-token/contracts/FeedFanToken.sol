// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract FeedFanToken is ERC1155, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private feedId;
    mapping(uint256 => string) private feedIdToUrl;
    mapping(string => uint256) private feedUrlToId;

    constructor() ERC1155("") {
    }

    function subscribe(string memory feedUrl) public {
        uint256 _feedId = feedUrlToId[feedUrl];
        if (_feedId == 0) {
            feedId.increment();
            _feedId = feedId.current();
            feedIdToUrl[_feedId] = feedUrl;
            feedUrlToId[feedUrl] = _feedId;
        }
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

    // Override the uri function to provide on-chain metadata
    function uri(uint256 _feedId) public view override returns (string memory) {
        string memory feedUrl = feedIdToUrl[_feedId];
        string memory json = string(abi.encodePacked(
            '{',
            '"name": "FeedFanToken #', Strings.toString(_feedId), '",',
            '"description": "On-Chain Feed Subscription Token",',
            '"feed_url": "', feedUrl, '",',
            '"attributes": [{"trait_type": "Feed URL", "value": "', feedUrl, '"}],',
            '"image": "https://june29.github.io/feed-fan-token/feed-fan-token.png"',
            '}'
        ));
        return json;
    }
}
