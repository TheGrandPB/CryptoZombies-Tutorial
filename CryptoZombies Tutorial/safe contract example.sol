contract Safe {
 
 uint x = 100;
 
 function getXAndY() public view returns(uint, uint) {
   uint y = 101;
   return (x,y);
 }
}






contract FirstSurprise {
 
 struct Camper {
   bool isHappy;
 }
 
 mapping(uint => Camper) public campers;
 
 function setHappy(uint index) public {
   campers[index].isHappy = true;
 }
 function surpriseOne(uint index) public {
   Camper c = campers[index];
   c.isHappy = false;
 }
}