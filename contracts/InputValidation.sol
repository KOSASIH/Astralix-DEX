pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/utils/Strings.sol";

contract AstralixDEX {
    using Strings for string;

    // Example of input validation for user input
    function setUsername(string memory _username) public {
        require(_username.length > 0 && _username.length <= 32, "Invalid username length");
        require(_username.isValidUsername(), "Invalid username characters");
        // Update username logic
    }

    // Helper function to validate username characters
    function isValidUsername(string memory _username) internal pure returns (bool) {
        bytes memory usernameBytes = bytes(_username);
        for (uint256 i = 0; i < usernameBytes.length; i++) {
            bytes1 char = usernameBytes[i];
            if (!(char >= 0x30 && char <= 0x39) && // 0-9
                !(char >= 0x41 && char <= 0x5A) && // A-Z
                !(char >= 0x61 && char <= 0x7A)) { // a-z
                return false;
            }
        }
        return true;
    }
}
