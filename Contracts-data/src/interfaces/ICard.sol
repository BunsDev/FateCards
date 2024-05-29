// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ICard {
    // Errors
    error CARD__OnlyAuthorized();

    // Events
    event CARD__FateRevealed(address indexed _to, uint256 _fate);

    // Functions
    function getListOfAllHeldCard(address _user) external view returns (uint256[][] memory);

    function reveal(address _to) external returns (uint256);

    function insertUri(string memory _uri) external;

    function viewUri(uint256 _id) external view returns (string memory);

    function getAllTokens(address _user, uint256 _id) external view returns (uint256[] memory);

    function getNumberOfUris() external view returns (uint256);

    function checkCard(address _user, uint256 _cardId) external view returns (bool);

    function tradeCards(address p1, address p2, uint256 cId1, uint256 cId2) external returns (bool, uint256, uint256);

    function workOnUserCards(address _user, uint256 _cId) external view returns (uint256);

    function getBase() external view returns (string memory);

    function pushCard(address _to, uint256 fate, uint256 cardCounter) external;

    function allowAccess(address _main) external;
}
