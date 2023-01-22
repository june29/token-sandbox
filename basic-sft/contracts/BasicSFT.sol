// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract BasicSFT is ERC1155 {
    constructor()
        ERC1155("https://june29.github.io/token-metadata/basic-sft/{id}.json")
    {}

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        _mint(account, id, amount, data);
    }
}
