// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC721A/ERC721AQueryable/ERC721AQueryable.sol";


contract MbaToken is ERC721AQueryable {
    constructor() ERC721A("Test-MBA", "tMBA") { 
    }

    function mint(uint256 quantity) external payable {
        _mint(msg.sender, quantity);
    }



}