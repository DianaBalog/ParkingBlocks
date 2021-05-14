pragma solidity >=0.5.0 <0.6.0;

import "./SubscriptionFactory.sol";
import "./SafeMath.sol";

/// @title A contract for managing the proper parkings
contract ParkingBlocks is SubscriptionFactory{
    
	/// @notice We used SafeMath32 for preventing overflows and underflows
    using SafeMath32 for uint32;
    
    Park[] public parks;
    uint fee = 1 wei;
    
    event NewPark(uint32 id, uint32 totalParkingPlaces);
    
    struct Park{
        uint32 totalParkingPlaces;
        uint32 availableParkingPlaces;
    }
    
	 /**
     * @notice Creates a new parking with a specific number of places
     * @param _totalParkingPlaces the total number of places in the new parking
     */
    function createPark(uint32 _totalParkingPlaces) public onlyOwner {
        uint32 id = uint32(parks.push(Park(_totalParkingPlaces, _totalParkingPlaces))).sub(1);
        emit NewPark(id, _totalParkingPlaces);
    }
    
	 /**
     * @notice Proceeds the entering of a car in the parking
     * @param _parkId id of the parking
	 * @param _idCar id of the car that wants to enter
     */
    function entry(uint32 _parkId, uint32 _idCar) public {
        require(_getEntryDate(_idCar) == uint32(0));
        require(parks[_parkId].availableParkingPlaces > 0);
        parks[_parkId].availableParkingPlaces = parks[_parkId].availableParkingPlaces.sub(1);
        _setEntryDate(_idCar);
        _setEnteredParkId(_idCar, int(_parkId));
    }

	/**
     * @notice Proceeds the exiting of a car from the parking
     * @param _parkId id of the parking
	 * @param _idCar id of the car that wants to exit
     */
    function exit(uint32 _carId) public payable {
        uint32 etherValue = payValue(_carId);
        require(msg.value >= etherValue);
        parks[uint32(cars[_carId].enteredParkId)].availableParkingPlaces = parks[uint32(cars[_carId].enteredParkId)].availableParkingPlaces.add(1);
        _exitPark(_carId);
    }
    
	/**
     * @notice Proceeds the exiting of a car with a subscription from the parking
	 * @param _idCar id of the car that wants to exit
     */
    function exitWithSubscription(uint32 _carId) public {
        require(_getDateExp(uint32(cars[_carId].subscriptionId)) > uint(now));
        parks[uint32(cars[_carId].enteredParkId)].availableParkingPlaces = parks[uint32(cars[_carId].enteredParkId)].availableParkingPlaces.add(1);
        _exitPark(_carId);
    }
    
	/**
     * @notice Makes the payment for the time spent in the parking
     * @param _carId the id of the car that was parked
     */
    function payValue(uint32 _carId) public view returns(uint32) {
        uint32 time = _timeInPark(_carId).div(1 hours);
        uint32 etherValue = time.mul(uint32(fee));
        return etherValue;
    }
	
	/**
     * @notice Retrieves the number of available parking places
     * @param _parkId id of the parking
     */
    function numberFreeParkingPlaces(uint32 _parkId) public view returns(uint32) {
        return parks[_parkId].availableParkingPlaces;
    }
 }