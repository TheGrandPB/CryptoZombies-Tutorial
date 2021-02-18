pragma solidity >=0.5.0 <0.6.0;

//creating a new contract called "Zombie Factory"
contract ZombieFactory {

    //declaring an event called "NewZombie" that passes (3) arguments: zombieId, name, dna
    event NewZombie(uint zombieId, string name, uint dna);

    //declared two uint vars assigned to a certain value
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //creating a struct called "Zombie" w/ a string and a uint 
    struct Zombie {
        string name;
        uint dna;
    }
    //creating a public dynamic array called "zombies"
    Zombie[] public zombies;

    //creating (2) mappings where:
        //(a) keeps track of the address that owns a zombie 
        //(b) keeps track of how many zombies an owner has
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

//creating a private function called "_createZombie" w/ two arguments 
    function _createZombie(string memory _name, uint _dna) private {

        //puts the newly created Zombie into the "zombies" array along w/ its name & dna (?)
        //the first index in the array is 0, so -1 (?)
        //assigning this array.push()-1 
        uint id = zombies.push(Zombie(_name, _dna)) - 1;

          //updating the "zombieToOwner" mapping to store msg.sender under that "id"
        zombieToOwner[id] = msg.sender;
        //
        return ownerZombieCount[msg.sender]++;
        //initiates the NewZombie event, passing _name & _dna (?) along w/ id
        emit NewZombie(id, _name, _dna);
    }
//privately viewable function called "_generateRandomDna" that returns a uint
    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        //require ownerZombieCount[msg.sender] to equal 0 or else throw an error
        //this prevents ppl from spamming the createRandomZombie function
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

//creates a new contract called "ZombieFeeding"
contract ZombieFeeding is ZombieFactory {


}