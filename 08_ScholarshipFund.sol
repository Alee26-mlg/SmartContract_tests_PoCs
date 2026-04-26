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
 * Este contrato intenta reunir un fondo para una beca. Si se alcanza el 
 * objetivo, el organizador libera el dinero; si no, cada aportante recupera 
 * lo suyo al terminar el plazo. 
 *---------------------------------------------------------------------------*/
contract ScholarshipFund {
    address public organizer;
    uint256 public goal;
    uint256 public deadline;
    bool public released;

    mapping(address => uint256) public contributions;

    constructor(uint256 _goal, uint256 _durationSeconds) {
        organizer = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _durationSeconds;
    }

    modifier onlyOrganizer() {
        require(msg.sender == organizer, "Not organizer");
        _;
    }

    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Zero contribution");

        contributions[msg.sender] += msg.value;
    }

    function releaseScholarship(address payable student) external onlyOrganizer {
        require(block.timestamp >= deadline, "Too early");
        require(!released, "Already released");

        require(address(this).balance == goal, "Goal not reached");

        released = true;
        (bool ok, ) = student.call{value: address(this).balance}("");
        require(ok, "Transfer failed");
    }

    function claimRefund() external {
        require(block.timestamp >= deadline, "Too early");
        require(!released, "Already released");

        require(address(this).balance < goal, "Refunds disabled");

        uint256 amount = contributions[msg.sender];
        require(amount > 0, "Nothing to refund");

        contributions[msg.sender] = 0;
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "Refund failed");
    }
}