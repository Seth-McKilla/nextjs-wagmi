// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
//called by the DAO
contract SubDAOProposalFactory {

    struct BountyProposal {
        string title;
        string description;
        uint256 reward;
        address proposer;
        uint256 forVotes;
        uint256 againstVotes;
        uint256 endTime;
        bool executed;
        mapping(address => bool) voters;
    }

    struct SubDAO {
        string name;
        mapping(uint256 => BountyProposal) proposals;
        uint256 proposalCount;
        mapping(address => bool) members;
        uint256 memberCount;
    }

    mapping(address => SubDAO) public subDAOs;
    address[] public subDAOAddresses;

    event SubDAOCreated(address indexed subDAOAddress, string name);
    event ProposalAdded(address indexed subDAOAddress, uint256 proposalId, string title, uint256 reward);
    event Voted(address indexed subDAOAddress, uint256 proposalId, address voter, bool vote);

    function createSubDAO(string memory _name) public returns (address) {
        require(bytes(_name).length > 0, "SubDAO name is required");
        require(subDAOs[msg.sender].proposalCount == 0, "SubDAO already exists for this address");

        SubDAO storage newSubDAO = subDAOs[msg.sender];
        newSubDAO.name = _name;

        subDAOAddresses.push(msg.sender);

        emit SubDAOCreated(msg.sender, _name);
        return msg.sender;
    }

    function addProposal(string memory _title, string memory _description, uint256 _reward) public {
        require(bytes(_title).length > 0, "Proposal title is required");
        require(_reward > 0, "Reward should be greater than 0");

        SubDAO storage dao = subDAOs[msg.sender];
        dao.proposalCount++;

        BountyProposal storage newProposal = dao.proposals[dao.proposalCount];
        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.reward = _reward;
        newProposal.proposer = msg.sender;
        newProposal.forVotes = 0;
        newProposal.againstVotes = 0;
        newProposal.executed = false;

        emit ProposalAdded(msg.sender, dao.proposalCount, _title, _reward);
    }

    function vote(uint256 _proposalId, bool _vote) public {
        SubDAO storage dao = subDAOs[msg.sender];
        BountyProposal storage proposal = dao.proposals[_proposalId];
        require(!proposal.voters[msg.sender], "You have already voted");

        proposal.voters[msg.sender] = true;
        if (_vote) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        emit Voted(msg.sender, _proposalId, msg.sender, _vote);
    }

    function executeProposal(uint256 _proposalId) public {
        SubDAO storage dao = subDAOs[msg.sender];
        BountyProposal storage proposal = dao.proposals[_proposalId];
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.forVotes > proposal.againstVotes, "The proposal did not get enough votes");

        // Logic to execute the proposal, e.g., release the bounty reward
        proposal.executed = true;
    }

    function listAllSubDAOs() public view returns (address[] memory) {
        return subDAOAddresses;
    }

    function listAllProposals(address _subDAOAddress) public view returns (uint256[] memory) {
        SubDAO storage dao = subDAOs[_subDAOAddress];
        uint256[] memory proposalIds = new uint256[](dao.proposalCount);
        for (uint256 i = 0; i < dao.proposalCount; i++) {
            proposalIds[i] = i + 1;
        }
        return proposalIds;
    }
}