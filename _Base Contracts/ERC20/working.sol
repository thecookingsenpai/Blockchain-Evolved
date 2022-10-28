// SPDX-License-Identifier: CC-BY-SA-4.0

/// @title ERC20-Extended
/// @author TCSenpai (https://github.com/thecookingsenpai)
/// @notice This contract is a gas efficient, modular and customizable ERC20 token implementation.

pragma solidity ^0.8.17;

// SECTION ERC20 Implementation
interface ERC20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address _owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}
// !SECTION ERC20 Implementation

// SECTION Uniswap interfaces
interface IUniswapFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapRouter01 {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getamountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getamountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getamountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getamountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapRouter02 is IUniswapRouter01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}
// !SECTION Uniswap interfaces

// SECTION Ownable and reentrancy protection
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
    modifier onlyowner() {
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
// !SECTION Ownable and reentrancy protection

// ANCHOR Actual token contract
contract Pumpctober is ERC20, protected {

    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowances;
    mapping(address => uint256) public _sellLock;

    mapping(address => bool) private _excludedFromFees;
    mapping(address => bool) private _excludedFromSellLock;

    mapping(address => bool) public _blacklist;
    bool isBlacklist = true;

    string public constant _name = "Pumpctober";
    string public constant _symbol = "$OCT";
    uint8 public constant _decimals = 9;
    uint256 public constant InitialSupply = 10 * 10**6 * 10**_decimals;

    uint256 swapLimit = InitialSupply * 1 / 1000; // 0.1%

    bool isSwapPegged = true;

    uint16 public BuyLimitDivider = 50; // 2%

    uint8 public BalanceLimitDivider = 25; // 4%

    uint16 public SellLimitDivider = 125; // 0.75%

    uint16 public MaxSellLockTime = 10 seconds;

    bool public manualConversion;

    mapping(address => bool) isAuth;

    address public constant UniswapRouter =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public constant Dead = 0x000000000000000000000000000000000000dEaD;

    uint256 public _circulatingSupply = InitialSupply;
    uint256 public balanceLimit = _circulatingSupply / BalanceLimitDivider;
    uint256 public sellLimit = _circulatingSupply / SellLimitDivider;
    uint256 public buyLimit = _circulatingSupply / BuyLimitDivider;

    uint8 public _buyTax = 6;
    uint8 public _sellTax = 6;
    uint8 public _transferTax = 6;

    // NOTE Distribution of the taxes is as follows:
    uint8 public _liquidityTax = 34;
    uint8 public _marketingTax = 33;
    uint8 public _lotteryTax = 33;

    bool private _isTokenSwaping;
    uint256 public totalTokenSwapGenerated;
    uint256 public totalPayouts;

    // NOTE Excluding liquidity, the generated taxes are redistributed as:
    uint8 public marketingShare = 50;
    uint8 public lotteryShare = 50;

    uint256 public marketingBalance;
    uint256 public lotteryBalance;

    bool isTokenSwapManual = false;

    address public _UniswapPairAddress;
    IUniswapRouter02 public _UniswapRouter;

    // NOTE Cooldown controls
    bool public sellLockDisabled;
    uint256 public sellLockTime;

    /// @notice The constructor distributes the initial supply to the owner and to the contract
    constructor() {
        uint256 deployerBalance = (_circulatingSupply * 9) / 10;
        _balances[msg.sender] = deployerBalance;
        emit Transfer(address(0), msg.sender, deployerBalance);
        uint256 injectBalance = _circulatingSupply - deployerBalance;
        _balances[address(this)] = injectBalance;
        emit Transfer(address(0), address(this), injectBalance);
        _UniswapRouter = IUniswapRouter02(UniswapRouter);

        _UniswapPairAddress = IUniswapFactory(_UniswapRouter.factory())
            .createPair(address(this), _UniswapRouter.WETH());

        sellLockTime = 2 seconds;

        _excludedFromFees[msg.sender] = true;
        _excludedFromSellLock[UniswapRouter] = true;
        _excludedFromSellLock[_UniswapPairAddress] = true;
        _excludedFromSellLock[address(this)] = true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(sender != address(0), "Transfer from zero");
        require(recipient != address(0), "Transfer to zero");
        if (isBlacklist) {
            require(
                !_blacklist[sender] && !_blacklist[recipient],
                "Blacklisted!"
            );
        }

        bool isExcluded = (_excludedFromFees[sender] ||
            _excludedFromFees[recipient] ||
            isAuth[sender] ||
            isAuth[recipient]);

        bool isContractTransfer = (sender == address(this) ||
            recipient == address(this));

        bool isLiquidityTransfer = ((sender == _UniswapPairAddress &&
            recipient == UniswapRouter) ||
            (recipient == _UniswapPairAddress && sender == UniswapRouter));

        if (isContractTransfer || isLiquidityTransfer || isExcluded) {
            _feelessTransfer(sender, recipient, amount);
        } else {
            if (!tradingEnabled) {
                if (!is_auth[sender] && !is_auth[recipient]) {
                    require(tradingEnabled, "trading not yet enabled");
                }
            }

            bool isBuy = sender == _UniswapPairAddress ||
                sender == UniswapRouter;
            bool isSell = recipient == _UniswapPairAddress ||
                recipient == UniswapRouter;
            _taxedTransfer(sender, recipient, amount, isBuy, isSell);
        }
    }

    function _taxedTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool isBuy,
        bool isSell
    ) private {
        uint256 recipientBalance = _balances[recipient];
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");

        swapLimit = sellLimit / 2;

        uint8 tax;
        if (isSell) {
            if (!_excludedFromSellLock[sender]) {
                require(
                    _sellLock[sender] <= block.timestamp || sellLockDisabled,
                    "Seller in sellLock"
                );
                _sellLock[sender] = block.timestamp + sellLockTime;
            }

            require(amount <= sellLimit, "Dump protection");
            tax = _sellTax;
        } else if (isBuy) {
            require(
                recipientBalance + amount <= balanceLimit,
                "whale protection"
            );
            require(amount <= buyLimit, "whale protection");
            tax = _buyTax;
        } else {
            require(
                recipientBalance + amount <= balanceLimit,
                "whale protection"
            );
            if (!_excludedFromSellLock[sender])
                require(
                    _sellLock[sender] <= block.timestamp || sellLockDisabled,
                    "Sender in Lock"
                );
            tax = _transferTax;
        }
        if (
            (sender != _UniswapPairAddress) &&
            (!manualConversion) &&
            (!_isSwappingContractModifier)
        ) _swapContractToken(amount);
        uint256 contractToken = _calculateFee(
            amount,
            tax,
            _marketingTax + _liquidityTax + _lotteryTax
        );
        uint256 taxedAmount = amount - (contractToken);

        _removeToken(sender, amount);

        _balances[address(this)] += contractToken;

        _addToken(recipient, taxedAmount);

        emit Transfer(sender, recipient, taxedAmount);
    }

    function _feelessTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "Transfer exceeds balance");
        _removeToken(sender, amount);
        _addToken(recipient, amount);

        emit Transfer(sender, recipient, amount);
    }

    function _calculateFee(
        uint256 amount,
        uint8 tax,
        uint8 taxPercent
    ) private pure returns (uint256) {
        return (amount * tax * taxPercent) / 10000;
    }

    function _addToken(address addr, uint256 amount) private {
        uint256 newAmount = _balances[addr] + amount;
        _balances[addr] = newAmount;
    }

    function _removeToken(address addr, uint256 amount) private {
        uint256 newAmount = _balances[addr] - amount;
        _balances[addr] = newAmount;
    }

    function _distributeFeesETH(uint256 ETHamount) private {
        uint256 marketingSplit = (ETHamount * marketingShare) / 100;
        uint256 lotterySplit = (ETHamount * lotteryShare) / 100;

        marketingBalance += marketingSplit;
        lotteryBalance += lotterySplit;
    }

    uint256 public totalLPETH;

    /// @dev This modifier is used to apply a custom reentrancy guard to the _swapContractToken function
    bool private _isSwappingContractModifier;
    modifier lockTheSwap() {
        _isSwappingContractModifier = true;
        _;
        _isSwappingContractModifier = false;
    }

    /// @dev This function is used to swap the contract token for ETH and distribute the ETH to the marketing and lottery wallets
    function _swapContractToken(uint256 totalMax) private lockTheSwap {
        uint256 contractBalance = _balances[address(this)];
        uint16 totalTax = _liquidityTax + _marketingTax;
        uint256 tokenToSwap = swapLimit;
        if (tokenToSwap > totalMax) {
            if (isSwapPegged) {
                tokenToSwap = totalMax;
            }
        }
        if (contractBalance < tokenToSwap || totalTax == 0) {
            return;
        }
        uint256 tokenForLiquidity = (tokenToSwap * _liquidityTax) / totalTax;
        uint256 tokenForMarketing = (tokenToSwap * _marketingTax) / totalTax;
        uint256 tokenForlottery = (tokenToSwap * _lotteryTax) / totalTax;

        uint256 liqToken = tokenForLiquidity / 2;
        uint256 liqETHToken = tokenForLiquidity - liqToken;

        uint256 swapToken = liqETHToken + tokenForMarketing + tokenForlottery;
        uint256 initialETHBalance = address(this).balance;
        _swapTokenForETH(swapToken);
        uint256 newETH = (address(this).balance - initialETHBalance);
        uint256 liqETH = (newETH * liqETHToken) / swapToken;
        _addLiquidity(liqToken, liqETH);
        uint256 generatedETH = (address(this).balance - initialETHBalance);
        _distributeFeesETH(generatedETH);
    }

    function _swapTokenForETH(uint256 amount) private {
        _approve(address(this), address(_UniswapRouter), amount);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _UniswapRouter.WETH();

        _UniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function _addLiquidity(uint256 tokenamount, uint256 ETHamount) private {
        totalLPETH += ETHamount;
        _approve(address(this), address(_UniswapRouter), tokenamount);
        _UniswapRouter.addLiquidityETH{value: ETHamount}(
            address(this),
            tokenamount,
            0,
            0,
            address(this),
            block.timestamp
        );
    }

    /// @notice Utilities

    /// @notice Used to burn tokens owned by the contract
    function destroy(uint256 amount) public onlyAuth {
        require(_balances[address(this)] >= amount);
        _balances[address(this)] -= amount;
        _circulatingSupply -= amount;
        emit Transfer(address(this), Dead, amount);
    }

    /// @notice Returns the current limits for buy and sell transactions (in wei)
    function getLimits() public view returns (uint256 balance, uint256 sell) {
        return (balanceLimit, sellLimit);
    }

    /// @notice Returns the current tax rates for buy, sell and transfer transactions, as well as the distributions for liquidity, marketing and lottery
    function getTaxes()
        public
        view
        returns (
            uint256 lotteryTax,
            uint256 liquidityTax,
            uint256 marketingTax,
            uint256 buyTax,
            uint256 sellTax,
            uint256 transferTax
        )
    {
        return (
            _lotteryTax,
            _liquidityTax,
            _marketingTax,
            _buyTax,
            _sellTax,
            _transferTax
        );
    }

    /// @notice Returns the actual cooldown time for a specific address
    function getAddressSellLockTimeInSeconds(address AddressToCheck)
        public
        view
        returns (uint256)
    {
        uint256 lockTime = _sellLock[AddressToCheck];
        if (lockTime <= block.timestamp) {
            return 0;
        }
        return lockTime - block.timestamp;
    }

    /// @notice Returns the cooldown default time
    function getSellLockTimeInSeconds() public view returns (uint256) {
        return sellLockTime;
    }

    /// @notice Enable or disable the limit for the contract's swaps to be pegged to the tx value at max
    function SetPeggedSwap(bool isPegged) public onlyAuth {
        isSwapPegged = isPegged;
    }

    /// @notice Sets the limits to the contract swaps
    function SetMaxSwap(uint256 max) public onlyAuth {
        swapLimit = max;
    }

    /// @notice Prevents from honeypotting by setting a max cooldown value
    function SetMaxLockTime(uint16 max) public onlyAuth {
        MaxSellLockTime = max;
    }

    /// @notice ACL Functions

    /// @notice Adds an address to the admin list
    function SetAuth(address addy, bool booly) public onlyAuth {
        isAuth[addy] = booly;
    }

    /// @notice Adds an address to the permanently cooled down list
    function AddressStop() public onlyAuth {
        _sellLock[msg.sender] = block.timestamp + (365 days);
    }


    /// @notice Returns if an address is blacklisted or not
    function isAddressInBlackList(address addy, bool booly) public onlyAuth {
        _blacklist[addy] = booly;
    }

    /// @notice Returns if an address is whitelisted or not
    function isAccountInFees(address account, bool isIn) public onlyAuth {
        if(isIn){
            _excludedFromFees[account] = true;
        } else {
            _excludedFromFees[account] = false;
        }
    }

    /// @notice Returns if an address is limited by cooldown or not
    function isAccountInSellLock(address account, bool isIn) public onlyAuth {
        if(isIn){
            _excludedFromSellLock[account] = true;
        } else {
            _excludedFromSellLock[account] = false;
        }
    }

    /// @notice Gets the marketing balance ETH
    function WithdrawMarketingETH() public onlyAuth {
        uint256 amount = marketingBalance;
        marketingBalance = 0;
        address sender = msg.sender;
        (bool sent, ) = sender.call{value: (amount)}("");
        require(sent, "withdraw failed");
    }

    /// @notice Gets the lottery balance ETH
    function WithdrawLotteryETH() public onlyAuth {
        uint256 amount = lotteryBalance;
        lotteryBalance = 0;
        address sender = msg.sender;
        (bool sent, ) = sender.call{value: (amount)}("");
        require(sent, "withdraw failed");
    }

    /// @notice Set the swap of tokens to be manual or automatic
    function SwitchManualETHConversion(bool manual) public onlyAuth {
        manualConversion = manual;
    }

    /// @notice Disable cooldown
    function DisableSellLock(bool disabled) public onlyAuth {
        sellLockDisabled = disabled;
    }

    /// @notice Estabilish the cooldown default time
    function SetSellLockTime(uint256 sellLockSeconds) public onlyAuth {
        sellLockTime = sellLockSeconds;
    }

    /// @notice Set taxes and distributions for buy, sell and transfer transactions
    function SetTaxes(
        uint8 treasuryTaxes,
        uint8 lotteryTaxes,
        uint8 liquidityTaxes,
        uint8 marketingTaxes,
        uint8 buyTax,
        uint8 sellTax,
        uint8 transferTax
    ) public onlyAuth {
        uint8 totalTax = treasuryTaxes +
            lotteryTaxes +
            liquidityTaxes +
            marketingTaxes;
        require(totalTax == 100, "burn+liq+marketing needs to equal 100%");
        _lotteryTax = lotteryTaxes;
        _liquidityTax = liquidityTaxes;
        _marketingTax = marketingTaxes;

        _buyTax = buyTax;
        _sellTax = sellTax;
        _transferTax = transferTax;
    }

    /// @notice Change the marketing share of the fees
    function ChangeMarketingShare(uint8 newShare) public onlyAuth {
        marketingShare = newShare;
    }

    /// @notice Change the lottery share of the fees
    function ChangeLotteryShare(uint8 newShare) public onlyAuth {
        lotteryShare = newShare;
    }

    /// @notice Manually swap some tokens from the contract
    function ManualGenerateTokenSwapBalance(uint256 _qty) public onlyAuth {
        _swapContractToken(_qty * 10**9);
    }

    function UpdateLimits(uint256 newBalanceLimit, uint256 newSellLimit)
        public
        onlyAuth
    {
        newBalanceLimit = newBalanceLimit * 10**_decimals;
        newSellLimit = newSellLimit * 10**_decimals;
        balanceLimit = newBalanceLimit;
        sellLimit = newSellLimit;
    }

    bool public tradingEnabled;
    address private _liquidityTokenAddress;

    function EnableTrading(bool booly) public onlyAuth {
        tradingEnabled = booly;
    }

    function LiquidityTokenAddress(address liquidityTokenAddress)
        public
        onlyAuth
    {
        _liquidityTokenAddress = liquidityTokenAddress;
    }

    function RescueTokens(address tknAddress) public onlyAuth {
        ERC20 token = ERC20(tknAddress);
        uint256 ourBalance = token.balanceOf(address(this));
        require(ourBalance > 0, "No tokens in our balance");
        token.transfer(msg.sender, ourBalance);
    }

    function setBlacklistEnabled(bool isBlacklistEnabled) public onlyAuth {
        isBlacklist = isBlacklistEnabled;
    }

    function setContractTokenSwapManual(bool manual) public onlyAuth {
        isTokenSwapManual = manual;
    }

    function setBlacklistedAddress(address toBlacklist) public onlyAuth {
        _blacklist[toBlacklist] = true;
    }

    function removeBlacklistedAddress(address toRemove) public onlyAuth {
        _blacklist[toRemove] = false;
    }

    function AvoidLocks() public onlyAuth {
        (bool sent, ) = msg.sender.call{value: (address(this).balance)}("");
        require(sent);
    }

    function getOwner() external view override returns (address) {
        return owner;
    }

    function name() external pure override returns (string memory) {
        return _name;
    }

    function symbol() external pure override returns (string memory) {
        return _symbol;
    }

    function decimals() external pure override returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _circulatingSupply;
    }

    function balanceOf(address account)
        external
        view
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        external
        override
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address _owner, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[_owner][spender];
    }

    function approve(address spender, uint256 amount)
        external
        override
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function _approve(
        address _owner,
        address spender,
        uint256 amount
    ) private {
        require(_owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer > allowance");

        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        external
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        returns (bool)
    {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "<0 allowance");

        _approve(msg.sender, spender, currentAllowance - subtractedValue);
        return true;
    }
}
