// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// SafeMath no longer needed starting v0.8!!
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
    
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    function fund() public payable {
        // minimum $50
        uint256 minimumUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH.");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256) {
        // rinkeby address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }
    
    function getDescr() public view returns (string memory) {
        // rinkeby address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.description();
    }
    
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);        
        //( uint80 roundId,
        //  int256 answer,
        //  uint256 startedAt,
        //  uint256 updatedAt,
        //  uint80 answeredInRound
        ( ,int256 answer,,,) = priceFeed.latestRoundData();
        // type casting
        return uint256(answer * 10 ** 10);
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 10 ** 18;
        return ethAmountInUSD;
    }
    
    modifier onlyOwner {
        // only contract owner!
        require(msg.sender == owner, "Only owner allowed!");
        _;
    }
    
    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
        // for loop
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}



