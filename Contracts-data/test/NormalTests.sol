// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Main} from "../src/Main.sol";
import {Card} from "../src/Card.sol";
import {Nfts} from "../src/Nfts.sol";
import {ICard} from "../src/interfaces/ICard.sol";
import {INfts} from "../src/interfaces/INfts.sol";
import {Deploy} from "../script/Deploy.sol";

contract NormalTests is Test {
    Main main;
    Card card;
    Nfts nfts;

    address USER = makeAddr("user");

    function setUp() public {
        Deploy deploy = new Deploy();
        (main, card, nfts) = deploy.run();
    }

    function testCanReveal() public {
        vm.prank(msg.sender);
        card.insertUri("QmRnMygtMaVGYhfbqcMjdPbDaoC7Bohmpn2vhxb3RHJpE1");
        vm.startPrank(USER);
        main.revealFate();
        vm.stopPrank();

        address owner = nfts.getOwnerOfToken(0);
        assertEq(owner, USER);
        uint256 balance = nfts.balanceOf(USER);
        assertEq(balance, 1);
    }

    function testCanTrade() public {
        vm.startPrank(USER);
        main.revealFate();
        vm.stopPrank();

        address USER2 = makeAddr("user2");
        vm.startPrank(USER2);
        main.revealFate();
        vm.stopPrank();

        assert(nfts.getOwnerOfToken(0) == USER);
        assert(nfts.getOwnerOfToken(1) == USER2);

        vm.prank(USER);
        main.trade(address(USER2), 1, 1);

        vm.prank(USER2);
        main.trade(address(USER), 1, 1);

        vm.prank(USER);
        main.confirmTrade();
        vm.prank(USER2);
        main.confirmTrade();

        assert(nfts.getOwnerOfToken(1) == USER);
        assert(nfts.getOwnerOfToken(0) == USER2);
    }

    function testCancelTrade() public {
        vm.prank(msg.sender);
        card.insertUri("QmRnMygtMaVGYhfbqcMjdPbDaoC7Bohmpn2vhxb3RHJpE1");
        vm.startPrank(USER);

        main.revealFate();
        vm.stopPrank();

        address USER2 = makeAddr("user2");

        vm.startPrank(USER2);

        main.revealFate();
        vm.stopPrank();

        vm.prank(USER);
        main.trade(address(USER2), 0, 0);

        vm.prank(USER2);
        main.trade(address(USER), 0, 0);
        vm.prank(USER);
        main.cancelTrade();

        vm.prank(USER);
        (Main.Trade memory t1, Main.Trade memory t2) = main.viewTrade();

        assert(t1.user1 == address(0));
        assert(t1.user2 == address(0));
        assert(t2.user1 == address(0));
        assert(t2.user2 == address(0));
    }

    function testCardShouldBeInPossession() public {
        vm.prank(msg.sender);
        card.insertUri("QmRnMygtMaVGYhfbqcMjdPbDaoC7Bohmpn2vhxb3RHJpE1");
        vm.startPrank(USER);

        main.revealFate();
        vm.stopPrank();

        address USER2 = makeAddr("user2");

        vm.prank(USER);
        vm.expectRevert(Main.Main__CardNotInPossession.selector);
        main.trade(address(USER2), 0, 0);
    }

    function testCardShouldBeValidCard() public {
        vm.prank(msg.sender);
        card.insertUri("QmRnMygtMaVGYhfbqcMjdPbDaoC7Bohmpn2vhxb3RHJpE1");
        vm.startPrank(USER);

        main.revealFate();
        vm.stopPrank();

        address USER2 = makeAddr("user2");

        vm.prank(USER);
        vm.expectRevert(Main.Main__CardNotValid.selector);
        main.trade(address(USER2), 0, 10);
    }

    function testCanSetUpTrade() public {
        vm.prank(msg.sender);
        card.insertUri("QmRnMygtMaVGYhfbqcMjdPbDaoC7Bohmpn2vhxb3RHJpE1");
        vm.startPrank(USER);

        main.revealFate();
        main.showATrade(0, 0);

        vm.stopPrank();

        Main.TradeForShow[] memory ts;
        ts = main.showAllUpTrades();
        assert(ts[0].player == USER);
        assert(ts[0].cardId1 == 0);
        assert(ts[0].cardId2 == 0);
        assert(ts[0].tradeId == 0);
    }

    function testCanPutDownTrade() public {
        testCanSetUpTrade();
        vm.prank(USER);
        main.putDownATrade(0);
        Main.TradeForShow[] memory ts;
        ts = main.showAllUpTrades();
        assert(ts[0].player == address(0));
        assert(ts[0].cardId1 == 0);
        assert(ts[0].cardId2 == 0);
    }

    function testLisOfAllHeldCards() public {
        vm.startPrank(msg.sender);
        main.revealFate();
        main.revealFate();
        main.revealFate();

        vm.stopPrank();
        uint256[][] memory list = card.getListOfAllHeldCard(msg.sender);
        uint256 count = 0;
        for (uint256 i = 0; i < list.length; i++) {
            count += list[i].length;
        }
        assert(count == 3);
    }

    function testDifferentReveals() public returns (uint256, uint256, uint256) {
        vm.prank(msg.sender);
        main.revealFate();
        uint256 a = main.getLatestCard(msg.sender);
        vm.warp(block.timestamp + 1);
        vm.prank(msg.sender);
        main.revealFate();
        uint256 b = main.getLatestCard(msg.sender);
        vm.warp(block.timestamp + 1);
        vm.prank(msg.sender);
        main.revealFate();
        uint256 c = main.getLatestCard(msg.sender);
        return (a, b, c);
    }
}

// test contract invidividually
