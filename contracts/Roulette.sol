// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

import "hardhat/console.sol";

/* Errors */
error Roulette__PleaseSendMoreMoney();
error Roulette__ZeroAddress();
error Roulette__NotEnoughMoneyToStart();
error Roulette__UpkeepNotNeeded(uint256 currentBalance, uint256 numberOfBets);
error Roulette__TransactionFailed();
error Roulette__IsContract();
error Roulette__NotAnOwner();
error Roulette__CasinoIsEmpty();

/**@title Roulette contract
 * @author Vyacheslav Pyzhov
 * @dev This implements the Chainlink VRF Version 2
 */

contract Roulette is VRFV2WrapperConsumerBase, ReentrancyGuard {

	constructor(address _linkAddress, address _wrapperAddress) VRFV2WrapperConsumerBase(_linkAddress, _wrapperAddress)
		{
		owner = msg.sender;		
	}
	/* Type declarations */
	struct Bet {
		address player;
		uint256 amount;
		uint8 betType; // 0: oneNumber, 1: twoNumbers, 2: threeNumbers, 3: fourNumbers, 4: sixNumbers, 5: column,       6: dozen 7: eighteen, 8: modulus, 9: color:
		uint8 number;
	}

	/* State variables */
	//Owner
	address public immutable owner;
	// Chainlink VRF Variables
	uint32 public constant callbackGasLimit = 100000;
	uint16 public constant requestConfirmations = 3;
	uint32 public constant numWords = 1;

	// Roulette State Variables
	uint256 public constant startGameValue = 10000000000000000; // 0.01 ETH
	uint256 public constant minimalBet = 1000000000; // 1 gwei
	uint256 public moneyInTheBank;
	uint256 public currentCasinoBalance;
	uint256 public lastWinningNumber;
	mapping(address => uint256) public playersBalances;
	
	// Array of Bets
	Bet[] public betsArr;

	/* Events */
	event BetCreated(Bet indexed bet, uint256 indexed time);
	event GameStarted(uint256 indexed time);
	event GameFinished(uint256 winningNumber, uint256 indexed time);

    /* Modifiers */
	modifier onlyOwner() {
        if (msg.sender != owner) {
			revert Roulette__NotAnOwner();
		}
        _;
    }

	/* Functions */

	function createBet(uint8 _betType, uint8 _number) public payable {
		if (msg.value < minimalBet) {
			revert Roulette__PleaseSendMoreMoney();
		}
		if (msg.sender == address(0)) {
			revert Roulette__ZeroAddress();
		}

		Bet memory newBet = Bet({
			player: msg.sender,
			amount: msg.value,
			betType: _betType,
			number: _number
		});

		betsArr.push(newBet);

		moneyInTheBank += msg.value;

		emit BetCreated(newBet, block.timestamp);
	}
	

	function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        bool hasPlayers = betsArr > 0;
        bool hasStartGameValue = moneyInTheBank > startGameValue;

        upkeepNeeded = (hasPlayers && hasStartGameValue);
        return (upkeepNeeded, "0x0"); 
    }

	function performUpkeep( bytes calldata /* performData */) external override {
		(bool upkeepNeeded, ) = checkUpkeep("");
		
		if (!upkeepNeeded) {
            revert Roulette__UpkeepNotNeeded(moneyInTheBank, betsArr.length);
        }

		requestRandomness(callbackGasLimit, requestConfirmations, numWords);
		
		emit GameStarted(block.timestamp);
	}

	function fulfillRandomWords(uint256 /* requestId */, uint256[] memory randomWords) internal override {
		
        uint256 _rouletteWinNum = (randomWords[0] % (37));
		lastWinningNumber = _rouletteWinNum;
        for (uint256 i; i < betsArr.length; i++) {
			
			if (checkWinBet(betsArr[i], _rouletteWinNum)) {
				
				playersBalances[betsArr[i].player] += calcWin(betsArr[i].betType, betsArr[i].amount);
			} else {
				currentCasinoBalance += betsArr[i].amount;
			}
		}

		moneyInTheBank = 0;

		emit GameFinished(_rouletteWinNum, block.timestamp);
    }

	function withdrawPlayer() external nonReentrant {
		if (msg.sender == address(0)) {
			revert Roulette__ZeroAddress();
		}
		if (msg.sender.code.length > 0) {
			revert Roulette__isContract();
		}
		
		(bool success, ) = msg.sender.call{value: playersBalances[address(msg.sender)]}("");

		if (!success) {
			revert Roulette__TransactionFailed();
		}
	}

	function withdrawOwner() external onlyOwner nonReentrant {
		if (currentCasinoBalance < 1) {
			revert Roulette__CasinoIsEmpty();
		}

		(bool success, ) = owner.call{value: currentCasinoBalance}("");

		if (!success) {
				revert Roulette__TransactionFailed();
		}

		currentCasinoBalance = 0;
	}

