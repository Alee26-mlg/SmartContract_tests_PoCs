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
 * Este contrato simula una reserva sencilla para un workshop. 
 * Cada persona paga un depósito para apuntarse y, si el evento se cancela, 
 * debería poder recuperarla. Si el evento no se cancela, para poder asistir
 * debe de confirmas la asistencia, lo que transfiere su depósito al organizador.
 *
 * (Primero estudia el flujo funcional, luego busca el fallo)
 *---------------------------------------------------------------------------*/
contract WorkshopBooking {
    address public organizer;
    uint256 public depositAmount; 
    bool public registrationClosed; 
    bool public cancelled;

    mapping(address => uint256) public deposits;

    constructor(uint256 _depositAmount) {
        organizer = msg.sender;
        depositAmount = _depositAmount;
    }

    modifier onlyOrganizer() {
        require(msg.sender == organizer, "Not organizer");
        _;
    }

    function register() external payable {
        require(!registrationClosed, "Registration closed");
        require(deposits[msg.sender] == 0, "Already registered");
        require(msg.value == depositAmount, "Wrong deposit");
        deposits[msg.sender] = msg.value;
    }

    function closeRegistration() external onlyOrganizer {
        registrationClosed = true;
    }

    function cancelEvent() external onlyOrganizer {
        cancelled = true;
    }

    function withdrawDeposit() external {
        require(cancelled, "Event not cancelled");
        require(registrationClosed, "Refunds not enabled yet");

        deposits[msg.sender] = 0;
        (bool ok, ) = payable(msg.sender).call{value: depositAmount}("");
        require(ok, "Transfer failed");
    }
 
    function confirmAttendance() external {
        require(!cancelled, "Event cancelled");
        require(deposits[msg.sender] == depositAmount, "Not registered");

        deposits[msg.sender] = 0;
        (bool ok, ) = payable(organizer).call{value: depositAmount}("");
        require(ok, "Transfer failed");
    }
}