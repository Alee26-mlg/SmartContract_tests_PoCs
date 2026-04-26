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
 * Este contrato simula una tesorería muy pequeña para gastos operativos. 
 * Tiene límite diario de 1 ether y funciones administrativas básicas. 
 *---------------------------------------------------------------------------*/
contract OfficeTreasury {
    address public owner;
    uint256 public dailyLimit = 1 ether;

    mapping(uint256 => uint256) public spentPerDay;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(tx.origin == owner, "Not authorized");
        _;
    }

    function fund() external payable {}

    function setDailyLimit(uint256 newLimit) external onlyOwner {
        dailyLimit = newLimit;
    }

    function changeOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function payExpense(address payable recipient, uint256 amount)
        external
        onlyOwner
    {
        uint256 dayKey = block.timestamp / 1 days;
        require(spentPerDay[dayKey] + amount <= dailyLimit, "Daily limit exceeded");

        spentPerDay[dayKey] += amount;

        (bool ok, ) = recipient.call{value: amount}("");
        require(ok, "Payment failed");
    }
}