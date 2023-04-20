pragma solidity =0.5.16;

import './interfaces/IMevdexFactory.sol';
import './MevdexPair.sol';

contract MevdexFactory is IMevdexFactory {
    address public feeTo;
    address public feeToSetter;
    address public router;
    address public MEVWETH;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public blacklist;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'Mevdex: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'Mevdex: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'Mevdex: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(MevdexPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IMevdexPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'Mevdex: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'Mevdex: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function setWhitelist(address _address, bool _whitelisted) external {
        require(msg.sender == feeToSetter, 'Mevdex: FORBIDDEN');
        whitelist[_address] = _whitelisted;
    }

    function setBlacklist(address _address, bool _blacklisted) external {
        require(msg.sender == feeToSetter, 'Mevdex: FORBIDDEN');
        blacklist[_address] = _blacklisted;
    }

    function setRouter(address _routerAddress) external {
        require(msg.sender == feeToSetter, 'Mevdex: FORBIDDEN');
        router = _routerAddress;
    }

    function setMEVWETH(address _MEVWETHPoolAddress) external {
        require(msg.sender == feeToSetter, 'Mevdex: FORBIDDEN');
        MEVWETH = _MEVWETHPoolAddress;
    }
}
