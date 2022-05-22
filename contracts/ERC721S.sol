// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721S is ERC721 {

    uint256 public countShadowAttempts = 0;
    uint256 public lastTokenSyncAttempt;

    uint256 public testNum = 0;

    // Mapping from token ID to owner address
    mapping(uint256 => address) public shadowOwners;


    // Only the shadowManager can mint or assign Shadows.
    address public shadowManager;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
    }

    function setTestNum(uint256 num) external
    {
        testNum = num;
    }

    function setShadow(address shadow, uint256 tokenId) external virtual
    {
        lastTokenSyncAttempt = tokenId;
        countShadowAttempts = countShadowAttempts + 1;

        require(
            msg.sender == shadowManager,
            "Only Shadow Manager can set Shadows."
        );

        // Get the current Shadow owner, if there is one.
        address currentOwner = ownerOf(tokenId);

        // Mint a new Shadow if one doesn't exist yet.
        if (currentOwner == address(0))
        {
            _safeMint(tokenId, shadow);
        }
        // Otherwise, transfer the Shadow.
        else 
        {
            // Transfer from the old Shadow owner, to new Shadow owner.
            _transfer(currentOwner, shadow, tokenId);

        }

        // Set the original sender as new owner of the Primary.
        shadowOwners[tokenId] = tx.origin;
    }

    function _safeMint(uint256 tokenId, address shadow) internal
    {
        require(msg.sender == shadowManager, "Request not sent by Shadow Manager.");
        
        // Mint the Shadow with the shadow address as owner.
        super._safeMint(shadow, tokenId);

        // Record the orignal sender as owner of the Primary.
        shadowOwners[tokenId] = tx.origin;
    }

    function _setShadowManager(address _shadowManager) internal virtual {
        shadowManager = _shadowManager;
    }


    // The following functions are overrides required by Solidity.
    function _transfer(address from, address to, uint256 tokenId) internal override {
        require(
            msg.sender == shadowManager,
            "Only Shadow Manager can transfer Shadows."
        );
        super._transfer(from, to, tokenId);
    }
}