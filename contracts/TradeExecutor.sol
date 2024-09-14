pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract TradeExecutor is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Mapping of user balances
    mapping (address => uint256) public userBalances;

    // Event emitted when a trade is executed
    event TradeExecuted(address indexed buyer, address indexed seller, uint256 amount, uint256 price);

    // Event emitted when trading fees are calculated
    event TradingFeesCalculated(uint256 amount, uint256 fee);

    // Constructor
    constructor() public {
        // Initialize trade executor owner
        userBalances[owner()] = 0;
    }

    // Execute a trade
    function executeTrade(address buyer, address seller, uint256 amount, uint256 price) public {
        require(buyer != address(0) && seller != address(0), "Invalid buyer or seller");
        require(amount > 0 && price > 0, "Invalid trade amount or price");

        // Verify trade validity
        require(userBalances[seller] >= amount, "Seller does not have sufficient balance");
        require(userBalances[buyer] >= amount.mul(price).div(10**18), "Buyer does not have sufficient balance");

        // Update user balances
        userBalances[seller] = userBalances[seller].sub(amount);
        userBalances[buyer] = userBalances[buyer].sub(amount.mul(price).div(10**18));

        // Calculate trading fees
        uint256 fee = amount.mul(10**18).div(100); // 1% trading fee
        emit TradingFeesCalculated(amount, fee);

        // Emit trade event
        emit TradeExecuted(buyer, seller, amount, price);
    }

    // Get user balance
    function getUserBalance(address user) public view returns (uint256) {
        return userBalances[user];
    }
}
