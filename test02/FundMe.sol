// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
// TODO
// 1. 创建一个收款函数
// 2. 记录投资人并查看
// 3. 在锁定期内，达到目标，生产商可以提款
// 4. 在锁定期内，没有达到目标，投资人可以在锁定期以后退款cccc

contract FundMe {
    mapping (address => uint256) public funds;
    uint256 constant MININUM_VALUE = 100 * 10 ** 18; // 100 usd 
    uint256 public constant TARGET  = 100 * 10 ** 18;
    address public owner;
    AggregatorV3Interface internal dataFeed;

    constructor() {
        owner = msg.sender;
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

  
    function fund() external payable {
        require(convertEthToUsd(msg.value) >= MININUM_VALUE, "send more money");
        funds[msg.sender] = msg.value;
    }
    
    address[] public funders; //记录投资人

    function transferOwnership(address newOwner) public  {
        require(msg.sender == owner, "this function can only be called by the owner");
        owner = newOwner;
    }
    
    function getFund() external {
        require(convertEthToUsd(address(this).balance) >= TARGET, "Target is not reached");
        require(msg.sender == owner, "this function can only be called by the owner");
        // transfer : transfer ETH and revert if tx failed
        // payable(msg.sender).transfer(address(this).balance);

        // send : send ETH and revert if tx failed
        bool res = payable(msg.sender).send(address(this).balance);
        require(res, "tx failed");
    }

    /**
     * 通过预言机查看eth的价格
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
    
    function convertEthToUsd(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount * ethPrice / (10 ** 8);
    }
}