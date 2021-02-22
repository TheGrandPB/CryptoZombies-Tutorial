pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

 //creates a modifier called "aboveLevel" w/ (2) uint arguments: _level & _zombieId
  modifier aboveLevel(uint _level, uint _zombieId) {
      
      //requires that w/in the zombies array (?), the user's zombieId is used to look up
        //the user's zombie's level 
        // and verifies that the zombie's level is greater than or equal to the required level
    require(zombies[_zombieId].level >= _level);

    //this calls the modifier function 
    _;
  }
    // an external *modified* function called "changeName" w/ (2) arguments
        //the function modifier "aboveLevel" w/ (2) parameters (level 2 & zombieId)
    function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) {
        //checks to make sure the name changer of the zombie is the owner of that zombie
        require(msg.sender == zombieToOwner[_zombieId]);
        //w/in the zombies array, look up the user's zombie (by id)
            //using the .name property, set the old name to the newName
        zombies[_zombieId].name = _newName;
    }
    //an external *modified* function called "changeDna" w/ (2) arguments
        //the function modifier "aboveLevel" w/ (2) parameters (level 20 & zombieId)
    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
         //checks to make sure the DNA changer of the zombie is the owner of that zombie
        require(msg.sender == zombieToOwner[_zombieId]);
        //w/in the zombies array, look up the user's zombie (by id)
            //using the .name property, set the old DNA to the newDna
        zombies[_zombieId].dna = _newDna;
    }
    //an externally viewable function called "getZombiesByOwner" w/ (1) argument
        //this function returns a dynamic uint array stored in memory
    function getZombiesByOwner(address _owner) external view returns (uint[] memory) {
        //LHS: declares a uint[] memory var called "result" set equal to...
            //RHS: a new uint[](# of zombies the _owner owns)
                //instead of an acutal # for the length, we can simply use the mapping
                    // from our zombiefactory.sol to look up how many zombies the _owner owns
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        //and output the result 
        return result;
    }
    
}
