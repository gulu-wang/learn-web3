// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract HelloWorld {
    string content = "Hello World";
    struct Lang  {
        string phrase;
        uint256 id;
        address addr;
    }
    Lang[] langs;
    mapping (uint id => Lang lang) langMapping;

    function sayHello(uint id) public view returns (string memory) {
        if(langMapping[id].addr == address(0x0)) {
            return"No lang" ;
        }else  {
            return getLang(id);
        }
    }
    function setLang(string memory _phrase, uint256 _id ) public {
       Lang memory lang = Lang(_phrase, _id , msg.sender);
       langMapping[_id] = lang;
    }
    function getLang(uint id) public view returns (string memory) {
        return string.concat(langMapping[id].phrase, ", this's from kien");
    }
    
    function yunsuan() public pure  returns (uint) {
        return  1 + 1;
    }
}
// 继承 ，使用is关键字进行继承
// 除了 private 声明的变量不能继承，其他关键字声明的都可以继承
// 如果被继承的合约有构造函数时，需要执行构造函数
contract HelloWorldTest is HelloWorld {
    // constructor() HelloWorld("") {}
}