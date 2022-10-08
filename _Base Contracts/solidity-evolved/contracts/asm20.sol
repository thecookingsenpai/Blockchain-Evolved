// SPDX-License-Identifier: CC-BY-ND-4.0

pragma solidity ^0.8.15;

contract protected {
  mapping(address => bool) is_auth;

  function authorized(address addy) public view returns (bool) {
    return is_auth[addy];
  }

  function set_authorized(address addy, bool booly) public onlyAuth {
    is_auth[addy] = booly;
  }

  modifier onlyAuth() {
    require(is_auth[msg.sender] || msg.sender == owner, "not owner");
    _;
  }
  address owner;
  modifier onlyOwner() {
    require(msg.sender == owner, "not owner");
    _;
  }
  bool locked;
  modifier safe() {
    require(!locked, "reentrant");
    locked = true;
    _;
    locked = false;
  }

  function change_owner(address new_owner) public onlyAuth {
    owner = new_owner;
  }

  receive() external payable {}

  fallback() external payable {}
}

interface ERC20 {
  /// @param _owner The address from which the balance will be retrieved
  /// @return balance the balance
  function balanceOf(address _owner) external view returns (uint256 balance);

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return success Whether the transfer was successful or not
  function transfer(address _to, uint256 _value)
    external
    returns (bool success);

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return success Whether the transfer was successful or not
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) external returns (bool success);

  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of wei to be approved for transfer
  /// @return success Whether the approval was successful or not
  function approve(address _spender, uint256 _value)
    external
    returns (bool success);

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return remaining Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender)
    external
    view
    returns (uint256 remaining);

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );
}

// ANCHOR CONTRACT

contract ASM20 is protected, ERC20 {
  constructor() {
    owner = msg.sender;
    is_auth[owner] = true;
  }

  /// @param _owner The address from which the balance will be retrieved
  /// @return balance the balance
  function balanceOf(address _owner) public view returns (uint256 balance) {}

  /// @notice send `_value` token to `_to` from `msg.sender`
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return success Whether the transfer was successful or not
  function transfer(address _to, uint256 _value)
    public
    returns (bool success)
  {}

  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
  /// @param _from The address of the sender
  /// @param _to The address of the recipient
  /// @param _value The amount of token to be transferred
  /// @return success Whether the transfer was successful or not
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  ) public returns (bool success) {}

  /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @param _value The amount of wei to be approved for transfer
  /// @return success Whether the approval was successful or not
  function approve(address _spender, uint256 _value)
    public
    returns (bool success)
  {}

  /// @param _owner The address of the account owning tokens
  /// @param _spender The address of the account able to transfer the tokens
  /// @return remaining Amount of remaining tokens allowed to spent
  function allowance(address _owner, address _spender)
    public
    view
    returns (uint256 remaining)
  {}
}

contract ASM {
  function safeAdd(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      z := add(x, y)
    }
    Require(((z == x) || (z > x)), 0);
  }

  function safeSub(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      z := sub(x, y)
    }

    Require(((z == x) || (z < x)), 0);
  }

  function safeMul(uint256 x, uint256 y) public pure returns (uint256 z) {
    assembly {
      if gt(y, 0) {
        z := mul(x, y)
      }
    }
    Require((z / y) == x, 0);
  }

  function safeDiv(uint256 x, uint256 y) public pure returns (uint256 z) {
    Require((y > 0), 0);
    assembly {
      z := div(x, y)
    }
  }

  function Require(bool _arg, uint256 _message) public pure {
    assembly {
      if lt(_arg, 1) {
        mstore(0, _message)
        revert(0, 32)
      }
    }
  }
}
