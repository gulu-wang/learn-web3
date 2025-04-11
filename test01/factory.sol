// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { HelloWorld } from './helloworld.sol';
// 1. 直接引入文件系统下面的合约
// 2. 引入github上面的合约，直接引入url地址
// 3. 通过包引入
contract Factory { 
    HelloWorld[] hws; 
    function createHelloWorld() public { //创建实例
        HelloWorld hw = new HelloWorld();
        hws.push(hw);
    }
    // function getHelloWorldByIndex(uint256 _index) public view returns (HelloWorld) {
    //     return hws[_index];
    // }
    function callSayHello(uint256 _index, uint256 _id) public view returns (string memory) {
        return hws[_index].sayHello(_id);
    }
    function callSetLang(uint _index, string memory _phrase, uint256 _id ) public {
        hws[_index].setLang(_phrase, _id);
    }
}