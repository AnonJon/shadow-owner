//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract IShadow {
    function setShadow(address shadow, uint256 tokenId) external virtual;
}