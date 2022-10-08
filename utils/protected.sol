//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;


contract protected {

    mapping (address => bool) is_auth;

    function authorized(address addy) public view returns(bool) {
        return is_auth[addy];
    }

    function set_authorized(address addy, bool booly) public onlyAuth {
        is_auth[addy] = booly;
    }

    modifier onlyAuth() {
        require( is_auth[msg.sender] || msg.sender==owner, "not owner");
        _;
    }

    address owner;
    modifier onlyOwner() {
        require(msg.sender==owner, "not owner");
        _;
    }

    bool locked;
    modifier safe() {
        require(!locked, "reentrant");
        locked = true;
        _;
        locked = false;
    }

    receive() external payable {}
    fallback() external payable {}
}