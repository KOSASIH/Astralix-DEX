pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Ownable.sol";

contract AstralixToken is ERC20, Ownable {
    using SafeMath for uint256;
    using SafeERC20 for address;

    // Token metadata
    string public constant name = "Astralix Token";
    string public constant symbol = "AXT";
    uint8 public constant decimals = 18;

    // Token supply
    uint256 public totalSupply = 100000000 * (10**decimals);

    // Mapping of balances
    mapping (address => uint256) public balances;

    // Mapping of allowances
    mapping (address => mapping (address => uint256)) public allowances;

    // Event emitted when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Event emitted when an approval is set
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Event emitted when tokens are burned
    event Burn(address indexed burner, uint256 value);

    // Event emitted when tokens are minted
    event Mint(address indexed minter, uint256 value);

    // Constructor
    constructor() public {
        // Initialize token supply and owner
        balances[owner()] = totalSupply;
        emit Transfer(address(0), owner(), totalSupply);
    }

    // Transfer tokens
    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Cannot transfer to zero address");
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] = balances[msg.sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // Approve token spending
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "Cannot approve zero address");

        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // Transfer tokens from one address to another
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0), "Cannot transfer to zero address");
        require(amount <= balances[sender], "Insufficient balance");
        require(amount <= allowances[sender][msg.sender], "Insufficient allowance");

        balances[sender] = balances[sender].sub(amount);
        balances[recipient] = balances[recipient].add(amount);
        allowances[sender][msg.sender] = allowances[sender][msg.sender].sub(amount);

        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Burn tokens
    function burn(uint256 amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalSupply = totalSupply.sub(amount);

        emit Burn(msg.sender, amount);
    }

    // Mint tokens
    function mint(address recipient, uint256 amount) public onlyOwner {
        require(recipient != address(0), "Cannot mint to zero address");

        balances[recipient] = balances[recipient].add(amount);
        totalSupply = totalSupply.add(amount);

        emit Mint(recipient, amount);
    }

    // Get token balance
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // Get token allowance
    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }
}
