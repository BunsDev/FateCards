// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Nfts} from "./Nfts.sol";
import {Luck} from "./Luck.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {INfts} from "./interfaces/INfts.sol";

contract Card is Ownable {
    uint256 cardsMade;
    uint256 numberOfUris;
    string private base = ""; // insert a base string here

    string[] _tokenURIs;

    Luck luck = new Luck();
    INfts nfts;
    address main;
    mapping(address user => mapping(uint256 cardId => uint256[] cardsNumber)) public UserCards;

    constructor(address _nfts) Ownable(msg.sender) {
        numberOfUris = 0;
        nfts = INfts(_nfts);
    }

    error CARD__OnlyAuthorized();

    event CARD__FateRevealed(address, uint256);

    modifier onlyAuthorized() {
        if (msg.sender == owner() || msg.sender == main) {
            _;
        } else {
            revert CARD__OnlyAuthorized();
        }
    }

    function getListOfAllHeldCard(address _user) public view returns (uint256[][] memory) {
        uint256 n = getNumberOfUris();
        uint256[][] memory allCards = new uint256[][](n);

        for (uint256 i = 0; i < n; i++) {
            uint256[] memory userCardList = UserCards[_user][i];
            allCards[i] = new uint256[](userCardList.length);

            for (uint256 j = 0; j < userCardList.length; j++) {
                allCards[i][j] = userCardList[j];
            }
        }
        return allCards;
    }

    function reveal(address _to) external onlyAuthorized returns (uint256) {
        uint256 fate = luck.getLuck(numberOfUris);
        string memory rest = _tokenURIs[fate];
        string memory uri = string(abi.encodePacked(base, rest));
        uint256 cardCounter = nfts.getCurrentCounter();
        pushCard(_to, fate, cardCounter);
        nfts.mint(_to, uri);
        emit CARD__FateRevealed(_to, fate);
        return fate;
    }

    function insertUri(string memory _uri) external onlyAuthorized {
        _tokenURIs.push(_uri);
        numberOfUris++;
    }

    function viewUri(uint256 _id) public view returns (string memory) {
        return _tokenURIs[_id];
    }

    function getAllTokens(address _user, uint256 _id) public view returns (uint256[] memory) {
        return UserCards[_user][_id];
    }

    function getNumberOfUris() public view returns (uint256) {
        return numberOfUris;
    }

    function checkCard(address _user, uint256 _cardId) public view returns (bool) {
        return UserCards[_user][_cardId].length > 0;
    }

    function tradeCards(address p1, address p2, uint256 cId1, uint256 cId2) public returns (bool, uint256, uint256) {
        uint256 nftId1 = workOnUserCards(p1, cId1);
        uint256 nftId2 = workOnUserCards(p2, cId2);

        UserCards[p1][cId1].pop();
        UserCards[p2][cId2].pop();

        uint256[] storage arr1 = UserCards[p1][cId2];
        uint256[] storage arr2 = UserCards[p2][cId1];

        arr1.push(nftId2);
        arr2.push(nftId1);

        UserCards[p1][cId2] = arr1;
        UserCards[p2][cId1] = arr2;

        return (true, nftId2, nftId1);
    }

    function workOnUserCards(address _user, uint256 _cId) public view returns (uint256) {
        uint256 last = UserCards[_user][_cId].length - 1;
        uint256 nftId = UserCards[_user][_cId][last];
        return nftId;
    }

    function getBase() public view returns (string memory) {
        return base;
    }

    function pushCard(address _to, uint256 fate, uint256 cardCounter) public {
        UserCards[_to][fate].push(cardCounter);
    }

    function allowAccess(address _main) external onlyOwner {
        main = _main;
    }

    function getLuckAddress() external view onlyAuthorized returns (address) {
        return address(luck);
    }
}
