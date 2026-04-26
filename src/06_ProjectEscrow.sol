// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

 /*----------------------------------------------------------------------------
 * DISCLAIMER EDUCATIVO
 * Contrato intencionadamente vulnerable.
 * Módulo 3 - Auditoría de Smart Contracts
 * Curso de Blockchain de la Universidad de Málaga
 *---------------------------------------------------------------------------*/
 
 /*----------------------------------------------------------------------------
 * DESCRIPCIÓN
 * Este contrato simula una recaudación pequeña para un proyecto. 
 * Mientras la campaña está abierta, cada participante puede retirar su aportación; 
 * cuando se cierra, el owner puede llevarse los fondos. 
 *---------------------------------------------------------------------------*/
contract ProjectEscrow {
    address public owner;
    bool public fundingFinalized;

    mapping(address => uint256) public contributions;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function supportProject() external payable {
        require(!fundingFinalized, "Funding finalized");
        require(msg.value > 0, "Zero contribution");
        contributions[msg.sender] += msg.value;
    }

    function finalizeFunding() external onlyOwner {
        fundingFinalized = true;
    }

    function cancelSupport() external {
        require(!fundingFinalized, "Funding closed");

        uint256 amount = contributions[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "Transfer failed");

        contributions[msg.sender] = 0;
    }

    function releaseToOwner() external onlyOwner {
        require(fundingFinalized, "Not finalized");

        (bool ok, ) = payable(owner).call{value: address(this).balance}("");
        require(ok, "Release failed");
    }
}