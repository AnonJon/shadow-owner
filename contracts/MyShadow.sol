// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC721S.sol";

contract MyShadowToken is ERC721S, Ownable {
    constructor() ERC721S("MyShadowToken", "MYST") {}

    function setShadowManager(address _shadowManager) external onlyOwner 
    {
        _setShadowManager(_shadowManager);
    }
}