function calcWin(uint8 _betType, uint256 _amount) internal pure returns(uint256) {
		if (_betType == 0) {
			return _amount*35;
		}
		if (_betType == 1) {
			return _amount*17;
		}
		if (_betType == 2) {
			return _amount*11;
		}
		if (_betType == 3) {
			return _amount*8;
		}
		if (_betType == 4) {
			return _amount*5;
		}
		if (_betType == 5) {
			return _amount*2;
		}
		if (_betType == 6) {
			return _amount*2;
		}
		if (_betType == 7) {
			return _amount;
		}
		if (_betType == 8) {
			return _amount;
		}
		if (_betType == 9) {
			return _amount;
		}
	}

	function checkWinBet(Bet _bet, uint256 __rouletteWinNum) internal view returns(bool won) {
		bool won;
		
if (_rouletteWinNum == 0) {
	won =
		(_bet.bettype == 0 && _bet.number == 0) ||
		(_bet.bettype == 3 && _bet.number == 22) ||
		(_bet.bettype == 2 && (_bet.number == 12 || _bet.number == 13)) ||
		(_bet.bettype == 1 && (_bet.number == 57 || _bet.number == 58 || _bet.number == 59))
}
if (_rouletteWinNum == 1) {
	won =
		(_bet.bettype == 0 && _bet.number == 1) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 0) ||
		(_bet.bettype == 3 && _bet.number == 0) ||
		(_bet.bettype == 3 && _bet.number == 22) ||
		(_bet.bettype == 2 && _bet.number == 0) ||
		(_bet.bettype == 1 && (_bet.number == 0 || _bet.number == 24))
}
if (_rouletteWinNum == 2) {
	won =
		(_bet.bettype == 0 && _bet.number == 2) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 0) ||
		(_bet.bettype == 3 && (_bet.number == 0 || _bet.number == 1)) ||
		(_bet.bettype == 3 && _bet.number == 22) ||
		(_bet.bettype == 2 && _bet.number == 0) ||
		(_bet.bettype == 1 && (_bet.number == 0 || _bet.number == 1 || _bet.number == 25))
}
if (_rouletteWinNum == 3) {
	won =
		(_bet.bettype == 0 && _bet.number == 3) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 0) ||
		(_bet.bettype == 3 && _bet.number == 1) ||
		(_bet.bettype == 3 && _bet.number == 22) ||
		(_bet.bettype == 2 && _bet.number == 0) ||
		(_bet.bettype == 1 && (_bet.number == 1 || _bet.number == 26))
}
if (_rouletteWinNum == 4) {
	won =
		(_bet.bettype == 0 && _bet.number == 4) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 0) ||
		(_bet.bettype == 3 && _bet.number == 2) ||
		(_bet.bettype == 2 && _bet.number == 1) ||
		(_bet.bettype == 1 && (_bet.number == 2 || _bet.number == 24 || _bet.number == 27))
}
if (_rouletteWinNum == 5) {
	won =
		(_bet.bettype == 0 && _bet.number == 5) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 0) ||
		(_bet.bettype == 3 && (_bet.number == 2 || _bet.umber == 3)) ||
		(_bet.bettype == 2 && _bet.number == 1) ||
		(_bet.bettype == 1 && (_bet.number == 2 || _bet.number == 3 || _bet.number == 25 || _bet.number == 28))
}
if (_rouletteWinNum == 6) {
	won =
		(_bet.bettype == 0 && _bet.number == 6) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 0) ||
		(_bet.bettype == 3 && _bet.number == 3) ||
		(_bet.bettype == 2 && _bet.number == 1) ||
		(_bet.bettype == 1 && (_bet.number == 3 || _bet.number == 26 || _bet.number == 29))
}
if (_rouletteWinNum == 7) {
	won =
		(_bet.bettype == 0 && _bet.number == 7) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 1) ||
		(_bet.bettype == 3 && _bet.number == 4) ||
		(_bet.bettype == 2 && _bet.number == 2) ||
		(_bet.bettype == 1 && (_bet.number == 4 || _bet.number == 27 || _bet.number == 30))
}
if (_rouletteWinNum == 8) {
	won =
		(_bet.bettype == 0 && _bet.number == 8) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 1) ||
		(_bet.bettype == 3 && (_bet.number == 4 || _bet.number == 5)) ||
		(_bet.bettype == 2 && _bet.number == 2) ||
		(_bet.bettype == 1 && (_bet.number == 4 || _bet.number == 5 || _bet.number == 28 || _bet.number == 31))
}
if (_rouletteWinNum == 9) {
	won =
		(_bet.bettype == 0 && _bet.number == 9) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 1) ||
		(_bet.bettype == 3 && _bet.number == 5) ||
		(_bet.bettype == 2 && _bet.number == 2) ||
		(_bet.bettype == 1 && (_bet.number == 5 || _bet.number == 32))
}
if (_rouletteWinNum == 10) {
	won =
		(_bet.bettype == 0 && _bet.number == 10) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 1) ||
		(_bet.bettype == 3 && _bet.number == 6) ||
		(_bet.bettype == 2 && _bet.number == 3) ||
		(_bet.bettype == 1 && (_bet.number == 6 || _bet.number == 27 || _bet.number == 30 || _bet.number == 33))
}
if (_rouletteWinNum == 11) {
	won =
		(_bet.bettype == 0 && _bet.number == 11) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 1) ||
		(_bet.bettype == 3 && (_bet.number == 6 || _bet.number == 7)) ||
		(_bet.bettype == 2 && _bet.number == 3) ||
		(_bet.bettype == 1 &&
			(_bet.number == 6 || _bet.number == 7 || _bet.number == 26 || _bet.number == 31 || _bet.number == 34))
}
if (_rouletteWinNum == 12) {
	won =
		(_bet.bettype == 0 && _bet.number == 12) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 0) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 1) ||
		(_bet.bettype == 3 && _bet.number == 7) ||
		(_bet.bettype == 2 && _bet.number == 3) ||
		(_bet.bettype == 1 && (_bet.number == 7 || _bet.number == 32 || _bet.number == 35))
}
if (_rouletteWinNum == 13) {
	won =
		(_bet.bettype == 0 && _bet.number == 13) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 2) ||
		(_bet.bettype == 3 && _bet.number == 8) ||
		(_bet.bettype == 2 && _bet.number == 4) ||
		(_bet.bettype == 1 && (_bet.number == 8 || _bet.number == 30 || _bet.number == 33 || _bet.number == 36))
}
if (_rouletteWinNum == 14) {
	won =
		(_bet.bettype == 0 && _bet.number == 14) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 2) ||
		(_bet.bettype == 3 && (_bet.number == 8 || _bet.number == 9)) ||
		(_bet.bettype == 2 && _bet.number == 4) ||
		(_bet.bettype == 1 && (_bet.number == 8 || _bet.number == 9 || _bet.number == 34 || _bet.number == 37))
}
if (_rouletteWinNum == 15) {
	won =
		(_bet.bettype == 0 && _bet.number == 15) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 2) ||
		(_bet.bettype == 3 && _bet.number == 9) ||
		(_bet.bettype == 2 && _bet.number == 4) ||
		(_bet.bettype == 1 && (_bet.number == 9 || _bet.number == 35 || _bet.number == 38))
}
if (_rouletteWinNum == 16) {
	won =
		(_bet.bettype == 0 && _bet.number == 16) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 2) ||
		(_bet.bettype == 3 && _bet.number == 10) ||
		(_bet.bettype == 2 && _bet.number == 5) ||
		(_bet.bettype == 1 && (_bet.number == 10 || _bet.number == 36 || _bet.number == 39))
}
if (_rouletteWinNum == 17) {
	won =
		(_bet.bettype == 0 && _bet.number == 17) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 2) ||
		(_bet.bettype == 3 && (_bet.number == 10 || _bet.number == 11)) ||
		(_bet.bettype == 2 && _bet.number == 5) ||
		(_bet.bettype == 1 && (_bet.number == 10 || _bet.number == 11 || _bet.number == 37 || _bet.number == 40))
}
if (_rouletteWinNum == 18) {
	won =
		(_bet.bettype == 0 && _bet.number == 18) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 0) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 2) ||
		(_bet.bettype == 3 && _bet.number == 11) ||
		(_bet.bettype == 2 && _bet.number == 5) ||
		(_bet.bettype == 1 && (_bet.number == 11 || _bet.number == 38 || _bet.number == 41))
}
if (_rouletteWinNum == 19) {
	won =
		(_bet.bettype == 0 && _bet.number == 19) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 3) ||
		(_bet.bettype == 3 && _bet.number == 12) ||
		(_bet.bettype == 2 && _bet.number == 6) ||
		(_bet.bettype == 1 && (_bet.number == 12 || _bet.number == 39 || _bet.number == 42))
}
if (_rouletteWinNum == 20) {
	won =
		(_bet.bettype == 0 && _bet.number == 20) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 3) ||
		(_bet.bettype == 3 && (_bet.number == 12 || _bet.number == 13)) ||
		(_bet.bettype == 2 && _bet.number == 6) ||
		(_bet.bettype == 1 && (_bet.number == 12 || _bet.number == 13 || _bet.number == 40 || _bet.number == 43))
}
if (_rouletteWinNum == 21) {
	won =
		(_bet.bettype == 0 && _bet.number == 21) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 3) ||
		(_bet.bettype == 3 && _bet.number == 13) ||
		(_bet.bettype == 2 && _bet.number == 6) ||
		(_bet.bettype == 1 && (_bet.number == 13 || _bet.number == 41 || _bet.number == 44))
}
if (_rouletteWinNum == 22) {
	won =
		(_bet.bettype == 0 && _bet.number == 22) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 3) ||
		(_bet.bettype == 3 && _bet.number == 14) ||
		(_bet.bettype == 2 && _bet.number == 7) ||
		(_bet.bettype == 1 && (_bet.number == 14 || _bet.number == 42 || _bet.number == 45))
}
if (_rouletteWinNum == 23) {
	won =
		(_bet.bettype == 0 && _bet.number == 23) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 3) ||
		(_bet.bettype == 3 && (_bet.number == 14 || _bet.number == 15)) ||
		(_bet.bettype == 2 && _bet.number == 7) ||
		(_bet.bettype == 1 && (_bet.number == 14 || _bet.number == 15 || _bet.number == 43 || _bet.number == 46))
}
if (_rouletteWinNum == 24) {
	won =
		(_bet.bettype == 0 && _bet.number == 24) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 1) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 3) ||
		(_bet.bettype == 3 && _bet.number == 15) ||
		(_bet.bettype == 2 && _bet.number == 7) ||
		(_bet.bettype == 1 && (_bet.number == 15 || _bet.number == 44 || _bet.number == 47))
}
if (_rouletteWinNum == 25) {
	won =
		(_bet.bettype == 0 && _bet.number == 25) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 4) ||
		(_bet.bettype == 3 && _bet.number == 16) ||
		(_bet.bettype == 2 && _bet.number == 8) ||
		(_bet.bettype == 1 && (_bet.number == 16 || _bet.number == 45 || _bet.number == 48))
}
if (_rouletteWinNum == 26) {
	won =
		(_bet.bettype == 0 && _bet.number == 26) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 4) ||
		(_bet.bettype == 3 && (_bet.number == 16 || _bet.number == 17)) ||
		(_bet.bettype == 2 && _bet.number == 8) ||
		(_bet.bettype == 1 && (_bet.number == 16 || _bet.number == 17 || _bet.number == 46 || _bet.number == 49))
}

