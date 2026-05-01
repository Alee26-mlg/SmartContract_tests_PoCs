
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;


import "forge-std/Test.sol"; 

import "../src/04_RefundManager.sol";


contract RefundUser {

}


    contract BugRefundManager is Test {

        RefundManager contractRefund ;

        RefundUser victim;


        function setUp() public {

            contractRefund = new RefundManager();

            victim = new RefundUser () ;

            vm.deal(address(contractRefund),100 ether);

    }


    function testit() public {

        contractRefund.setRefund(address(victim),10 ether);

        contractRefund.processRefund(address(victim));

        assertEq (address(contractRefund).balance, 100 ether );

        assertEq (contractRefund.approvedRefunds(address(victim)),0);

        assertEq (contractRefund.processed(address(victim)),true);
    }

}