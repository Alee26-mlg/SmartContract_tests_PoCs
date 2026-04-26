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
 * En este contrato, varias personas ponen dinero para un regalo conjunto. 
 * Si al final se cancela, el owner ejecuta la devolución. 
 *---------------------------------------------------------------------------*/
contract GroupGiftRefunds {
    address public owner;
    address public giftRecipient;
    uint256 public contributionSize;
    bool public giftSent;
    bool public cancelled;

    address[] public members;
    mapping(address => bool) public joined;
    mapping(address => uint256) public contributions;

    constructor(uint256 _contributionSize, address _giftRecipient) {
        owner = msg.sender;
        giftRecipient = _giftRecipient;
        contributionSize = _contributionSize;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function join() external payable {
        require(!cancelled, "Campaign cancelled");
        require(!giftSent, "Gift already sent");
        require(!joined[msg.sender], "Already joined");
        require(msg.value == contributionSize, "Wrong contribution");

        members.push(msg.sender);
        joined[msg.sender] = true;
        contributions[msg.sender] = msg.value;
    }

    function memberCount() external view returns (uint256) {
        return members.length;
    }

    function sendGift() external onlyOwner {
        require(!cancelled, "Campaign cancelled");
        require(!giftSent, "Gift already sent");
        require(members.length > 0, "No members");

        giftSent = true;

        (bool ok, ) = payable(giftRecipient).call{value: address(this).balance}("");
        require(ok, "Gift transfer failed");
    }

    function cancelCampaign() external onlyOwner {
        require(!cancelled, "Campaign cancelled");
        require(!giftSent, "Gift already sent");
        
        cancelled = true;
    }

    function refundAll() external onlyOwner {
        require(cancelled, "Not cancelled");

        for (uint256 i = 0; i < members.length; i++) {
            address member = members[i];
            uint256 amount = contributions[member];

            if (amount > 0) {
                contributions[member] = 0;

                (bool ok, ) = payable(member).call{value: amount}("");
                require(ok, "Refund failed"); 
            }
        }
    }
}