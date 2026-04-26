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
 * Este contrato organiza un sorteo sencillo entre quienes pagan una entrada. 
 *---------------------------------------------------------------------------*/
contract LunchRaffle {
    address public owner;
    uint256 public ticketPrice;
    bool public roundOpen = true;

    address[] public players;

    constructor(uint256 _ticketPrice) {
        owner = msg.sender;
        ticketPrice = _ticketPrice;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function join() external payable {
        require(roundOpen, "Round closed");
        require(msg.value == ticketPrice, "Wrong ticket price");
        players.push(msg.sender);
    }

    function playerCount() external view returns (uint256) {
        return players.length;
    }

    function closeRound() external onlyOwner {
        require(players.length > 0, "No players");
        roundOpen = false;
    }

    function pickWinner() external onlyOwner {
        require(!roundOpen, "Round still open");

        uint256 index = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, players.length)
            )
        ) % players.length;

        address winner = players[index];

        delete players;
        roundOpen = true;

        (bool ok, ) = payable(winner).call{value: address(this).balance}("");
        require(ok, "Prize transfer failed");
    }
}