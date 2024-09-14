pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol";

contract AstralixDEX {
    using ReentrancyGuard for address;

    // Reentrancy guard
    uint256 private reentrancyLock;

    // Example of a function with reentrancy safeguards
    function withdrawFunds(uint256 _amount) public nonReentrant {
        // Withdrawal logic
        reentrancyLock = 1;
        // ...
        reentrancyLock = 0;
    }
}
