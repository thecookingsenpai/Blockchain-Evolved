// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.6;

library BitDegas {


    /// Efficient retrieve
    function get_element(uint8 bit_array, uint8 index) public pure returns(uint8 value) {
        return ((bit_array & index) > 0) ? 1 : 0;
    }


    function TrueOrFalse(uint8 boolean_array, uint8 bool_index) public pure returns(bool bool_result) {
        return (boolean_array & bool_index) > 0;
    }

    function setTrue(uint8 boolean_array, uint8 bool_index) public pure returns(uint8 resulting_array){
        return boolean_array | (((boolean_array & bool_index) > 0) ? 1 : 0);
    }

    function setFalse(uint8 boolean_array, uint8 bool_index) public pure returns(uint8 resulting_array){
         return boolean_array & (((boolean_array & bool_index) > 0) ? 1 : 0);
    }

    /// Mathematics

    function addition(uint a, uint b) public pure returns(uint) {
        while(!(b==0)) {
            uint carry = a & b;
            a = a^b;
            b = carry << 1;
        }
        return a;
    }

    function subtraction(uint a, uint b) public pure returns(uint) {
        while(!(b==0)) {
            uint carry = (~a) & b;
            a = a^b;
            b = carry << 1;
        }
        return a;
    }

    function multiply(uint x, uint y) public pure returns (uint) {
        uint reg = 0;
        while (y != 0)
        {
            if (!((y) & uint(1)==0))
            {
                reg += x;
            }
            x <<= 1;
            y >>= 1;
        }
        return reg;
    }


    function division(uint dividend, uint divisor) public pure returns(uint) {
        uint quotient = 0;
        while (dividend >= divisor) {
            dividend -= divisor;
            quotient+=1;
        }

        // Return the value of quotient with the appropriate sign.
        return quotient;
    }
        
}

contract StrangeBits {
    using BitDegas for uint8;
    using BitDegas for uint;

    uint8 control_bit;

    
    function control_bit_bit() public {
        control_bit = control_bit.setFalse(3);
        if(control_bit.TrueOrFalse(3)) {
            control_bit.setTrue(3);
        }
    }
    
    function control_bit_bit_multi() public {
        control_bit = control_bit.setFalse(3);
        if(control_bit.TrueOrFalse(1)) {
            control_bit.setTrue(1);
        }

        control_bit = control_bit.setFalse(3);
        if(control_bit.TrueOrFalse(2)) {
            control_bit.setTrue(2);
        }


        control_bit = control_bit.setFalse(3);
        if(control_bit.TrueOrFalse(3)) {
            control_bit.setTrue(3);
        }


        control_bit = control_bit.setFalse(3);
        if(control_bit.TrueOrFalse(4)) {
            control_bit.setTrue(4);
        }
    }

    function control_bit_mul(uint n, uint u) public pure returns(uint){
       return n.multiply(u);
    }
    
    function control_bit_div(uint n, uint u) public pure returns(uint){
       return n.division(u);
    }
    function control_bit_add(uint n, uint u) public pure returns(uint){
       return n.addition(u);
    }
    function control_bit_sub(uint n, uint u) public pure returns(uint){
       return n.subtraction(u);
    }

}


contract StrangeBools {

    bool[4] control_bool;
    
    function control_bit_norm() public {
        control_bool[0] = false;
        if(!control_bool[0]) {
            control_bool[0] = true;
        }
    }

    function control_bool_norm_multi() public {
        control_bool[0] = false;
        control_bool[1] = false;
        control_bool[2] = false;
        control_bool[3] = false;

        if(!control_bool[0]) {
            control_bool[0] = true;
        }
        if(!control_bool[1]) {
            control_bool[1] = true;
        }
        if(!control_bool[2]) {
            control_bool[2] = true;
        }
        if(!control_bool[3]) {
            control_bool[3] = true;
        }

    }


    function control_norm_mul(uint n, uint u) public pure returns(uint){
       return n * u;
    }
    
    function control_norm_div(uint n, uint u) public pure returns(uint){
       return uint(n) / uint(u);
    }
    function control_norm_add(uint n, uint u) public pure returns(uint){
       return n + u;
    }
    function control_norm_sub(uint n, uint u) public pure returns(uint){
       return n- u;
    }
}

contract tester is StrangeBits, StrangeBools {
    
}