if (_rouletteWinNum == 27) {
	won =
		(_bet.bettype == 0 && _bet.number == 27) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 4) ||
		(_bet.bettype == 3 && _bet.number == 17) ||
		(_bet.bettype == 2 && _bet.number == 8) ||
		(_bet.bettype == 1 && (_bet.number == 17 || _bet.number == 47 || _bet.number == 50))
}

if (_rouletteWinNum == 28) {
	won =
		(_bet.bettype == 0 && _bet.number == 28) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 4) ||
		(_bet.bettype == 3 && _bet.number == 18) ||
		(_bet.bettype == 2 && _bet.number == 9) ||
		(_bet.bettype == 1 && (_bet.number == 18 || _bet.number == 48 || _bet.number == 51))
}

if (_rouletteWinNum == 29) {
	won =
		(_bet.bettype == 0 && _bet.number == 29) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 4) ||
		(_bet.bettype == 3 && (_bet.number == 18 || _bet.number == 19)) ||
		(_bet.bettype == 2 && _bet.number == 9) ||
		(_bet.bettype == 1 && (_bet.number == 18 || _bet.number == 19 || _bet.number == 49 || _bet.number == 52))
}

if (_rouletteWinNum == 30) {
	won =
		(_bet.bettype == 0 && _bet.number == 30) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 4) ||
		(_bet.bettype == 3 && _bet.number == 19) ||
		(_bet.bettype == 2 && _bet.number == 9) ||
		(_bet.bettype == 1 && (_bet.number == 19 || _bet.number == 50 || _bet.number == 53))
}

