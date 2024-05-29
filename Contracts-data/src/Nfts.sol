// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Nfts is ERC721, ERC721URIStorage, Ownable(msg.sender) {
    uint256 private _tokenCounter;

    address private main;
    address private card;

    mapping(uint256 => address) public _tokenOwners;

    constructor() ERC721("FATE", "FT") {
        _tokenCounter = 0;
    }

    error NFTS__OnlyAuthorized();

    modifier onlyAuthorized() {
        if (msg.sender == owner() || msg.sender == main || msg.sender == card) {
            _;
        } else {
            revert NFTS__OnlyAuthorized();
        }
    }

    function mint(address _to, string memory _uri) public onlyAuthorized {
        uint256 newItemId = _tokenCounter;
        _tokenOwners[newItemId] = _to;
        _mint(_to, newItemId);
        _setTokenURI(newItemId, _uri);
        _tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return supportsInterface(interfaceId);
    }

    function getCurrentCounter() public view returns (uint256) {
        return _tokenCounter;
    }

    function transfer(address _to, uint256 _tokenId) public onlyAuthorized {
        _tokenOwners[_tokenId] = _to;
    }

    function getOwnerOfToken(uint256 _id) public view returns (address) {
        return _tokenOwners[_id];
    }

    function allowAccess(address _main, address _card) public onlyOwner {
        main = _main;
        card = _card;
    }
}
