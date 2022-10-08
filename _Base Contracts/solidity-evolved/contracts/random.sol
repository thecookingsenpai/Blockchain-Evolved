// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.15;

contract randomizable {

    // NOTE Overloading is meant to provide various ways in a single method name

    function random(bytes32 entropy, uint min, uint max) internal view returns(uint) {
        uint rnd = uint(keccak256(abi.encodePacked(block.timestamp,
                                                   block.difficulty,
                                                   block.number,
                                                   tx.origin,
                                                   msg.sender, 
                                                   entropy))) % max;
        rnd = rnd + min;
        return rnd;
    }

    function random(bytes32 entropy, uint min) internal view returns(uint) {
        uint rnd = uint(keccak256(abi.encodePacked(block.timestamp,
                                                   block.difficulty,
                                                   block.number,
                                                   tx.origin,
                                                   msg.sender, 
                                                   entropy))) % (2**256 - 1);
        rnd = rnd + min;
        return rnd;

    }

    function random(bytes32 entropy) internal view returns(uint) {
        uint rnd = uint(keccak256(abi.encodePacked(block.timestamp,
                                                   block.difficulty,
                                                   block.number,
                                                   tx.origin,
                                                   msg.sender, 
                                                   entropy)));
        return rnd;

    }
    
}