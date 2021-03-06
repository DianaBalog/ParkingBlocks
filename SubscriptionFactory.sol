pragma solidity >=0.5.0 <0.6.0;

import "./SafeMath.sol";
import "./CarFactory.sol";

/**
 * @title Subscriptions management
 */ 
contract SubscriptionFactory is CarFactory {
    
    using SafeMath32 for uint32;
    
    Subscription[] public subscriptions;
    
    uint weeklyFee = 100 wei;
    uint monthlyFee = 350 wei;
    uint yearlyFee = 1000 wei;
    
    event NewSubscription(uint32 id, uint32 dateExp, uint32 idCar);
    
    struct Subscription {
        uint32 dateExp;
        uint32 idCar;
    }
    
    /**
     * @notice Checks if the car already has a subscription
     * @param _idCar Id of the car 
     */
    modifier noSubscription(uint32 _idCar) {
        int subscriptionId = cars[_idCar].subscriptionId;
        require(subscriptionId == -1 || subscriptions[uint32(subscriptionId)].dateExp < now);
        _;
    }
    
    /**
     * @notice Gets the expiration date of a subscription
     * @param _idSubscription Id of the subscription
     * @return The expiration date
     */
    function _getDateExp(uint32 _idSubscription) internal view returns(uint32) {
        return subscriptions[_idSubscription].dateExp;
    }
    
    /**
     * @notice Creates a one week subscription for a car
     * @param _idCar Id of the car
     */
    function createWeeklySubscription(uint32 _idCar) public payable isCarOwner(_idCar) noSubscription(_idCar) {
        require(msg.value >= weeklyFee);
        uint32 dateExp = uint32(now).add(1 minutes);
        uint32 id = uint32(subscriptions.push(Subscription(dateExp, _idCar))).sub(1);
        cars[_idCar].subscriptionId = int(id);
        emit NewSubscription(id, dateExp, _idCar);
    }
    
    /**
     * @notice Creates a one month subscription for a car
     * @param _idCar Id of the car
     */
    function createMonthlySubscription(uint32 _idCar) public payable isCarOwner(_idCar) noSubscription(_idCar) {
        require(msg.value >= monthlyFee);
        uint32 dateExp = uint32(now).add(4 weeks);
        uint32 id = uint32(subscriptions.push(Subscription(dateExp, _idCar))).sub (1);
        emit NewSubscription(id, dateExp, _idCar);
    }
    
    /**
     * @notice Creates a one year subscription for a car
     * @param _idCar Id of the car
     */
    function createYearlySubscription(uint32 _idCar) public payable isCarOwner(_idCar) noSubscription(_idCar) {
        require(msg.value >= yearlyFee);
        uint32 dateExp = uint32(now).add(48 weeks);
        uint32 id = uint32(subscriptions.push(Subscription(dateExp, _idCar))).sub(1);
        emit NewSubscription(id, dateExp, _idCar);
    }
}