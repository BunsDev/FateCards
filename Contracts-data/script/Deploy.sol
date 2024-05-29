// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Main} from "../src/Main.sol";
import {Card} from "../src/Card.sol";
import {Nfts} from "../src/Nfts.sol";
import {Luck} from "../src/Luck.sol";

contract Deploy is Script {
    function run() external returns (Main, Card, Nfts) {
        vm.startBroadcast();
        Nfts nfts = new Nfts();
        Card card = new Card(address(nfts));
        Main main = new Main(address(card), address(nfts));
        nfts.allowAccess(address(main), address(card));
        card.allowAccess(address(main));
        console.log(card.getLuckAddress());
        vm.stopBroadcast();
        return (main, card, nfts);
    }
}
