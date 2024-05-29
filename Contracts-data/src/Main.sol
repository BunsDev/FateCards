// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Card} from "./Card.sol";
import {ICard} from "./interfaces/ICard.sol";
import {INfts} from "./interfaces/INfts.sol";

contract Main is Ownable {
    ICard cardContract;
    INfts nftContract;

    mapping(address => uint256) public lastClaim;
    mapping(address => bool) private claimed;
    mapping(address => mapping(bool => uint256)) internal latestCard;

    struct Trade {
        address user1;
        address user2;
        uint256 cardId1;
        uint256 cardId2;
        bool confirm;
    }

    struct TradeForShow {
        address player;
        uint256 cardId1;
        uint256 cardId2;
        uint256 tradeId;
    }

    mapping(address => Trade) public trades;
    TradeForShow[] public upTrades;

    constructor(address _cardContract, address _nftContract) Ownable(msg.sender) {
        cardContract = ICard(_cardContract);
        nftContract = INfts(_nftContract);
    }

    error Main__CardNotInPossession();
    error Main__CardNotValid();
    error Main__AlreadyInATrade();
    error Main__AlredyLoggedInToday();

    modifier validCard(uint256 _id) {
        if (_id >= 0 && _id < cardContract.getNumberOfUris()) {
            _;
        } else {
            revert Main__CardNotValid();
        }
    }

    modifier cardsInPossession(address _user, uint256 _cardId) {
        if (cardContract.checkCard(_user, _cardId)) {
            _;
        } else {
            revert Main__CardNotInPossession();
        }
    }

    function oneDay(address _user) internal view returns (bool) {
        if ((lastClaim[_user] == 0) || (lastClaim[_user] <= block.timestamp)) {
            // if ((lastClaim[_user] == 0) || (lastClaim[_user] + 1 days <= block.timestamp)) {
            return true;
        } else {
            return false;
        }
    }

    function revealFate() public {
        if (oneDay(msg.sender)) {
            lastClaim[msg.sender] = block.timestamp;
            claimed[msg.sender] = false;
        }
        if (!claimed[msg.sender]) {
            claimed[msg.sender] = true;
            uint256 card = cardContract.reveal(msg.sender);
            setLatestCard(msg.sender, card);
        }
    }

    function setLatestCard(address user, uint256 cardId) internal {
        latestCard[user][true] = cardId;
    }

    function getLatestCard(address user) public view returns (uint256) {
        return latestCard[user][true];
    }

    function trade(address _otherPlayer, uint256 _for, uint256 _having)
        public
        validCard(_having)
        validCard(_for)
        cardsInPossession(msg.sender, _having)
        cardsInPossession(_otherPlayer, _for)
    {
        if (
            trades[msg.sender].user1 == address(0)
                && (
                    trades[trades[msg.sender].user2].user2 == msg.sender
                        || trades[trades[msg.sender].user2].user2 == address(0)
                )
        ) {
            trades[msg.sender] = Trade(msg.sender, _otherPlayer, _having, _for, false);
        } else {
            revert Main__AlreadyInATrade();
        }
    }

    function viewTrade() public view returns (Trade memory, Trade memory) {
        return (trades[msg.sender], trades[trades[msg.sender].user2]);
    }

    function confirmTrade() public {
        trades[msg.sender].confirm = true;
        if (trades[trades[msg.sender].user2].confirm == true) {
            trades[trades[msg.sender].user2].confirm = false;
            trades[msg.sender].confirm = false;
            Trade memory t = trades[msg.sender];
            address to = t.user2;
            uint256 having = t.cardId1;
            uint256 fr = t.cardId2;
            (bool success, uint256 nftFr, uint256 nftHaving) = cardContract.tradeCards(msg.sender, to, having, fr);
            require(success);
            nftContract.transfer(to, nftHaving);
            nftContract.transfer(msg.sender, nftFr);
            cancelTrade();
        }
    }

    function cancelTrade() public {
        require(trades[msg.sender].confirm == false);
        address user2 = trades[msg.sender].user2;
        trades[msg.sender] = Trade(address(0), address(0), 0, 0, false);
        trades[user2] = Trade(address(0), address(0), 0, 0, false);
    }

    function showATrade(uint256 _having, uint256 _for) public cardsInPossession(msg.sender, _having) {
        uint256 index = getIndexForTrade() + 1;
        TradeForShow memory t = TradeForShow(msg.sender, _having, _for, index);
        if (index < upTrades.length) {
            upTrades[index] = t;
        } else {
            upTrades.push(t);
        }
    }

    function showAllUpTrades() public view returns (TradeForShow[] memory) {
        return upTrades;
    }

    function putDownATrade(uint256 _index) public {
        require(msg.sender == upTrades[_index].player);
        delete upTrades[_index];
    }

    function getIndexForTrade() internal view returns (uint256) {
        for (uint256 i = 0; i < upTrades.length; i++) {
            if (upTrades[i].player == address(0)) {
                return i;
            }
        }
        return upTrades.length;
    }
}
