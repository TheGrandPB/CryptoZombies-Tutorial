pragma solidity >=0.5.0 <0.6.0;
//importing from zombiefactory.sol contract
import "./zombiefactory.sol";
//new contract called "ZombieFeeding" which is inheriting from "ZombieFactory"
contract ZombieFeeding is ZombieFactory {

    //a public function called "feedAndMultiply" w/ (2) uint parameters
  function feedAndMultiply(uint _zombieId, uint _targetDna) public {

      //verifies that the feeder of our zombies is the owner of the zombies
        // why is [_zombieId] required after zombieToOwner....(?)
      require(msg.sender == zombieToOwner[_zombieId]);
      
      //obtains zombie's DNA by declaring a local Zombie called "myZombie"
      //"myZombie" is a pointer to the "zombies" array in storage
      //var myZombie is set equal to index "_zombieId" w/in our "zombies" array
      Zombie storage myZombie = zombies[_zombieId];
  }

}
