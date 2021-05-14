pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./SafeMath.sol";

/// @title A contract for managing cars
/// @notice This contract inherits from Ownable and it will be used by the other contracts which inherit from CarFactory
contract CarFactory is Ownable {
    
    /// @notice We used SafeMath32 for preventing overflows and underflows
    using SafeMath32 for uint32;
    
    event NewCar(uint carId, string number);
    
    struct Car{
        string number;
        uint32 entryDate;
        int subscriptionId;
        int enteredParkId;
    }
    
    Car[] public cars;
    
    /// @notice A mapping for saving the Owner of the car
    mapping (uint => address) public carToOwner;
    
    /// @notice Checks if the one who called the function is the owner of the car
    modifier isCarOwner(uint _carId) {
        require(msg.sender == carToOwner[_carId]);
    _;
    }

    /// @notice Creates a new car with the given number and adds it to the cars array
    /// @param _number the number of the car which we want to register
    /// @dev When creating a car the entryDate, subscriptionId, enteredParkId are automatically set to values which don't present a valid value
    /// @dev SafeMath32 is used for math operations
    function createCar(string memory _number) public {
        uint32 id = uint32(cars.push(Car(_number, 0, int(-1), int(-1)))).sub(1);
        carToOwner[id] = msg.sender;
        emit NewCar(id, _number);
    }
    
    /// @notice Sets the entryDate of the car with the given id to now (this will be used when entering a park)
    /// @param _id the id of the car 
    /// @dev The _id is the index of the car from the array of cars
    function _setEntryDate(uint32 _id) internal {
        cars[_id].entryDate = uint32(now);
    }
    
    /// @notice Sets the enteredParkId of the car with the given id to the given parkId (this will be used when entering a park)
    /// @param _id the id of the car
    /// @param _parkId the id of the parkId
    /// @dev The _id is the index of the car from the array of cars and the _parkId is the index of the park from the array of parks
    function _setEnteredParkId(uint32 _id, int _parkId) internal {
        cars[_id].enteredParkId = _parkId;
    }
    
    /// @notice Returns the entryDate of the car with the given id (this will be used when calculating the sum to pay)
    /// @param _id the id of the cars
    /// @return the entryDate of the car with the given id
    function _getEntryDate(uint32 _id) internal view returns(uint32) {
        return cars[_id].entryDate;
    }
    
    /// @notice Sets the entryDate of the car with the given id back to 0 (This will mean that the car is not parked in a park)
    /// @param _id the id of the cars
    function _resetEntryDate(uint32 _id) internal returns(uint32) {
        cars[_id].entryDate = uint32(0);
    }
    
    /// @notice Sets the enteredParkId of the car with the given id back to -1 (This will mean that the car is not parked in a park)
    /// @param _id the id of the cars
    function _resetEnteredParkId(uint32 _id) internal returns(uint32) {
        cars[_id].enteredParkId = int(-1);
    }
    
    /// @notice Calculates the time, the car with the given id spended in the park
    /// @param _id the id of the cars
    /// @return the time spended in the Park
    /// @dev SafeMath32 is used for math operations
    function _timeInPark(uint32 _id) internal view returns(uint32){
        uint32 time = uint32(now).sub(cars[_id].entryDate);
        return time;
    }
    
    /// @notice Calls the to reset functions with the given carId, needed when exiting a park
    /// @param _id the id of the cars
    function _exitPark(uint32 _id) internal {
        _resetEntryDate(_id);
        _resetEnteredParkId(_id);
    }
}