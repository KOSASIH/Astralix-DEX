pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Strings.sol";

contract AstralixGovernance is Ownable {
    using SafeMath for uint256;
    using Strings for string;

    // Mapping of proposals
    mapping (uint256 => Proposal) public proposals;

    // Mapping of votes
    mapping (address => mapping (uint256 => Vote)) public votes;

    // Event emitted when a proposal is created
    event ProposalCreated(uint256 indexed proposalId, address indexed proposer, string description);

    // Event emitted when a vote is cast
    event VoteCast(address indexed voter, uint256 indexed proposalId, bool support);

    // Event emitted when a proposal is executed
    event ProposalExecuted(uint256 indexed proposalId, bool executed);

    // Enum for proposal status
    enum ProposalStatus { Pending, Executed, Rejected }

    // Struct for proposal
    struct Proposal {
        uint256 id;
        address proposer;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 yesVotes;
        uint256 noVotes;
        ProposalStatus status;
    }

    // Struct for vote
    struct Vote {
        uint256 proposalId;
        bool support;
    }

    // Constructor
    constructor() public {
        // Initialize governance contract owner
    }

    // Create a proposal
    function createProposal(string memory description, uint256 startTime, uint256 endTime) public {
        require(description.isNotEmpty(), "Invalid description");
        require(startTime > block.timestamp, "Invalid start time");
        require(endTime > startTime, "Invalid end time");

        uint256 proposalId = uint256(keccak256(abi.encodePacked(description, startTime, endTime)));
        proposals[proposalId] = Proposal(proposalId, msg.sender, description, startTime, endTime, 0, 0, ProposalStatus.Pending);
        emit ProposalCreated(proposalId, msg.sender, description);
    }

    // Cast a vote
    function castVote(uint256 proposalId, bool support) public {
        require(proposals[proposalId].status == ProposalStatus.Pending, "Proposal is not pending");
        require(votes[msg.sender][proposalId].proposalId == 0, "User has already voted");

        votes[msg.sender][proposalId] = Vote(proposalId, support);
        if (support) {
            proposals[proposalId].yesVotes = proposals[proposalId].yesVotes.add(1);
        } else {
            proposals[proposalId].noVotes = proposals[proposalId].noVotes.add(1);
        }
        emit VoteCast(msg.sender, proposalId, support);
    }

    // Execute a proposal
    function executeProposal(uint256 proposalId) public onlyOwner {
        require(proposals[proposalId].status == ProposalStatus.Pending, "Proposal is not pending");
        require(proposals[proposalId].endTime < block.timestamp, "Proposal is still active");

        if (proposals[proposalId].yesVotes > proposals[proposalId].noVotes) {
            proposals[proposalId].status = ProposalStatus.Executed;
            emit ProposalExecuted(proposalId, true);
        } else {
            proposals[proposalId].status = ProposalStatus.Rejected;
            emit ProposalExecuted(proposalId, false);
        }
    }

    // Get proposal
    function getProposal(uint256 proposalId) public view returns (Proposal memory) {
        return proposals[proposalId];
    }

    // Get vote
    function getVote(address user, uint256 proposalId) public view returns (Vote memory) {
        return votes[user][proposalId];
    }
}
