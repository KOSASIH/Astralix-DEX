pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract FeeManager is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Mapping of fee rates
    mapping (address => uint256) public feeRates;

    // Mapping of liquidity providers
    mapping (address => uint256) public liquidityProviders;

    // Event emitted when a fee rate is updated
    event FeeRateUpdated(address token, uint256 feeRate);

    // Event emitted when fees are distributed
    event FeesDistributed(address[] liquidityProviders, uint256[] amounts);

    // Constructor
    constructor() public {
        // Initialize fee manager owner
        feeRates[owner()] = 0;
    }

    // Set or update a fee rate
    function setFeeRate(address token, uint256 feeRate) public onlyOwner {
        require(feeRate > 0 && feeRate <= 100, "Invalid fee rate");
        feeRates[token] = feeRate;
        emit FeeRateUpdated(token, feeRate);
    }

    // Calculate fees for a trade
    function calculateFees(address token, uint256 amount) public view returns (uint256) {
        return amount.mul(feeRates[token]).div(100);
    }

    // Distribute fees to liquidity providers
    function distributeFees(address[] memory liquidityProviders, uint256[] memory amounts) public onlyOwner {
        require(liquidityProviders.length == amounts.length, "Invalid liquidity provider or amount array length");
        for (uint256 i = 0; i < liquidityProviders.length; i++) {
            liquidityProviders[liquidityProviders[i]] = liquidityProviders[liquidityProviders[i]].add(amounts[i]);
        }
        emit FeesDistributed(liquidityProviders, amounts);
    }

    // Get fee rate
    function getFeeRate(address token) public view returns (uint256) {
        return feeRates[token];
    }

    // Get liquidity provider balance
    function getLiquidityProviderBalance(address liquidityProvider) public view returns (uint256) {
        return liquidityProviders[liquidityProvider];
    }
}
