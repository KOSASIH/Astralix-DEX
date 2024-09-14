pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract OrderBook is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Mapping of orders
    mapping (uint256 => Order) public orders;

    // Mapping of order book state
    mapping (address => uint256) public orderBookState;

    // Event emitted when an order is created
    event OrderCreated(uint256 orderId, address owner, uint256 amount, uint256 price);

    // Event emitted when an order is canceled
    event OrderCanceled(uint256 orderId, address owner);

    // Event emitted when an order is matched
    event OrderMatched(uint256 buyOrderId, uint256 sellOrderId, uint256 amount, uint256 price);

    // Event emitted when trading fees are calculated
    event TradingFeesCalculated(uint256 amount, uint256 fee);

    // Struct to represent an order
    struct Order {
        uint256 id;
        address owner;
        uint256 amount;
        uint256 price;
        bool isBuy;
    }

    // Constructor
    constructor() public {
        // Initialize order book owner
        orderBookState[owner()] = 0;
    }

    // Create an order
    function createOrder(uint256 amount, uint256 price, bool isBuy) public {
        require(amount > 0, "Invalid order amount");
        require(price > 0, "Invalid order price");

        uint256 orderId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, amount, price, isBuy)));
        orders[orderId] = Order(orderId, msg.sender, amount, price, isBuy);

        emit OrderCreated(orderId, msg.sender, amount, price);
    }

    // Cancel an order
    function cancelOrder(uint256 orderId) public {
        require(orders[orderId].owner == msg.sender, "Only the order owner can cancel");

        delete orders[orderId];

        emit OrderCanceled(orderId, msg.sender);
    }

    // Match buy and sell orders
    function matchOrders() public {
        // Iterate through buy orders
        for (uint256 orderId in orders) {
            if (orders[orderId].isBuy) {
                // Iterate through sell orders
                for (uint256 sellOrderId in orders) {
                    if (!orders[sellOrderId].isBuy && orders[sellOrderId].price <= orders[orderId].price) {
                        // Match orders
                        uint256 amount = orders[orderId].amount < orders[sellOrderId].amount ? orders[orderId].amount : orders[sellOrderId].amount;
                        emit OrderMatched(orderId, sellOrderId, amount, orders[orderId].price);

                        // Update order amounts
                        orders[orderId].amount = orders[orderId].amount.sub(amount);
                        orders[sellOrderId].amount = orders[sellOrderId].amount.sub(amount);

                        // Calculate trading fees
                        uint256 fee = amount.mul(10**18).div(100); // 1% trading fee
                        emit TradingFeesCalculated(amount, fee);

                        // Update order book state
                        orderBookState[AstralixToken(address)] = orderBookState[AstralixToken(address)].add(amount);
                    }
                }
            }
        }
    }

    // Get order book state
    function getOrderBookState(address token) public view returns (uint256) {
        return orderBookState[token];
    }

    // Get order
    function getOrder(uint256 orderId) public view returns (Order memory) {
        return orders[orderId];
    }
}
