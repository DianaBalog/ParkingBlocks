pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./SafeMath.sol";

contract CarFactory is Ownable {
    
    using SafeMath32 for uint32;
    
    event NewCar(uint carId, string number);
    
    struct Car{
        string number;
        uint32 entryDate;
        int enteredParkId;
    }
    
    Car[] public cars;

    mapping (uint => address) public carToOwner;
    
    modifier isCarOwner(uint _carId) {
        require(msg.sender == carToOwner[_carId]);
    _;
    }


    function createCar(string memory _number) public {
        uint32 id = uint32(cars.push(Car(_number, 0, int(-1)))).sub(1);
        carToOwner[id] = msg.sender;
        emit NewCar(id, _number);
    }
    
    function _setEntryDate(uint32 _id) internal {
        cars[_id].entryDate = uint32(now);
    }
    
    function _setEnteredParkId(uint32 _id, int _parkId) internal {
        cars[_id].enteredParkId = _parkId;
    }
    
    function _getEntryDate(uint32 _id) internal view returns(uint32) {
        return cars[_id].entryDate;
    }
    
    function _resetEntryDate(uint32 _id) internal returns(uint32) {
        cars[_id].entryDate = uint32(0);
    }
    
    function _resetEnteredParkId(uint32 _id) internal returns(uint32) {
        cars[_id].enteredParkId = int(-1);
    }
    
    function _timeInPark(uint32 _id) internal view returns(uint32){
        uint32 time = uint32(now).sub(cars[_id].entryDate);
        return time;
    }
    
    function _exitPark(uint32 _id) internal {
        _resetEntryDate(_id);
    }
}