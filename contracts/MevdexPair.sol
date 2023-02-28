pragma solidity =0.5.16;

import './libraries/SafeMath.sol';
import './libraries/UQ112x112.sol';

contract MevdexETHUSDC {
    using SafeMath  for uint;
    using UQ112x112 for uint224;

    address private priceFeed1;
    address private priceFeed2;
    address private priceFeed3;
    address private owner;

    uint public constant WETH_DECIMALS = 18;
    uint public constant USDC_DECIMALS = 6;

    address public token0;
    address public token1;

    // in / out calculated by these quantities
    uint112 public swapReserve0;
    uint112 public swapReserve1;
    uint112 public priceLast;

    // actual values
    uint112 public reserve0;
    uint112 public reserve1;

    uint public k;

    uint private unlocked = 1;
    modifier lock() {
        require(unlocked == 1, 'Mevdex: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'Mevdex: NOT OWNER');
        _;
    }

    modifier feeder() {
        require(msg.sender == priceFeed1 || msg.sender == priceFeed2 || msg.sender == priceFeed3);
        _;
    }

    // function _safeTransfer(address token, address to, uint value) private {
    //     (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
    //     require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
    // }

    constructor() public {
        k = 150000;
    }

    function setFeeder(uint id, address _address) external onlyOwner {
        if (id == 1) priceFeed1 = _address;
        if (id == 2) priceFeed2 = _address;
        if (id == 3) priceFeed3 = _address;
    }
}