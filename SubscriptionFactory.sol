pragma solidity >=0.5.0 <0.6.0;

import "./SafeMath.sol";
import "./CarFactory.sol";

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
    
    function _getDateExp(uint32 _idSubscription) internal view returns(uint32) {
        return subscriptions[_idSubscription].dateExp;
    }
    
    function createWeeklySubscription(uint32 _idCar) public payable isCarOwner(_idCar) {
        require(msg.value >= weeklyFee);
        uint32 dateExp = uint32(now).add(1 weeks);
        uint32 id = uint32(subscriptions.push(Subscription(dateExp, _idCar))).sub(1);
        emit NewSubscription(id, dateExp, _idCar);
    }
    
    function createMonthlySubscription(uint32 _idCar) public payable isCarOwner(_idCar) {
        require(msg.value >= monthlyFee);
        uint32 dateExp = uint32(now).add(4 weeks);
        uint32 id = uint32(subscriptions.push(Subscription(dateExp, _idCar))).sub (1);
        emit NewSubscription(id, dateExp, _idCar);
    }
    
    function createYearlySubscription(uint32 _idCar) public payable isCarOwner(_idCar) {
        require(msg.value >= yearlyFee);
        uint32 dateExp = uint32(now).add(48 weeks);
        uint32 id = uint32(subscriptions.push(Subscription(dateExp, _idCar))).sub(1);
        emit NewSubscription(id, dateExp, _idCar);
    }
}