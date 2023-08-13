// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
//called by the DAO
contract SubDAOProposal {

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

    BountyProposal[] public proposals;
    uint256 public proposalCount = 0;

    event ProposalAdded(uint256 proposalId, string title, uint256 reward);
    event Voted(uint256 proposalId, address voter, bool vote);

    function addProposal(string memory _title, string memory _description, uint256 _reward) public {
        require(bytes(_title).length > 0, "Proposal title is required");
        require(_reward > 0, "Reward should be greater than 0");

        proposalCount++;

        BountyProposal storage newProposal = proposals[proposalCount];
        newProposal.title = _title;
        newProposal.description = _description;
        newProposal.reward = _reward;
        newProposal.proposer = msg.sender;
        newProposal.forVotes = 0;
        newProposal.againstVotes = 0;
        newProposal.executed = false;

        emit ProposalAdded(proposalCount, _title, _reward);
    }

    function vote(uint256 _proposalId, bool _vote) public {
        BountyProposal storage proposal = proposals[_proposalId];
        require(!proposal.voters[msg.sender], "You have already voted");

        proposal.voters[msg.sender] = true;
        if (_vote) {
            proposal.forVotes++;
        } else {
            proposal.againstVotes++;
        }

        emit Voted(_proposalId, msg.sender, _vote);
    }

    function executeProposal(uint256 _proposalId) public {
        BountyProposal storage proposal = proposals[_proposalId];
        require(!proposal.executed, "Proposal has already been executed");
        require(proposal.forVotes > proposal.againstVotes, "The proposal did not get enough votes");

        // Logic to execute the proposal, e.g., release the bounty reward
        proposal.executed = true;
    }

    function listAllProposals() public view returns (uint256[] memory) {
        uint256[] memory proposalIds = new uint256[](proposalCount);
        for (uint256 i = 0; i < proposalCount; i++) {
            proposalIds[i] = i + 1;
        }
        return proposalIds;
    }
}