if (_rouletteWinNum == 31) {
	won =
		(_bet.bettype == 0 && _bet.number == 31) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 5) ||
		(_bet.bettype == 3 && _bet.number == 20) ||
		(_bet.bettype == 2 && _bet.number == 10) ||
		(_bet.bettype == 1 && (_bet.number == 20 || _bet.number == 51 || _bet.number == 54))
}

if (_rouletteWinNum == 32) {
	won =
		(_bet.bettype == 0 && _bet.number == 32) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 5) ||
		(_bet.bettype == 3 && (_bet.number == 20 || _bet.number == 21)) ||
		(_bet.bettype == 2 && _bet.number == 10) ||
		(_bet.bettype == 1 && (_bet.number == 20 || _bet.number == 21 || _bet.number == 52 || _bet.number == 55))
}

if (_rouletteWinNum == 33) {
	won =
		(_bet.bettype == 0 && _bet.number == 33) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 5) ||
		(_bet.bettype == 3 && _bet.number == 21) ||
		(_bet.bettype == 2 && _bet.number == 10) ||
		(_bet.bettype == 1 && (_bet.number == 21 || _bet.number == 53 || _bet.number == 56))
}

if (_rouletteWinNum == 34) {
	won =
		(_bet.bettype == 0 && _bet.number == 34) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 0) ||
		(_bet.bettype == 4 && _bet.number == 5) ||
		(_bet.bettype == 3 && _bet.number == 22) ||
		(_bet.bettype == 2 && _bet.number == 11) ||
		(_bet.bettype == 1 && (_bet.number == 22 || _bet.number == 54))
}

