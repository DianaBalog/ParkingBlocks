pragma solidity >=0.5.0 <0.6.0;

import "./CarFactory.sol";
import "./SubscriptionFactory.sol";
import "./SafeMath.sol";

contract ParkingBlocks is CarFactory, SubscriptionFactory{
    
    using SafeMath32 for uint32;
    
    Park[] public parks;
    uint fee = 1 wei;
    
    event NewPark(uint32 id, uint32 totalParkingPlaces);
    
    struct Park{
        uint32 totalParkingPlaces;
        uint32 availableParkingPlaces;
    }
    
    function createPark(uint32 _totalParkingPlaces) public {
        uint32 id = uint32(parks.push(Park(_totalParkingPlaces, _totalParkingPlaces))).sub(1);
        emit NewPark(id, _totalParkingPlaces);
    }
    
    function entry(uint32 _parkId, uint32 _idCar) public {
        require(_getEntryDate(_idCar) == uint32(0));
        require(parks[_parkId].availableParkingPlaces > 0);
        parks[_parkId].availableParkingPlaces = parks[_parkId].availableParkingPlaces.sub(1);
        _setEntryDate(_idCar);
    }

    function exit(uint32 _parkId, uint32 _carId) public payable {
        uint32 etherValue = payValue(_carId);
        require(msg.value >= etherValue);
        _exitPark(_carId);
        parks[_parkId].availableParkingPlaces = parks[_parkId].availableParkingPlaces.add(1);
    }
    
    function exitWithSubscription(uint32 _parkId, uint32 _carId, uint32 _idSubscription) public {
        require(_getDateExp(_idSubscription) > uint(now));
        _exitPark(_carId);
        parks[_parkId].availableParkingPlaces = parks[_parkId].availableParkingPlaces.add(1);
    }
    
    function payValue(uint32 _carId) public view returns(uint32) {
        uint32 time = _timeInPark(_carId).div(1 minutes);
        uint32 etherValue = time.mul(uint32(fee));
        return etherValue;
    }
    
    function numberFreeParkingPlaces(uint32 _parkId) public view returns(uint32) {
        return parks[_parkId].availableParkingPlaces;
    }
 }