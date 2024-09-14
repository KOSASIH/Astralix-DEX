pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract DisputeResolver is Ownable {
    using Strings for string;
    using SafeMath for uint256;

    // Mapping of disputes
    mapping (uint256 => Dispute) public disputes;

    // Mapping of dispute resolutions
    mapping (uint256 => DisputeResolution) public disputeResolutions;

    // Event emitted when a dispute is created
    event DisputeCreated(uint256 indexed disputeId, address indexed user1, address indexed user2);

    // Event emitted when a dispute is resolved
    event DisputeResolved(uint256 indexed disputeId, address indexed winner, uint256 reward);

    // Event emitted when a dispute status is updated
    event DisputeStatusUpdated(uint256 indexed disputeId, DisputeStatus status);

    // Enum for dispute status
    enum DisputeStatus { Pending, Resolved, Rejected }

    // Struct for dispute
    struct Dispute {
        uint256 id;
        address user1;
        address user2;
        string description;
        DisputeStatus status;
    }

    // Struct for dispute resolution
    struct DisputeResolution {
        uint256 disputeId;
        address winner;
        uint256 reward;
    }

    // Constructor
    constructor() public {
        // Initialize dispute resolver owner
    }

    // Create a dispute
    function createDispute(address user1, address user2, string memory description) public {
        require(user1 != address(0) && user2 != address(0), "Invalid users");
        require(description.isNotEmpty(), "Invalid description");

        uint256 disputeId = uint256(keccak256(abi.encodePacked(user1, user2, description)));
        disputes[disputeId] = Dispute(disputeId, user1, user2, description, DisputeStatus.Pending);
        emit DisputeCreated(disputeId, user1, user2);
    }

    // Resolve a dispute
    function resolveDispute(uint256 disputeId, address winner, uint256 reward) public onlyOwner {
        require(disputes[disputeId].status == DisputeStatus.Pending, "Dispute is not pending");
        disputes[disputeId].status = DisputeStatus.Resolved;
        disputeResolutions[disputeId] = DisputeResolution(disputeId, winner, reward);
        emit DisputeResolved(disputeId, winner, reward);
    }

    // Update dispute status
    function updateDisputeStatus(uint256 disputeId, DisputeStatus status) public onlyOwner {
        require(disputes[disputeId].status != status, "Dispute status is already updated");
        disputes[disputeId].status = status;
        emit DisputeStatusUpdated(disputeId, status);
    }

    // Distribute dispute resolution rewards
    function distributeReward(uint256 disputeId) public {
        require(disputeResolutions[disputeId].reward > 0, "No reward to distribute");
        payable(disputeResolutions[disputeId].winner).transfer(disputeResolutions[disputeId].reward);
    }

    // Get dispute
    function getDispute(uint256 disputeId) public view returns (Dispute memory) {
        return disputes[disputeId];
    }

    // Get dispute resolution
    function getDisputeResolution(uint256 disputeId) public view returns (DisputeResolution memory) {
        return disputeResolutions[disputeId];
    }
}
