// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface INfts {
    function mint(address _to, string memory _uri) external;
    function tokenURI(uint256 tokenId) external view returns (string memory);
    // function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function getCurrentCounter() external view returns (uint256);
    function transfer(address _to, uint256 _tokenId) external;
    function getOwnerOfToken(uint256 _id) external view returns (address);
    // function allowAccess(address _main, address _card) external;
}
