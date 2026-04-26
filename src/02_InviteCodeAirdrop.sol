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
 * Este contrato gestiona un airdrop por invitación. 
 * El owner puede actualizar el código de invitación y los usuarios pueden reclamar
 *---------------------------------------------------------------------------*/
contract InviteCodeAirdrop {
    address public owner;
    uint256 public rewardAmount = 0.01 ether;

    string private inviteCode;
    mapping(address => bool) public claimed;

    constructor(string memory _inviteCode) payable {
        owner = msg.sender;
        inviteCode = _inviteCode;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function updateInviteCode(string calldata newCode) external onlyOwner {
        inviteCode = newCode;
    }

    function fundCampaign() external payable onlyOwner {}

    function claim(string calldata code) external {
        require(!claimed[msg.sender], "Already claimed");
        require(
            keccak256(bytes(code)) == keccak256(bytes(inviteCode)),
            "Invalid code"
        );

        claimed[msg.sender] = true;
        (bool ok, ) = payable(msg.sender).call{value: rewardAmount}("");
        require(ok, "Transfer failed");
    }
}