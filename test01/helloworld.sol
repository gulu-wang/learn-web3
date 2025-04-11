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
    function getLang(uint id) public view returns (string memory){
        return string.concat(langMapping[id].phrase, ", this's from kien");
    }
    
    function yunsuan() public pure  returns (uint) {
        return  1 + 1;
    }
}