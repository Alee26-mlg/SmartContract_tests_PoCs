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
 * Este contrato gestiona reembolsos de forma individual. El owner puede 
 * configurar un reembolso para cada usuario y luego procesarlo. 
 *---------------------------------------------------------------------------*/
contract RefundManager {
    address public owner;
    uint256 public totalPaid;

    mapping(address => uint256) public approvedRefunds;
    mapping(address => bool) public processed;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function fund() external payable onlyOwner {}

    function setRefund(address user, uint256 amount) external onlyOwner {
        require(!processed[user], "Already processed");
        approvedRefunds[user] = amount;
    }

    function processRefund(address user) external onlyOwner {
        uint256 amount = approvedRefunds[user];
        require(amount > 0, "No refund configured");
        require(!processed[user], "Already processed");

        processed[user] = true;
        approvedRefunds[user] = 0;

        (bool success, ) = payable(user).call{value: amount}("");
        if (success) {
            totalPaid += amount;
        }
    }
}