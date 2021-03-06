pragma solidity ^0.4.15;

import './SolarToken.sol';

/**
 * @title SolarParkFunding
 * @dev Very basic contract for getting tokens for funding. Many features are kept out because this is not our focus. Just the way of gaining the tokens.
*/
contract SolarParkFunding {
  uint public value;

  mapping (address => uint256) public balanceOf;

  address public tokenAddress;
  // Goal is also the max
  uint public goal;
  uint public min;

  uint public participantsCount;

  event FundAdded(address backer, uint amount);

  function SolarParkFunding(address tokenAddr, uint goalInWei, uint minWei) public {
    tokenAddress = tokenAddr;
    goal = goalInWei;
    min = minWei;
  }

  function () payable public {
    require(msg.value >= min);
    require(value + msg.value <= goal);
    require(amount % min == 0);

    uint amount = msg.value;
    balanceOf[msg.sender] += amount;
    value += amount;

    SolarToken token = SolarToken(tokenAddress);
    token.award(msg.sender, amount / min);

    FundAdded(msg.sender, amount);
  }

  function contribute() payable public {
    require(msg.value >= min);
    require(value + msg.value <= goal);
    require(amount % min == 0);

    if (balanceOf[msg.sender] == 0) {
      participantsCount++;
    }

    uint amount = msg.value;
    balanceOf[msg.sender] += amount;
    value += amount;

    SolarToken token = SolarToken(tokenAddress);
    token.award(msg.sender, amount / min);

    FundAdded(msg.sender, amount);
  }
}