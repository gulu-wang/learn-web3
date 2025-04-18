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
    uint256 public constant TARGET  = 1000 * 10 ** 18;
    address public owner;
    AggregatorV3Interface internal dataFeed;

    uint256 deployTime;
    uint lockTime;
    address erc20Addr;
    bool public isGetFund = false;

    constructor(uint256 _lockTime) {
        owner = msg.sender;
        dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        deployTime = block.timestamp;
        lockTime = _lockTime;
    }

  
    function fund() external payable {
        require(block.timestamp < deployTime + lockTime, "The fund is closed" );
        require(convertEthToUsd(msg.value) >= MININUM_VALUE, "send more money");
        funds[msg.sender] = msg.value;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
    
    function getFund() external onlyOwner {
        require(block.timestamp > deployTime + lockTime, "It's not extraction time yet" );
        require(convertEthToUsd(address(this).balance) >= TARGET, "Target is not reached");
        // transfer : transfer ETH and revert if tx failed
        // payable(msg.sender).transfer(address(this).balance);

        // send : send ETH and revert if tx failed
        // bool status = payable(msg.sender).send(address(this).balance);
        // require(status, "tx failed");

        // call : transfer ETH with data return value of function and bool
        bool status;
        (status, ) = payable(msg.sender).call{value: address(this).balance}('');
        require(status, "tx failed");
        funds[msg.sender] = 0;
        isGetFund = true;
    }

    function refund() external  {
        require(block.timestamp > deployTime + lockTime, "It's not extraction time yet" );
        require(convertEthToUsd(address(this).balance) < TARGET, "Target is reached");
        require(funds[msg.sender] != 0, "there is no fund to payback");
        bool status;
        (status, ) = payable(msg.sender).call{value: funds[msg.sender]}('');  
        funds[msg.sender] = 0;     
    }

    function setFundsAmount(address funder, uint256 amountToUpdate) external {
        require(msg.sender == erc20Addr, "you do not have permission to call this function");
        funds[funder] = amountToUpdate;
    }

    function setErc20Addr(address _erc20Addr) external onlyOwner {
        erc20Addr = _erc20Addr;
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

    modifier onlyOwner() {
        require(msg.sender == owner, "this function can only be called by the owner");
        _;
    }
}