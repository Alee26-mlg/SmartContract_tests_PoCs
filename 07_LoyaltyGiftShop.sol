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
 * Este contrato lleva puntos de fidelidad muy simples y permite canjearlos 
 * por un regalo. 
 *---------------------------------------------------------------------------*/
contract LoyaltyGiftShop {
    address public owner;
    uint256 public giftPrice = 100;

    mapping(address => uint256) public points;
    mapping(address => uint256) public redeemedGifts;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function grantPoints(address user, uint256 amount) external onlyOwner {
        points[user] += amount;
    }

    function setGiftPrice(uint256 newPrice) external onlyOwner {
        giftPrice = newPrice;
    }

    function redeemGift() external {
        unchecked {
            points[msg.sender] -= giftPrice;
        }

        redeemedGifts[msg.sender] += 1;
    }
}