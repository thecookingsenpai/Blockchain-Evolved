
//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

interface ERC20 {
    function totalSupply() external view returns (uint _totalSupply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

interface IUniswapFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapRouter01 {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapRouter02 is IUniswapRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}


interface IUniswapV2Pair {
  event Approval(address indexed owner, address indexed spender, uint value);
  event Transfer(address indexed from, address indexed to, uint value);

  function name() external pure returns (string memory);
  function symbol() external pure returns (string memory);
  function decimals() external pure returns (uint8);
  function totalSupply() external view returns (uint);
  function balanceOf(address owner) external view returns (uint);
  function allowance(address owner, address spender) external view returns (uint);

  function approve(address spender, uint value) external returns (bool);
  function transfer(address to, uint value) external returns (bool);
  function transferFrom(address from, address to, uint value) external returns (bool);

  function DOMAIN_SEPARATOR() external view returns (bytes32);
  function PERMIT_TYPEHASH() external pure returns (bytes32);
  function nonces(address owner) external view returns (uint);

  function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

  event Mint(address indexed sender, uint amount0, uint amount1);
  event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
  event Swap(
      address indexed sender,
      uint amount0In,
      uint amount1In,
      uint amount0Out,
      uint amount1Out,
      address indexed to
  );
  event Sync(uint112 reserve0, uint112 reserve1);

  function MINIMUM_LIQUIDITY() external pure returns (uint);
  function factory() external view returns (address);
  function token0() external view returns (address);
  function token1() external view returns (address);
  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
  function price0CumulativeLast() external view returns (uint);
  function price1CumulativeLast() external view returns (uint);
  function kLast() external view returns (uint);

  function mint(address to) external returns (uint liquidity);
  function burn(address to) external returns (uint amount0, uint amount1);
  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
  function skim(address to) external;
  function sync() external;
}

contract smart {
    address router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapRouter02 router = IUniswapRouter02(router_address);

    function create_weth_pair(address token) private returns (address, IUniswapV2Pair) {
       address pair_address = IUniswapFactory(router.factory()).createPair(token, router.WETH());
       return (pair_address, IUniswapV2Pair(pair_address));
    }

    function get_weth_reserve(address pair_address) private  view returns(uint, uint) {
        IUniswapV2Pair pair = IUniswapV2Pair(pair_address);
        uint112 token_reserve;
        uint112 native_reserve;
        uint32 last_timestamp;
        (token_reserve, native_reserve, last_timestamp) = pair.getReserves();
        return (token_reserve, native_reserve);
    }

    function get_weth_price_impact(address token, uint amount, bool sell) private view returns(uint) {
        address pair_address = IUniswapFactory(router.factory()).getPair(token, router.WETH());
        (uint res_token, uint res_weth) = get_weth_reserve(pair_address);
        uint impact;
        if(sell) {
            impact = (amount * 100) / res_token;
        } else {
            impact = (amount * 100) / res_weth;
        }
        return impact;
    }
}



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

contract ERC20_derived is ERC20, smart, protected {
    bytes32 public _name;
    bytes32 public _symbol;
    uint8 public constant _decimals = 18;
    uint256 public InitialSupply;
    uint256 public _circulatingSupply;
    address public constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public constant Dead = 0x000000000000000000000000000000000000dEaD;

    mapping (address => uint256) public _balances;
    mapping (address => mapping (address => uint256)) public _allowances;

    address pair_address;
    IUniswapV2Pair pair;

    constructor(bytes32 _name_, uint _quantity, uint8 perc_to_master, 
                      uint8 perc_to_contract, address daowner) {
        _name = _name_;
        _symbol = _name_;
        InitialSupply = _quantity;
        _circulatingSupply = InitialSupply;
        owner = daowner;

        uint keep_supply = (_quantity * perc_to_contract) / 100;
        uint master_supply = (_quantity * perc_to_master) / 100;
        _balances[daowner] = master_supply;
        _balances[address(this)] = keep_supply;
        emit Transfer(Dead, daowner, master_supply);
        emit Transfer(Dead, address(this), keep_supply);

        is_auth[owner] = true;
        pair_address = IUniswapFactory(router.factory()).createPair(address(this), router.WETH());
        pair = IUniswapV2Pair(pair_address);
    }

    function _transfer(address sender, address recipient, uint amount) public {

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function name() external view returns (bytes32) {
        return _name;
    }

    function symbol() external view returns (bytes32) {
        return _symbol;
    }

    function decimals() external pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() view public override returns (uint256) {
        return _circulatingSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender) external view override returns (uint256) {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function _approve(address _owner, address spender, uint256 amount) private {
        require(_owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer > allowance");

        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    

    function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "<0 allowance");

        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }
}

///@dev This library defines a standard for DAO variables and control mechanism
contract dao_controls {
    
    mapping(address => uint) shareholders;
    address public token; // Main DAO token representing shares
    address[] public subtokens; // Other tokens
    mapping(address => string) public subtoken_definition; // Description of the subtoken 
    uint public shares; // Shares of the DAO

    address multisig; // Main wallet of the DAO

    struct PROPOSAL {
        address proposer;
        uint[2] votes; // 0 is no, 1 is yes
        uint proposal_time;
        uint proposal_end; 
        bool status; // Is it open to votes?
        bool exists;
        bool approved; // False & Status active = undefined
        string proposal_url; // IPFS or Arweave or other decentralized drive link
        mapping(address => bool) voted; // Voter counter
    }

    mapping(bytes32 => PROPOSAL) public proposals;

    event Incorporate(bytes32 name, bytes32 classification, address master_dao, address owner);
    event Proposed(address proposer, bytes32 proposal);
    event Voted(address voter, bytes32 proposal, bool is_new, bool agreed);
    event Closed(bytes32 proposal, address final_voter, address proposer, uint yes, uint no, bool approved);
    event Changed_Shares(bytes32 proposal, address target, address proposer, uint old_shares, uint new_shares);

}

contract DAO is protected, smart, dao_controls {

    /************************* Basics *************************/

    bytes32 constant public classification = "DAO"; // cDAO: corporative DAO, fDAO: federative DAO, DAO: simple dao 
    address master_dao; // If is a subdao
    uint free_shares=100; //No shares are assigned

    /************************* Formation Data *************************/

    bytes32 public name;
    constructor(bytes32 _name) {
        name = _name;
        owner = msg.sender;
        is_auth[owner] = true;
    }
    

    /************************* Formation *************************/


    ///@dev Incorporate the DAO with the initial arguments
    function incorporate(
        address _token,
        uint _shares,
        address[] memory _shareholders,
        uint[] memory _shareholders_division,
        uint master_shares
    ) public onlyAuth {
        // Set token and shares number
        token = _token;
        shares = _shares;
        // Assign the shares to the master
        shareholders[owner] = master_shares;
        free_shares -= master_shares;
        // If specified, distribute the shares
        if(!(_shareholders.length==0)) {
            require(_shareholders.length == _shareholders_division.length);
            uint total_shares;
            for(uint i; i < _shareholders_division.length; i+=1) {
                shareholders[_shareholders[i]] == _shareholders_division[i];
                total_shares += _shareholders_division[i];
            }
            require(total_shares <= free_shares, "Can't allocate >100%");
            free_shares -= total_shares;
        }
        emit Incorporate(name, classification, master_dao, owner);
    }

    /************************* Actions on shares *************************/

    /*****************/
    ///@dev DAO shares take or give proposal
    /****************/
    function modify_shares(address targer_shareholder, uint shares_to_edit, bool agree, bool direction, bytes32 user_prop_id) public 
                            returns(bool executed, bytes32 _msg, bytes32 prop_id) {
        
        // Calculate if it is possible to add or revoke the shares
        if(!direction) {
            require(shares_to_edit <= shareholders[targer_shareholder], "Not enough shares");
        } else {
            require(shares_to_edit <= free_shares, "Not enough shares");
        }

        /**** Set a new or take a real prop id ****/
        bytes32 _prop_id;
        if(user_prop_id=="") {
            // Derive an hashed proposal id that is unique and constant
            _prop_id = keccak256(abi.encodePacked(targer_shareholder, shares_to_edit, direction,
                                                      shareholders[targer_shareholder], block.timestamp));
        } else {
            _prop_id = user_prop_id;
        }
        /**** Check the status of the proposal ****/
        (bool proposal_exists, bool proposal_active, bool proposal_ended, bool approved) = check_proposal(_prop_id);
        if(!proposal_exists) {
            // If not exists
            // If wasnt called by user, create a proposal
            if(user_prop_id=="") {
                proposals[_prop_id].proposer = msg.sender;
                proposals[_prop_id].status = true;
                proposals[_prop_id].proposal_time = block.timestamp;
                proposals[_prop_id].proposal_end = block.timestamp + 1 days;
                emit Proposed(msg.sender, _prop_id);
                return(false, "Created", _prop_id);
            }
            // Else return false
            else {
                require(proposal_exists, "Does not exist");
            }
        } else {
            // If exists but is not active, reject the action
            require(proposal_active, "Proposal is not active");
        }
        
        /**** If ended, count the votes ****/
        if(proposal_ended) {            
            emit Closed(_prop_id, msg.sender, proposals[_prop_id].proposer, proposals[_prop_id].votes[1], 
                        proposals[_prop_id].votes[0], approved);
            if(approved) {
                // Execute the addition or subtraction
                uint old_shares = shareholders[targer_shareholder];
                if(!direction) {
                    shareholders[targer_shareholder] -= shares_to_edit;
                    free_shares += shares_to_edit;
                } else {
                    shareholders[targer_shareholder] += shares_to_edit;
                    free_shares -= shares_to_edit;
                }
                emit Changed_Shares(_prop_id, targer_shareholder, proposals[_prop_id].proposer, old_shares, 
                                    shareholders[targer_shareholder]);
                return(true, "Approved", prop_id);    
            } else {
                return (false, "Not approved", prop_id);
            }
        } else {
            require(!proposals[_prop_id].voted[msg.sender], "Already voted");
            // Else vote on the proposal
            if(agree) {
                proposals[_prop_id].votes[1] += shareholders[msg.sender];
            } else {
                proposals[_prop_id].votes[0] += shareholders[msg.sender];
            }
            emit Voted(msg.sender, _prop_id, false, agree);
            proposals[_prop_id].voted[msg.sender] = true;
        }
    }


    /************************* Generic proposals *************************/

    function propose(string calldata url) public returns(bytes32 prop_id) {
        // Derive an hashed proposal id that is unique and constant
        bytes32 _prop_id = keccak256(abi.encodePacked(msg.sender, url, block.timestamp));
        /**** create a proposal ****/
        proposals[_prop_id].proposer = msg.sender;
        proposals[_prop_id].status = true;
        proposals[_prop_id].proposal_time = block.timestamp;
        proposals[_prop_id].exists = true;
        proposals[_prop_id].proposal_end = block.timestamp + 1 days;
        emit Proposed(msg.sender, _prop_id);
        return(_prop_id);
    }

    function vote_on_propose(bytes32 _prop_id) public safe {
        require(proposals[_prop_id].exists, "Does not even exist...");
    }

    /************************* Actions on tokens *************************/

    /****************/
    ///@dev Create and emit a token linked to the DAO
    /****************/
    function tokenize(bytes32 _name_, uint _quantity_, uint8 perc_to_master, 
                      uint8 perc_to_contract) public onlyAuth {
            ERC20 token_erc = new ERC20_derived(_name_, _quantity_, perc_to_master, perc_to_contract, owner);
            token = address(token_erc);
    } 

    /************************* Proposal management *************************/
    
    /****************/
    ///@dev Check the status and existance of a proposal
    /****************/
    function check_proposal(bytes32 _prop_id) public view returns(bool existant, bool active, bool ended, bool approved) {
        bool _approved;
        // Checking if there is a proposal on that or is a new one
        if(proposals[_prop_id].status && (block.timestamp >= proposals[_prop_id].proposal_end)) { 
            // Proposal exists and ended
            _approved = check_votes(_prop_id);
            return(true, true, true, approved);
        } else if(proposals[_prop_id].status && (block.timestamp < proposals[_prop_id].proposal_end)) { 
            // Proposal not ended
            return(true, true, false, false);
        } else if(!proposals[_prop_id].status && (block.timestamp >= proposals[_prop_id].proposal_end)) { 
            // Proposal expired
            _approved = check_votes(_prop_id);
            return(true, false, false, approved);
        } else if(!proposals[_prop_id].status && (proposals[_prop_id].proposal_end==0)) { 
            // Proposal never existed
            return(false, false, false, false);
        }
    }
    
    /****************/
    ///@dev Internal vote counter
    /****************/
    function check_votes(bytes32 _prop_id) private view returns (bool approved) {
        if(proposals[_prop_id].votes[1] > proposals[_prop_id].votes[0]) {
            return true;
        } else {
            return false;
        }
    }

}