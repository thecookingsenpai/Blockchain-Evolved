// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.15;

contract AssemblyWrapper {

    // SECTION Mathematics
    function ASM_SUM(uint[] memory data) public pure returns (uint sum) {
        assembly {
            // Load the length (first 32 bytes)
            let len := mload(data)

            // Skip over the length field.
            //
            // Keep temporary variable so it can be incremented in place.
            //
            // NOTE: incrementing data would result in an unusable
            //       data variable after this assembly block
            let dataElementLocation := add(data, 0x20)

            // Iterate until the bound is not met.
            for
                { let end := add(dataElementLocation, mul(len, 0x20)) }
                lt(dataElementLocation, end)
                { data := add(dataElementLocation, 0x20) }
            {
                sum := add(sum, mload(dataElementLocation))
            }
        }
    }

  function ASM_SUB(uint[] memory _data) public pure returns (uint o_sub) {
    assembly {
      let len := mload(_data)
      let dataElementLocation := add(_data, 0x20)

      for
        { let end := add(dataElementLocation, mul(len, 0x20)) }
        lt(dataElementLocation, end)
        { dataElementLocation := add(dataElementLocation, 0x20) }
      {
        o_sub := sub(o_sub, mload(dataElementLocation))
      }
    }
   }

    function ASM_MUL(uint[] memory _data) public pure returns (uint o_mul) {
        assembly {
        let len := mload(_data)
        let dataElementLocation := add(_data, 0x20)
    
        for
            { let end := add(dataElementLocation, mul(len, 0x20)) }
            lt(dataElementLocation, end)
            { dataElementLocation := add(dataElementLocation, 0x20) }
        {
            o_mul := mul(o_mul, mload(dataElementLocation))
        }
        }
     }

    function ASM_DIV(uint[] memory _data) public pure returns (uint o_div) {
        assembly {
        let len := mload(_data)
        let dataElementLocation := add(_data, 0x20)
    
        for
            { let end := add(dataElementLocation, mul(len, 0x20)) }
            lt(dataElementLocation, end)
            { dataElementLocation := add(dataElementLocation, 0x20) }
        {
            o_div := div(o_div, mload(dataElementLocation))
        }
        }
     }

    function ASM_POWER(uint _base, uint _exp) public pure returns (uint o_power) {
        uint output = 1;
        assembly {
                    function power(base, exponent) -> result
                    {
                        result := 1
                        for { let i := 0 } lt(i, exponent) { i := add(i, 1) }
                        {
                            result := mul(result, base)
                        }
                    }
                    output := power(_base, _exp)
        }
        return output;
    }

    // !SECTION

    // SECTION String helpers
    function ASM_IS(string memory first, string memory second) public pure returns (bool) {
        bool areEqual;
        assembly {
           function stringToBytes(a) -> b {
                b := mload(add(a, 32))
            }
            let bytesFirst := stringToBytes(first)
            let bytesSecond := stringToBytes(second)
            if eq(bytesFirst, bytesSecond) {
                areEqual := true
            }
        }
        return areEqual;
    }

    // SECTION overloaded comparison

    function ASM_COMPARE(string memory first, address second) public pure returns (bool) {
        bool areEqual;
        assembly {
            if eq(first, second) {
                areEqual := true
            }
        }
        return areEqual;
    }

    function ASM_COMPARE(string memory first, uint second) public pure returns (bool) {
        bool areEqual;
        assembly {
           function stringToBytes(a) -> b {
                b := mload(add(a, 32))
            }
            let bytesFirst := stringToBytes(first)
            let bytesSecond := stringToBytes(second)
            if eq(bytesFirst, bytesSecond) {
                areEqual := true
            }
        }
        return areEqual;
    }

    function ASM_COMPARE(string memory first, bytes32 second) public pure returns (bool) {
        bool areEqual;
        assembly {
            if eq(first, second) {
                areEqual := true
            }
        }
        return areEqual;
    }

    // !SECTION

    // !SECTION

}