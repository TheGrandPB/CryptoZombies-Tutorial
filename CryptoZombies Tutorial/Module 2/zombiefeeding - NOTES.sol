pragma solidity >=0.5.0 <0.6.0;

//importing from zombiefactory.sol contract
import "./zombiefactory.sol";

//creates an interface called "KittyInterface"
  //allows this contract to interact w/ CryptoKitties' contract that contains the getKitty function
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

//new contract called "ZombieFeeding" which is inheriting from "ZombieFactory" contract
    //since zombiefeeding.sol is now inheriting from zombiefactory.sol 
        //and zombiefactory.sol imports and inherits from ownable.sol
            //can use modifiers, functions, events etc... from ownable.sol
contract ZombieFeeding is ZombieFactory {
  

    //declaring KittyInterface called "kittyContract"
    KittyInterface kittyContract;

    //an external function called "setKittyContractAddress" w/ (1) argument w/ an onlyOwner modifier
      //only the owner of the contract can set the new contract address
    function setKittyContractAddress(address _address) external onlyOwner {
        //sets kittyContract equal to KittyInterface
        kittyContract = KittyInterface(_address);
  }

    function _triggerCooldown(Zombie storage _zombie) internal {
      _zombie.readyTime = uint32(now + cooldownTime);
    }




    //a public function called "feedAndMultiply" w/ (3) parameters
  function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) public {

      //verifies that the feeder of our zombies is the owner of the zombies
        // why is [_zombieId] required after zombieToOwner....(?)
      require(msg.sender == zombieToOwner[_zombieId]);
      
      //obtains zombie's DNA by declaring a local Zombie called "myZombie"
      //"myZombie" is a pointer to the "zombies" array in storage
      //var myZombie is set equal to index "_zombieId" w/in our "zombies" array
      Zombie storage myZombie = zombies[_zombieId];
      
      //ensures that the new "targetDna" isn't longer than than 16 digits
        //takes targetDna modulus dnaModulus
      _targetDna = _targetDna % dnaModulus;

      //declares a uint called "newDna" that is assigned to the average of myZombie's DNA (2nd parameter) and _targetDna
      uint newDna = (myZombie.dna + _targetDna) / 2;

      //Checks if the hash of _species is equivalent to the hash of "kitty"
      if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))) {

        //replace the last 2 digits of newDna and adds 99 to it
          //if newDna = 334455, then...
            //newDna % 100 = 55
              // so, newDna = 334455 - (55) 
                  // newDna = 334400 + 99 = 334499
        newDna = newDna - newDna % 100 + 99;
      }
      
      //calls the _createZombie function (refer back to zombiefactory.sol for original parameters) w/ (2) newly defined parameters
      _createZombie("NoName", newDna);
  }
  //declaring a public function called "feedOnKitty" with two uint arguments
  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    //declaring a uint called "kittyDna"
    uint kittyDna;
    //"call the kittyContract.getKitty function w/ _kittyId param and store genes in kittyDna"

      //the LHS defines which exact values we care about (just the "genes") which is in the 10th row
      // w/in the getKitty function (from CryptoKitties contract)
        //the preceeding (9) commas are placeholders for the preceeding (9) uints in the getKitty function
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      //the RHS defines which contract we are referencing ("kittyContract", which references the interface we've declared )
        // the interface called "kittyContract" points to the CryptoKitties contract
          //from CK contract, we are specifiying which function w/in their contract we want to use
            //we are using their "getKitty" function w/ its id parameter (uint256 _id ==> _kittyId)
  
      //call feedAndMultply function w/ its (3) params
        feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
