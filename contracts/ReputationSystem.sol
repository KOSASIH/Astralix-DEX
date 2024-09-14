pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract ReputationSystem is Ownable {
    using SafeMath for uint256;

    // Mapping of user reputation scores
    mapping (address => uint256) public userReputationScores;

    // Mapping of user reputation levels
    mapping (address => uint256) public userReputationLevels;

    // Event emitted when a user's reputation score is updated
    event ReputationScoreUpdated(address indexed user, uint256 score);

    // Event emitted when a user's reputation level is updated
    event ReputationLevelUpdated(address indexed user, uint256 level);

    // Constructor
    constructor() public {
        // Initialize reputation system owner
        userReputationScores[owner()] = 100;
        userReputationLevels[owner()] = 1;
    }

    // Track user behavior (e.g., trading history, dispute resolution)
    function trackUserBehavior(address user, uint256 behaviorScore) public onlyOwner {
        require(user != address(0), "Invalid user");
        userReputationScores[user] = userReputationScores[user].add(behaviorScore);
        updateReputationLevel(user);
    }

    // Calculate reputation score
    function calculateReputationScore(address user) public view returns (uint256) {
        return userReputationScores[user];
    }

    // Update user reputation level
    function updateReputationLevel(address user) internal {
        uint256 reputationScore = userReputationScores[user];
        if (reputationScore >= 100 && reputationScore < 500) {
            userReputationLevels[user] = 2;
        } else if (reputationScore >= 500 && reputationScore < 1000) {
            userReputationLevels[user] = 3;
        } else if (reputationScore >= 1000) {
            userReputationLevels[user] = 4;
        } else {
            userReputationLevels[user] = 1;
        }
        emit ReputationLevelUpdated(user, userReputationLevels[user]);
    }

    // Restrict access to certain features based on reputation level
    modifier onlyTrustedUsers {
        require(userReputationLevels[msg.sender] >= 3, "User reputation level is too low");
        _;
    }

    // Example function that requires a high reputation level
    function restrictedFunction() public onlyTrustedUsers {
        // Only trusted users can access this function
    }

    // Get user reputation score
    function getUserReputationScore(address user) public view returns (uint256) {
        return userReputationScores[user];
    }

    // Get user reputation level
    function getUserReputationLevel(address user) public view returns (uint256) {
        return userReputationLevels[user];
    }
}
