pragma solidity >=0.5.0;

interface IMevdexFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function router() external view returns (address);
    function MEVWETH() external view returns (address);
    function whitelist(address _user) external view returns (bool whitelisted);
    function blacklist(address _user) external view returns (bool blacklisted);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    function setWhitelist(address) external;
    function setBlacklist(address) external;
    function setRouter(address) external;
    function setMEVWETH(address) external;
}
