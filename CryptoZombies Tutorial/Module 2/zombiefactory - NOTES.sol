pragma solidity >=0.5.0 <0.6.0;

//importing from ownable.sol contract
import "./ownable.sol";

//creating a new contract called "Zombie Factory" that inherits from ownable.sol contract
contract ZombieFactory is Ownable {

    //declaring an event called "NewZombie" that passes (3) arguments: zombieId, name, dna
    event NewZombie(uint zombieId, string name, uint dna);

    //declared (3) uint vars assigned to a certain value
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    //creating a struct called "Zombie" w/ (4) types of data
        //note: the uint32s are clustered at the end of the struct for better storage/gas efficiency
    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyT+ime;
    }
    //creating a public dynamic array called "zombies"
    Zombie[] public zombies;

    //creating (2) mappings where:
        //(a) keeps track of the address that owns a zombie 
        //(b) keeps track of how many zombies an owner has
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

//creating an **internal**  function called "_createZombie" w/ two arguments 
    function _createZombie(string memory _name, uint _dna) internal {

        //puts the newly created Zombie along w/ its name, dna, level, readyTime 
            //into the "zombies" array
        //the first index in the array is 0, so -1 (?)
        //assigning this array.push()-1 to a uint called "id"
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime))) - 1;

          //updating the "zombieToOwner" mapping to store msg.sender under that "id"
        zombieToOwner[id] = msg.sender;
        //not sure what this return function does.. (?)
        return ownerZombieCount[msg.sender]++;
        //initiates the NewZombie event, passing id, _name, and _dna
        emit NewZombie(id, _name, _dna);
    }
//privately viewable function called "_generateRandomDna" that returns a uint
    function _generateRandomDna(string memory _str) private view returns (uint) {
        //packaging the _str inside a keccak256 hash function
        //assigning the packaged _str to a uint called "rand"
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        //returning "rand" modulus dnaModulus
        return rand % dnaModulus;
    }
//public function called "createRandomZombie" with a single string argument _name that is stored inside the memory
    function createRandomZombie(string memory _name) public {

        //require ownerZombieCount[msg.sender] to equal 0 or else throw an error
            //this prevents ppl from spamming the createRandomZombie function which would become too OP
        require(ownerZombieCount[msg.sender] == 0);

        //assigning the _generateRandomDna function to a uint called "randDna"
        uint randDna = _generateRandomDna(_name);
        //this calls the _createZombie function
        _createZombie(_name, randDna);
    }

}

//creates a new contract called "ZombieFeeding"
contract ZombieFeeding is ZombieFactory {


    }