if (_rouletteWinNum == 35) {
	won =
		(_bet.bettype == 0 && _bet.number == 35) ||
		(_bet.bettype == 9 && _bet.number == 0) ||
		(_bet.bettype == 8 && _bet.number == 1) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 1) ||
		(_bet.bettype == 4 && _bet.number == 5) ||
		(_bet.bettype == 3 && (_bet.number == 20 || _bet.umber == 21)) ||
		(_bet.bettype == 2 && _bet.number == 11) ||
		(_bet.bettype == 1 && (_bet.number == 22 || _bet.number == 23 || _bet.number == 55))
}

if (_rouletteWinNum == 36) {
	won =
		(_bet.bettype == 0 && _bet.number == 36) ||
		(_bet.bettype == 9 && _bet.number == 1) ||
		(_bet.bettype == 8 && _bet.number == 0) ||
		(_bet.bettype == 7 && _bet.number == 1) ||
		(_bet.bettype == 6 && _bet.number == 2) ||
		(_bet.bettype == 5 && _bet.number == 2) ||
		(_bet.bettype == 4 && _bet.number == 5) ||
		(_bet.bettype == 3 && _bet.number == 23) ||
		(_bet.bettype == 2 && _bet.number == 11) ||
		(_bet.bettype == 1 && (_bet.number == 23 || _bet.number == 56))
}


		return won;
}
	
	/**
	 * @dev This is the function that the Chainlink Keeper nodes call
	 * they look for `upkeepNeeded` to return True.
	 * the following should be true for this to return true:
	 * 1. The time interval has passed between raffle runs.
	 * 2. The lottery is open.
	 * 3. The contract has ETH.
	 * 4. Implicity, your subscription is funded with LINK.
	 */

	// function checkUpkeep(
	// 	bytes memory /* checkData */
	// ) public view override returns (bool upkeepNeeded, bytes memory /* performData */) {
	// 	bool isOpen = RaffleState.OPEN == s_raffleState;
	// 	bool timePassed = ((block.timestamp - s_lastTimeStamp) > i_interval);
	// 	bool hasPlayers = s_players.length > 0;
	// 	bool hasBalance = address(this).balance > 0;
	// 	upkeepNeeded = (timePassed && isOpen && hasBalance && hasPlayers);
	// 	return (upkeepNeeded, "0x0"); // can we comment this out?
	// }

	/**
	 * @dev Once `checkUpkeep` is returning `true`, this function is called
	 * and it kicks off a Chainlink VRF call to get a random winner.
	 */

	// function performUpkeep(bytes calldata /* performData */) external override {
	// 	(bool upkeepNeeded, ) = checkUpkeep("");
	// 	// require(upkeepNeeded, "Upkeep not needed");
	// 	if (!upkeepNeeded) {
	// 		revert Raffle__UpkeepNotNeeded(
	// 			address(this).balance,
	// 			s_players.length,
	// 			uint256(s_raffleState)
	// 		);
	// 	}
	// 	s_raffleState = RaffleState.CALCULATING;
	// 	uint256 requestId = i_vrfCoordinator.requestRandomWords(
	// 		i_gasLane,
	// 		i_subscriptionId,
	// 		REQUEST_CONFIRMATIONS,
	// 		i_callbackGasLimit,
	// 		NUM_WORDS
	// 	);
	// 	// Quiz... is this redundant?
	// 	emit RequestedRaffleWinner(requestId);
	// }

	/**
	 * @dev This is the function that Chainlink VRF node
	 * calls to send the money to the random winner.
	 */

	// function fulfillRandomWords(
	// 	uint256 /* requestId */,
	// 	uint256[] memory randomWords
	// ) internal override {
	// s_players size 10
	// randomNumber 202
	// 202 % 10 ? what's doesn't divide evenly into 202?
	// 20 * 10 = 200
	// 2
	// 202 % 10 = 2
	// 	uint256 indexOfWinner = randomWords[0] % s_players.length;
	// 	address payable recentWinner = s_players[indexOfWinner];
	// 	s_recentWinner = recentWinner;
	// 	s_players = new address payable[](0);
	// 	s_raffleState = RaffleState.OPEN;
	// 	s_lastTimeStamp = block.timestamp;
	// 	(bool success, ) = recentWinner.call{value: address(this).balance}("");
	// 	// require(success, "Transfer failed");
	// 	if (!success) {
	// 		revert Raffle__TransferFailed();
	// 	}
	// 	emit WinnerPicked(recentWinner);
	// }

	/** Getter Functions */

	/** View Functions */

	// function getRaffleState() public view returns (RaffleState) {
	// 	return s_raffleState;
	// }

	// function getRecentWinner() public view returns (address) {
	// 	return s_recentWinner;
	// }

	// function getPlayer(uint256 index) public view returns (address) {
	// 	return s_players[index];
	// }

	// function getLastTimeStamp() public view returns (uint256) {
	// 	return s_lastTimeStamp;
	// }

	// function getInterval() public view returns (uint256) {
	// 	return i_interval;
	// }

	// function getEntranceFee() public view returns (uint256) {
	// 	return i_entranceFee;
	// }

	// function getNumberOfPlayers() public view returns (uint256) {
	// 	return s_players.length;
	// }

	// /**Pure functions */

	// function getNumWords() public pure returns (uint256) {
	// 	return NUM_WORDS;
	// }

	// function getRequestConfirmations() public pure returns (uint256) {
	// 	return REQUEST_CONFIRMATIONS;
	// }
}
/** let won = false
let _rouletteWinNum = 0

let number = 0
let bettype = 0

if (_rouletteWinNum == 0) {
	won =
		(bettype == 0 && number == 0) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && (number == 12 || number == 13)) ||
		(bettype == 1 && (number == 57 || number == 58 || number == 59))
}
if (_rouletteWinNum == 1) {
	won =
		(bettype == 0 && number == 1) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 0) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 0) ||
		(bettype == 1 && (number == 0 || number == 24))
}
if (_rouletteWinNum == 2) {
	won =
		(bettype == 0 && number == 2) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && (number == 0 || number == 1)) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 0) ||
		(bettype == 1 && (number == 0 || number == 1 || number == 25))
}
if (_rouletteWinNum == 3) {
	won =
		(bettype == 0 && number == 3) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 1) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 0) ||
		(bettype == 1 && (number == 1 || number == 26))
}
if (_rouletteWinNum == 4) {
	won =
		(bettype == 0 && number == 4) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 2) ||
		(bettype == 2 && number == 1) ||
		(bettype == 1 && (number == 2 || number == 24 || number == 27))
}
if (_rouletteWinNum == 5) {
	won =
		(bettype == 0 && number == 5) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && (number == 2 || number == 3)) ||
		(bettype == 2 && number == 1) ||
		(bettype == 1 && (number == 2 || number == 3 || number == 25 || number == 28))
}
if (_rouletteWinNum == 6) {
	won =
		(bettype == 0 && number == 6) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 0) ||
		(bettype == 3 && number == 3) ||
		(bettype == 2 && number == 1) ||
		(bettype == 1 && (number == 3 || number == 26 || number == 29))
}
if (_rouletteWinNum == 7) {
	won =
		(bettype == 0 && number == 7) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 4) ||
		(bettype == 2 && number == 2) ||
		(bettype == 1 && (number == 4 || number == 27 || number == 30))
}
if (_rouletteWinNum == 8) {
	won =
		(bettype == 0 && number == 8) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && (number == 4 || number == 5)) ||
		(bettype == 2 && number == 2) ||
		(bettype == 1 && (number == 4 || number == 5 || number == 28 || number == 31))
}
if (_rouletteWinNum == 9) {
	won =
		(bettype == 0 && number == 9) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 5) ||
		(bettype == 2 && number == 2) ||
		(bettype == 1 && (number == 5 || number == 32))
}
if (_rouletteWinNum == 10) {
	won =
		(bettype == 0 && number == 10) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 6) ||
		(bettype == 2 && number == 3) ||
		(bettype == 1 && (number == 6 || number == 27 || number == 30 || number == 33))
}
if (_rouletteWinNum == 11) {
	won =
		(bettype == 0 && number == 11) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && (number == 6 || number == 7)) ||
		(bettype == 2 && number == 3) ||
		(bettype == 1 &&
			(number == 6 || number == 7 || number == 26 || number == 31 || number == 34))
}
if (_rouletteWinNum == 12) {
	won =
		(bettype == 0 && number == 12) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 0) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 1) ||
		(bettype == 3 && number == 7) ||
		(bettype == 2 && number == 3) ||
		(bettype == 1 && (number == 7 || number == 32 || number == 35))
}
if (_rouletteWinNum == 13) {
	won =
		(bettype == 0 && number == 13) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 8) ||
		(bettype == 2 && number == 4) ||
		(bettype == 1 && (number == 8 || number == 30 || number == 33 || number == 36))
}
if (_rouletteWinNum == 14) {
	won =
		(bettype == 0 && number == 14) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && (number == 8 || number == 9)) ||
		(bettype == 2 && number == 4) ||
		(bettype == 1 && (number == 8 || number == 9 || number == 34 || number == 37))
}
if (_rouletteWinNum == 15) {
	won =
		(bettype == 0 && number == 15) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 9) ||
		(bettype == 2 && number == 4) ||
		(bettype == 1 && (number == 9 || number == 35 || number == 38))
}
if (_rouletteWinNum == 16) {
	won =
		(bettype == 0 && number == 16) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 10) ||
		(bettype == 2 && number == 5) ||
		(bettype == 1 && (number == 10 || number == 36 || number == 39))
}
if (_rouletteWinNum == 17) {
	won =
		(bettype == 0 && number == 17) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && (number == 10 || number == 11)) ||
		(bettype == 2 && number == 5) ||
		(bettype == 1 && (number == 10 || number == 11 || number == 37 || number == 40))
}
if (_rouletteWinNum == 18) {
	won =
		(bettype == 0 && number == 18) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 0) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 2) ||
		(bettype == 3 && number == 11) ||
		(bettype == 2 && number == 5) ||
		(bettype == 1 && (number == 11 || number == 38 || number == 41))
}
if (_rouletteWinNum == 19) {
	won =
		(bettype == 0 && number == 19) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 12) ||
		(bettype == 2 && number == 6) ||
		(bettype == 1 && (number == 12 || number == 39 || number == 42))
}
if (_rouletteWinNum == 20) {
	won =
		(bettype == 0 && number == 20) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && (number == 12 || number == 13)) ||
		(bettype == 2 && number == 6) ||
		(bettype == 1 && (number == 12 || number == 13 || number == 40 || number == 43))
}
if (_rouletteWinNum == 21) {
	won =
		(bettype == 0 && number == 21) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 13) ||
		(bettype == 2 && number == 6) ||
		(bettype == 1 && (number == 13 || number == 41 || number == 44))
}
if (_rouletteWinNum == 22) {
	won =
		(bettype == 0 && number == 22) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 14) ||
		(bettype == 2 && number == 7) ||
		(bettype == 1 && (number == 14 || number == 42 || number == 45))
}
if (_rouletteWinNum == 23) {
	won =
		(bettype == 0 && number == 23) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && (number == 14 || number == 15)) ||
		(bettype == 2 && number == 7) ||
		(bettype == 1 && (number == 14 || number == 15 || number == 43 || number == 46))
}
if (_rouletteWinNum == 24) {
	won =
		(bettype == 0 && number == 24) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 1) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 3) ||
		(bettype == 3 && number == 15) ||
		(bettype == 2 && number == 7) ||
		(bettype == 1 && (number == 15 || number == 44 || number == 47))
}
if (_rouletteWinNum == 25) {
	won =
		(bettype == 0 && number == 25) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 16) ||
		(bettype == 2 && number == 8) ||
		(bettype == 1 && (number == 16 || number == 45 || number == 48))
}
if (_rouletteWinNum == 26) {
	won =
		(bettype == 0 && number == 26) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && (number == 16 || number == 17)) ||
		(bettype == 2 && number == 8) ||
		(bettype == 1 && (number == 16 || number == 17 || number == 46 || number == 49))
}

if (_rouletteWinNum == 27) {
	won =
		(bettype == 0 && number == 27) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 17) ||
		(bettype == 2 && number == 8) ||
		(bettype == 1 && (number == 17 || number == 47 || number == 50))
}

if (_rouletteWinNum == 28) {
	won =
		(bettype == 0 && number == 28) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 18) ||
		(bettype == 2 && number == 9) ||
		(bettype == 1 && (number == 18 || number == 48 || number == 51))
}

if (_rouletteWinNum == 29) {
	won =
		(bettype == 0 && number == 29) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && (number == 18 || number == 19)) ||
		(bettype == 2 && number == 9) ||
		(bettype == 1 && (number == 18 || number == 19 || number == 49 || number == 52))
}

if (_rouletteWinNum == 30) {
	won =
		(bettype == 0 && number == 30) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 4) ||
		(bettype == 3 && number == 19) ||
		(bettype == 2 && number == 9) ||
		(bettype == 1 && (number == 19 || number == 50 || number == 53))
}

if (_rouletteWinNum == 31) {
	won =
		(bettype == 0 && number == 31) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 20) ||
		(bettype == 2 && number == 10) ||
		(bettype == 1 && (number == 20 || number == 51 || number == 54))
}

if (_rouletteWinNum == 32) {
	won =
		(bettype == 0 && number == 32) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && (number == 20 || number == 21)) ||
		(bettype == 2 && number == 10) ||
		(bettype == 1 && (number == 20 || number == 21 || number == 52 || number == 55))
}

if (_rouletteWinNum == 33) {
	won =
		(bettype == 0 && number == 33) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 21) ||
		(bettype == 2 && number == 10) ||
		(bettype == 1 && (number == 21 || number == 53 || number == 56))
}

if (_rouletteWinNum == 34) {
	won =
		(bettype == 0 && number == 34) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 0) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 22) ||
		(bettype == 2 && number == 11) ||
		(bettype == 1 && (number == 22 || number == 54))
}

if (_rouletteWinNum == 35) {
	won =
		(bettype == 0 && number == 35) ||
		(bettype == 9 && number == 0) ||
		(bettype == 8 && number == 1) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 1) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && (number == 20 || number == 21)) ||
		(bettype == 2 && number == 11) ||
		(bettype == 1 && (number == 22 || number == 23 || number == 55))
}

if (_rouletteWinNum == 36) {
	won =
		(bettype == 0 && number == 36) ||
		(bettype == 9 && number == 1) ||
		(bettype == 8 && number == 0) ||
		(bettype == 7 && number == 1) ||
		(bettype == 6 && number == 2) ||
		(bettype == 5 && number == 2) ||
		(bettype == 4 && number == 5) ||
		(bettype == 3 && number == 23) ||
		(bettype == 2 && number == 11) ||
		(bettype == 1 && (number == 23 || number == 56))
}

console.log(won)
*/
