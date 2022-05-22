// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

import {FxBaseChildTunnel} from "./tunnel/FxBaseChildTunnel.sol";

import {IShadow} from "./IShadow.sol";

contract ChildShadowManager is FxBaseChildTunnel, Ownable {

    bytes32 public constant SYNC_SHADOW = keccak256("SYNC_SHADOW");

    uint256 public countShadowSyncAttempts = 0;
    uint256 public countProcessingAttempts = 0;

    uint256 public latestStateId;
    address public latestRootMessageSender;
    bytes public latestData;

    IShadow public childToken;

    constructor(address _fxChild, IShadow _childToken) FxBaseChildTunnel(_fxChild) {
        childToken = _childToken;
    }

    function _syncShadow(bytes memory syncData) internal {

        countShadowSyncAttempts += 1;

        // Sync data from Ethereum root chain.
        (address depositor, address shadow, uint256 tokenId) = abi.decode(
            syncData,
            (address, address, uint256)
        );

        childToken.setShadow(shadow, tokenId);
    }

    function _processMessageFromRoot(
        uint256 stateId,
        address sender,
        bytes memory data
    ) internal override validateSender(sender) {

        latestStateId = stateId;
        latestRootMessageSender = sender;
        latestData = data;

        countProcessingAttempts += 1;
        
        (bytes32 syncType, bytes memory syncData) = abi.decode(data, (bytes32, bytes));

        if (syncType == SYNC_SHADOW) {
            _syncShadow(syncData);
        }
    }

    function setChildToken(IShadow _childToken) external onlyOwner {
        childToken = _childToken;
    }

    function sendMessageToRoot(bytes memory message) public {
        _sendMessageToRoot(message);
    }
}