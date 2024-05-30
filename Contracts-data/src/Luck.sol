// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// To work locally without using chainlink, use the commented code below :
// contract Luck {
//     function getLuck(uint256 _length) external view returns (uint256) {
//         return uint256(block.timestamp % _length);
//     }
// }

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatibleInterface.sol";

contract Luck is VRFConsumerBaseV2, KeeperCompatibleInterface {
    VRFCoordinatorV2Interface internal COORDINATOR;
    LinkTokenInterface internal LINKTOKEN;
// Fill the necessary values here according to the chain
    uint64 internal s_subscriptionId = 1;
    address internal vrfCoordinator = ;
    address internal link_token_contract = ;
    bytes32 internal keyHash = ;
    uint32 internal callbackGasLimit = 100000;
    uint16 internal requestConfirmations = 3;
    uint32 internal numWords = 1;

    uint256 public randomResult;
    uint256 public lastRequestId;
    uint256 public lastTimeStamp;
    uint256 public interval = 180;
    bool public requestPending;

    event RequestSent(uint256 requestId);
    event RequestFulfilled(uint256 requestId, uint256 randomResult);

    constructor() VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link_token_contract);
        requestPending = false;
        lastTimeStamp = block.timestamp;
    }

    function requestRandomNumber() internal {
        uint256 requestId =
            COORDINATOR.requestRandomWords(keyHash, s_subscriptionId, requestConfirmations, callbackGasLimit, numWords);
        lastRequestId = requestId;
        requestPending = true;
        emit RequestSent(requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        randomResult = randomWords[0];
        requestPending = false;
        lastTimeStamp = block.timestamp;
        emit RequestFulfilled(requestId, randomResult);
    }

    function getLuck(uint256 _length) external view returns (uint256) {
        require(randomResult != 0, "Random number not available yet");
        return randomResult % _length;
    }

    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval && !requestPending;
    }

    function performUpkeep(bytes calldata) external override {
        if ((block.timestamp - lastTimeStamp) > interval && !requestPending) {
            requestRandomNumber();
        }
    }

    function setInterval(uint256 _interval) external {
        interval = _interval;
    }
}
