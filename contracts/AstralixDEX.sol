pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/access/Roles.sol";

contract AstralixDEX {
    using Roles for address;

    // Define roles for access control
    enum Role { ADMIN, MODERATOR, USER }

    // Mapping of roles to addresses
    mapping (address => Role) public roles;

    // Modifier to restrict access to sensitive functions
    modifier onlyRole(Role _role) {
        require(roles[msg.sender] == _role, "Access denied");
        _;
    }

    // Example of a sensitive function with access control
    function transferFunds(address _recipient, uint256 _amount) public onlyRole(Role.ADMIN) {
        // Transfer funds logic
    }
}
