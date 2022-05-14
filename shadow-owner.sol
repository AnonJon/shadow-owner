// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShadowOwner is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    mapping(address => address) public shaddowlist;
    bool transfer = false;

    constructor() ERC721("ShadowOwner", "SHDW") {}


    function safeMint(uint256 tokenId, string memory uri, address shadow)
        public
    {
        require(
            shaddowlist[tx.origin] != shadow,
            "You have already created a shadow for this address"
        );
        _safeMint(shadow, tokenId);
        _setTokenURI(tokenId, uri);
        shaddowlist[tx.origin] = shadow;
    }

    // The following functions are overrides required by Solidity.

    function _transfer(address from, address to, uint256 tokenId) internal override {
        require(
            transfer,
            "non transferable"
        );
        super._transfer(from, to, tokenId);
}

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}