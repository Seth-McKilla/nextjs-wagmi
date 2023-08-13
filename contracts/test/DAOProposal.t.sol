// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


import "forge-std/Test.sol";
import "../src/DAOProposal.sol"; // Replace with the actual path

contract DAOProposalTest {

    DAOProposal dao;
    address owner;
    address member1 = address(0x123); // Replace with actual address
    address member2 = address(0x456); // Replace with actual address

    function setUp() public {
        dao = new DAOProposal(50, 1 days); // 50% quorum, 1 day voting duration
        owner = msg.sender;
        dao.addMember(owner);
    }

    function testAddMember() public {
        dao.addMember(member1);
        assert(dao.members(member1)== true);
    }

    function testCreateProposal() public {
        uint256 proposalId = dao.createProposal("Test Proposal", "This is a test proposal", DAOProposal.ProposalType.AddMember, member2);
        
        // Destructuring the tuple returned by the proposals function
        (string memory title, , , , , , , ,) = dao.proposals(proposalId);
        
        assert(compareStrings(title, "Test Proposal"));
    }

    function testVote() public {
        uint256 proposalId = dao.createProposal("Test Proposal", "This is a test proposal", DAOProposal.ProposalType.AddMember, member2);
        dao.addMember(member1);
        dao.vote(proposalId, true);
        
        // Destructuring the tuple returned by the proposals function
        (, , , , , uint256 forVotes, , ,) = dao.proposals(proposalId);
        
        assert(forVotes == 1);
    }

    function testExecuteProposal() public {
        uint256 proposalId = dao.createProposal("Test Proposal", "This is a test proposal", DAOProposal.ProposalType.AddMember, member2);
        dao.addMember(member1);
        dao.vote(proposalId, true);
        // Assuming some time manipulation here to simulate the end of the voting period
        dao.executeProposal(proposalId);
        
        // Destructuring the tuple returned by the proposals function
        (, , , , , , , , bool executed) = dao.proposals(proposalId);
        
        assert(executed == true);
        assert(dao.members(member2) == true); // Check if member2 was added
    }

    // Helper function to compare strings
    function compareStrings(string memory a, string memory b) public pure returns(bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }

}