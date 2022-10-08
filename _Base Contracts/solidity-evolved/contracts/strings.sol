// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.15;

contract ModernTypes {

    // Compare two strings
    function STRING_IS(string memory a, string memory b) public pure returns (bool equal) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    // ANCHOR Concatenate two strings
    function STRING_CONCAT(string memory a, string memory b) public pure returns (string memory _concat) {
        return string.concat(a, b);
    }

    // ANCHOR Concatenate a list of strings
    function STRING_JOIN(string[] memory all) public pure returns (string memory _joint) {
        string memory joint = "";
        for (uint i = 0; i < all.length; i++) {
            joint = string.concat(joint, all[i]);
        }
        return joint;
    }

    // ANCHOR String A contains String B?
    function STRING_CONTAINS(string memory what, string memory where)
        public
        pure
        returns (bool found)
    {
        // Transforming the strings into byte arrays
        bytes memory whatBytes = bytes(what);
        bytes memory whereBytes = bytes(where);
        // Ensuring that the strings are comparable
        require(whereBytes.length >= whatBytes.length);
        // Parsing all the combinations
        for (uint256 i = 0; i <= whereBytes.length - whatBytes.length; i++) {
            bool flag = true;
            // Each cycle compare the bytes we are taking into consideration
            for (uint256 j = 0; j < whatBytes.length; j++) {
                if (whereBytes[i + j] != whatBytes[j]) {
                    // This cycle does not contains what is needed
                    flag = false;
                    break;
                }
            }
            // Each cycle, check if has been found an occurrence
            if (flag) {
                return true;
            }
        }
        // If no occurrence has been found, return false
        return false;
    }

    // ANCHOR String to Address conversion
    function STRING_TO_ADDRESS(string memory _a)
        internal
        pure
        returns (address _parsedAddress)
    {
        bytes memory tmp = bytes(_a);
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint256 i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(tmp[i]));
            b2 = uint160(uint8(tmp[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }
        return address(iaddr);
    }

    // ANCHOR Address to string conversion
    function ADDRESS_TO_STRING(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }
        return string(s);   
    }


    // ANCHOR Address to Bytes32
    function ADDRESS_TO_BYTES32(address a) public pure returns (bytes32 addr) {
        return bytes32(uint256(uint160(a)) << 96);
    }

    // ANCHOR Bytes32 to Address
    function BYTES_TO_ADDRESS(bytes32 data) public pure returns (address addr) {
        return address(uint160(uint256(data)));
    }

    // ANCHOR String to Uint
    function STRING_TO_UINT(string memory a) public pure returns (uint256 result) {
        bytes memory b = bytes(a);
        uint256 i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint256 c = uint256(uint8(b[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }

    // ANCHOR Uint to string conversion
    function UINT_TO_STRING(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // SECTION Helpers

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

    // !SECTION

}