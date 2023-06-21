// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/EthOpenRaise.sol";

contract OpenRaiseTest is Test {
    EthOpenRaise public raise;

    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");
    address USER3 = makeAddr("user3");

    function setUp() public {
        raise = new EthOpenRaise("Test", 0.1 ether, 1 ether);
        vm.deal(USER1, 2 ether);
        vm.deal(USER2, 2 ether);
        vm.deal(USER3, 2 ether);
    }

    function test_contributeLessThanMin() public {
        vm.startPrank(USER1);
        vm.expectRevert(MV_OpenRaise_MinNotMet.selector);
        raise.contribute{value: 0.09 ether}();
        vm.stopPrank();
    }

    function test_contributePass() public {
        vm.startPrank(USER1);
        raise.contribute{value: 0.5 ether}();
        vm.stopPrank();

        assertEq(raise.contributions(USER1), 0.5 ether);
        assertEq(raise.totalContributions(), 0.5 ether);
        assertEq(raise.totalContributors(), 1);

        vm.startPrank(USER2);
        raise.contribute{value: 1 ether}();
        vm.stopPrank();

        assertEq(raise.contributions(USER2), 1 ether);
        assertEq(raise.totalContributions(), 1.5 ether);
        assertEq(raise.totalContributors(), 2);
    }

    function test_contributeMoreButNotMax() public {
        vm.startPrank(USER1);
        raise.contribute{value: 0.5 ether}();
        raise.contribute{value: 0.2 ether}();
        vm.stopPrank();

        assertEq(raise.contributions(USER1), 0.7 ether);
        assertEq(raise.totalContributions(), 0.7 ether);
        assertEq(raise.totalContributors(), 1);
    }

    function test_contributeMoreThanMax() public {
        vm.startPrank(USER1);
        raise.contribute{value: 0.5 ether}();
        vm.expectRevert(MV_OpenRaise_MaxMet.selector);
        raise.contribute{value: 0.6 ether}();
        vm.stopPrank();

        vm.prank(USER2);
        vm.expectRevert(MV_OpenRaise_MaxMet.selector);
        raise.contribute{value: 1.1 ether}();
    }

    function test_withdraw() public {
        vm.prank(USER1);
        raise.contribute{value: 0.5 ether}();
        vm.prank(USER2);
        raise.contribute{value: 1 ether}();
        vm.prank(USER3);
        raise.contribute{value: 0.8 ether}();

        vm.prank(USER1);
        vm.expectRevert(MV_OpenRaise_onlyOwner.selector);
        raise.withdraw(USER1);

        uint initBalance = address(USER2).balance;
        raise.withdraw(USER2);
        assertEq(address(USER2).balance, initBalance + 2.3 ether);
    }
}
