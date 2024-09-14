pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Strings.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract AstralixOracle is Ownable {
    using SafeMath for uint256;
    using Strings for string;

    // Mapping of oracles
    mapping (address => Oracle) public oracles;

    // Mapping of price feeds
    mapping (string => PriceFeed) public priceFeeds;

    // Event emitted when an oracle is registered
    event OracleRegistered(address indexed oracle, string description);

    // Event emitted when a price feed is updated
    event PriceFeedUpdated(string indexed symbol, uint256 price);

    // Struct for oracle
    struct Oracle {
        address oracleAddress;
        string description;
    }

    // Struct for price feed
    struct PriceFeed {
        string symbol;
        uint256 price;
        uint256 timestamp;
    }

    // Constructor
    constructor() public {
        // Initialize oracle contract owner
    }

    // Register an oracle
    function registerOracle(address oracleAddress, string memory description) public onlyOwner {
        require(oracleAddress != address(0), "Invalid oracle address");
        require(description.isNotEmpty(), "Invalid description");

        oracles[oracleAddress] = Oracle(oracleAddress, description);
        emit OracleRegistered(oracleAddress, description);
    }

    // Update a price feed
    function updatePriceFeed(string memory symbol, uint256 price) public {
        require(oracles[msg.sender].oracleAddress != address(0), "Only registered oracles can update price feeds");
        require(price > 0, "Invalid price");

        priceFeeds[symbol] = PriceFeed(symbol, price, block.timestamp);
        emit PriceFeedUpdated(symbol, price);
    }

    // Get price feed
    function getPriceFeed(string memory symbol) public view returns (PriceFeed memory) {
        return priceFeeds[symbol];
    }

    // Get oracle
    function getOracle(address oracleAddress) public view returns (Oracle memory) {
        return oracles[oracleAddress];
    }
}
