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
 * Este contrato simula una wallet de equipo. 
 * El owner puede aprobar proveedores y pagarles.
 *---------------------------------------------------------------------------*/
contract TeamWallet {
    address public owner;
    uint256 public paymentCount;

    mapping(address => bool) public approvedSuppliers;

    constructor() payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    //-------------------------------Public------------------------------------

    function approveSupplier(address supplier) external onlyOwner {
        approvedSuppliers[supplier] = true;
    }

    function removeSupplier(address supplier) external onlyOwner {
        approvedSuppliers[supplier] = false;
    }

    function paySupplier(address payable supplier, uint256 amount) external onlyOwner {
        require(approvedSuppliers[supplier], "Supplier not approved");
        require(address(this).balance >= amount, "Insufficient balance");
        _executePayment(supplier, amount);
    }

    function deposit() external payable {}

    //-------------------------------Internal------------------------------------
    
    function _executePayment(address payable supplier, uint256 amount) public {
        paymentCount += 1;

        (bool ok, ) = supplier.call{value: amount}("");
        require(ok, "Payment failed");
    }
}