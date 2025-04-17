// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { FundMe } from './FundMe.sol';

contract FundTokenERC20 is ERC20 {
    FundMe fundme;
    constructor(string memory name_, string memory symbol_, address fundmeAddr) ERC20(name_, symbol_) {
        fundme = FundMe(fundmeAddr);
    }

    function mint(uint256 amount) public  {
        require(fundme.isGetFund(), "the fundme is not complete yet");
        require(fundme.funds(msg.sender)>=amount, "You can't mint more than you have funds");
        _mint(msg.sender, amount);
        fundme.setFundsAmount(msg.sender,  fundme.funds(msg.sender) - amount);
    }

    // 将token兑换成指定的东西
    function claim(uint256 amountToClaim) public  {
        // complete cliam
        require(fundme.isGetFund(), "the fundme is not complete yet");
        require(balanceOf(msg.sender) > amountToClaim, "you dont have enough token to claim");
        // TODO
        // burn amountToClaim tokens
        _burn(msg.sender, amountToClaim);

    }
}