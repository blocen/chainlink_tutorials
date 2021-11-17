// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

// ^0.6.0; any 0.6.x until 0.7.0

contract SimpleStorage {
    //uint256 favoriteNumber = 5; 
    uint256 public favoriteNumber = 5; 

    struct People {
        uint256 favoriteNumber;
        string name; 
    }
    
    People public moni = People({favoriteNumber:2, name: "moni"});
    People[] public people;
    mapping(string => uint256) public numbers;
    
    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }
    
    // memory:  only during function call
    // storage: persistant
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People({favoriteNumber: _favoriteNumber, name: _name}));
        numbers[_name] = _favoriteNumber;
    }    
    
    function numberOfPeople() public view returns(uint256) {
        return people.length;
    }
    
    // function numberOfNumbers() public view returns(uint256) {
    //     return numbers;
    // }
}




