// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DAOProposal {
    
    enum ProposalType { AddMember, AddSubDAO } // Added an enum for proposal types

    struct Proposal {
        string title; //name of proposal
        string description; //description of proposal
        address proposer; //msg.sender
        ProposalType proposalType; // Added a proposal type
        address targetAddress; // Address related to the proposal (e.g., new member address)
        uint256 forVotes;
        uint256 againstVotes;
        uint256 endTime;
        bool executed;
        mapping(address => bool) voters;
    }

    struct SubDAO {
        string name;
        string description;
        string subDAOtype;
        mapping(address => bool) members;
        mapping(address => string) roles;
        uint256 memberCount;
    }

    Proposal[] public proposals;
    mapping(address => bool) public members;
    uint256 public memberCount = 0;
    uint256 public quorum;
    uint256 public votingDuration;

    mapping(address => SubDAO) public subDAOs;
    address[] public subDAOAddresses;

    event ProposalCreated(uint256 proposalId, string title, address proposer);
    event Voted(uint256 proposalId, address voter, bool vote);
    event SubDAOCreated(address indexed subDAOAddress, string name);


    modifier onlyMember() {
        require(members[msg.sender], "Only members can perform this action");
        _;
    }


    //@dev Voting duration is in seconds
    constructor(uint256 _quorum, uint256 _votingDuration) {
        require(_quorum > 0 && _quorum <= 100, "Quorum must be between 1 and 100");
        quorum = _quorum;
        votingDuration = _votingDuration;
    }

    function createSubDAO(string memory _name, uint256 _proposalId) public returns (address) {
        require(bytes(_name).length > 0, "SubDAO name is required");
        //require that the proposal to create a subDAO is passed
        require(proposals[_proposalId].proposalType == ProposalType.AddSubDAO, "Proposal must be to create a subDAO");
        require(proposals[_proposalId].forVotes > quorum, "Proposal must have enough votes to pass");

        SubDAO storage newSubDAO = subDAOs[msg.sender];
        newSubDAO.name = _name;

        subDAOAddresses.push(msg.sender);

        emit SubDAOCreated(msg.sender, _name);
        return msg.sender;
    }

    function addMember(address _member) public onlyMember {
        if (!members[_member]) {
            members[_member] = true;
            memberCount++;
        }
    }

    //Batch add members
    function addMembers(address[] memory _members) public onlyMember {
        for (uint256 i = 0; i < _members.length; i++) {
            addMember(_members[i]);
        }
    }

    function createProposal(string memory _title, string memory _description, ProposalType _type, address _targetAddress) public onlyMember returns (uint256) {
        uint256 proposalId = proposals.length;
        Proposal storage newProposal = proposals.push();

        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.proposer = msg.sender;
        newProposal.proposalType = _type;
        newProposal.targetAddress = _targetAddress;
        newProposal.forVotes = 0;
        newProposal.againstVotes = 0;
        newProposal.endTime = block.timestamp + votingDuration;
        newProposal.executed = false;

        emit ProposalCreated(proposalId, _title, msg.sender);
        return proposalId;
    }

    function vote(uint256 _proposalId, bool _vote) public onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp < proposal.endTime, "Voting period has ended");
        require(!proposal.voters[msg.sender], "You have already voted");

        proposal.voters[msg.sender] = true;
        if (_vote) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        emit Voted(_proposalId, msg.sender, _vote);
    }

    function executeProposal(uint256 _proposalId) public onlyMember {
        Proposal storage proposal = proposals[_proposalId];
        require(block.timestamp >= proposal.endTime, "Voting period has not ended yet");
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.forVotes + proposal.againstVotes >= (quorum * memberCount) / 100, "Quorum not reached"); // probably got rounding error but ignore coz for voting

        if (proposal.forVotes > proposal.againstVotes) {
            if (proposal.proposalType == ProposalType.AddMember) {
                addMember(proposal.targetAddress);
            }

        }

        proposal.executed = true;
    }

    function listAllSubDAOs() public view returns (address[] memory) {
        return subDAOAddresses;
    }

    
}