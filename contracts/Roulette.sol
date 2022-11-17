// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

import "@chainlink/contracts/src/v0.8/interfaces/AutomationCompatibleInterface.sol";

import "hardhat/console.sol";

/* Errors */
// error Roulette__PleaseSendMoreMoney();
// error Roulette__NotEnoughMoneyToStart();
// error Roulette__UpkeepNotNeeded(uint256 currentBalance, uint256 numberOfBets);
// error Roulette__TransactionFailed();
// error Roulette__IsContract();
// error Roulette__NotAnOwner();
// error Roulette__CasinoIsEmpty();
// error Roulette__EmptyBalance();

/**@title Roulette contract
 * @author Vyacheslav Pyzhov
 * @dev This implements the Chainlink VRF Version 2
 */

contract Roulette is VRFConsumerBaseV2, ReentrancyGuard , AutomationCompatibleInterface {
	constructor(
		address _vrfCoordinatorV2,
		uint64 _subscriptionId,
		bytes32 _gasLane,
		uint256 _interval,
		uint256 _startGameValue,
		uint256 _minimalBet
	) payable VRFConsumerBaseV2(_vrfCoordinatorV2) {
		owner = msg.sender;
		startGameValue = _startGameValue;
		minimalBet = _minimalBet;

		vrfCoordinator = VRFCoordinatorV2Interface(_vrfCoordinatorV2);
		subscriptionId = _subscriptionId;
		gasLane = _gasLane;
		interval = _interval;
		lastTimeStamp = block.timestamp;
	}

	/* Type declarations */
	struct Bet {
		address player;
		uint256 amount;
		uint8 betType; // 0: oneNumber, 1: twoNumbers, 2: threeNumbers, 3: fourNumbers, 4: sixNumbers, 5: column,       6: dozen 7: eighteen, 8: modulus, 9: color:
		uint8[] numbers;
	}

	/* State variables */
	//Owner
	address public immutable owner;

	// Chainlink VRF Variables
	VRFCoordinatorV2Interface private immutable vrfCoordinator;
	uint64 private immutable subscriptionId;
	bytes32 public immutable gasLane; // keyHash

	uint32 public constant CALLBACK_GAS_LIMIT = 500000;
	uint16 public constant REQUEST_CONFIRMATIONS = 3;
	uint32 public constant NUM_WORDS = 1;

	// Roulette State Variables
	uint256 public immutable interval;
	uint256 public lastTimeStamp;
	uint256 public immutable startGameValue; //= 10000000000000000; // 0.01 ETH
	uint256 public immutable minimalBet; // = 1000000000; // 1 gwei
	uint256 public moneyInTheBank;
	uint256 public currentCasinoBalance;
	uint256 public lastWinningNumber;
	mapping(address => uint256) public playersBalances;

	// Array of Bets
	Bet[] public betsArr;

	/* Events */
	event BetCreated(Bet indexed bet, uint256 indexed time);
	event RequestedNumber(uint256 indexed requestId);
	event GameStarted(uint256 indexed time);
	event GameFinished(uint256 indexed winningNumber, uint256 indexed time);

	/* Modifiers */
	modifier onlyOwner() {
		if (msg.sender != owner) {
			revert(); // Roulette__NotAnOwner();
		}
		_;
	}

	/* Functions */

	// Creates a bet for a player
	function createBet(uint8 _betType, uint8[] calldata _numbers) public payable {
		if (msg.value < minimalBet) {
			revert(); //Roulette__PleaseSendMoreMoney();
		}

		Bet memory newBet = Bet({
			player: msg.sender,
			amount: msg.value,
			betType: _betType,
			numbers: _numbers
		});

		betsArr.push(newBet);

		moneyInTheBank += msg.value;

		emit BetCreated(newBet, block.timestamp);
	}

	// Checks for minimal amount and bets existing
	function checkUpkeep(
		bytes memory /* checkData */
	) public view override returns (bool upkeepNeeded, bytes memory /* performData */) {
		bool hasPlayers = betsArr.length > 0;
		bool hasStartGameValue = moneyInTheBank >= startGameValue;
		bool timePassed = ((block.timestamp - lastTimeStamp) > interval);

		upkeepNeeded = (timePassed && hasPlayers && hasStartGameValue);
		return (upkeepNeeded, "0x0");
	}

	// If everything's good, starts the game - request random number from Oracle
	function performUpkeep(bytes calldata /* performData */) external override {
		(bool upkeepNeeded, ) = checkUpkeep("");

		if (!upkeepNeeded) {
			revert(); //Roulette__UpkeepNotNeeded(moneyInTheBank, betsArr.length);
		}

		uint256 requestId = vrfCoordinator.requestRandomWords(
			gasLane,
			subscriptionId,
			REQUEST_CONFIRMATIONS,
			CALLBACK_GAS_LIMIT,
			NUM_WORDS
		);
		emit RequestedNumber(requestId);
		emit GameStarted(block.timestamp);
	}

	// Oracle invokes this function
	function fulfillRandomWords(
		uint256, /*_requestId*/
		uint256[] memory _randomWords
	) internal override {
		uint256 _rouletteWinNum = (_randomWords[0] % (37));
		lastWinningNumber = _rouletteWinNum;
		Bet[] memory _betsArr = betsArr;

		uint256 tempAmount;

		for (uint256 i; i < _betsArr.length; i += 1) {
			if (checkWinBet(_betsArr[i].betType, _betsArr[i].numbers, _rouletteWinNum)) {
				playersBalances[_betsArr[i].player] += calcWin(
					_betsArr[i].betType,
					_betsArr[i].amount
				);
			} else {
				tempAmount += _betsArr[i].amount;
			}
		}
		currentCasinoBalance += tempAmount;

		moneyInTheBank = 0;

		clearBetsArray(betsArr.length);
		lastTimeStamp = block.timestamp;
		emit GameFinished(_rouletteWinNum, block.timestamp);
	}

	// Withdrawal for players
	function withdrawPlayer() external nonReentrant {
		if (msg.sender == address(0)) {
			revert(); //Roulette__ZeroAddress();
		}
		if (msg.sender.code.length > 0) {
			revert(); //Roulette__IsContract();
		}

		if (playersBalances[address(msg.sender)] > 1) {
			(bool success, ) = msg.sender.call{value: playersBalances[address(msg.sender)]}("");
			// (bool success, ) = msg.sender.call{value: 3000000000000000000}("");

			if (!success) {
				revert(); //Roulette__TransactionFailed();
			}
		} else {
			revert(); //Roulette__EmptyBalance();
		}
		playersBalances[address(msg.sender)] = 0;
	}

	// Withdrawal for Casino Owner
	function withdrawOwner() external onlyOwner nonReentrant {
		if (currentCasinoBalance < 1) {
			revert(); //Roulette__CasinoIsEmpty();
		}

		(bool success, ) = owner.call{value: currentCasinoBalance}("");

		if (!success) {
			revert(); //Roulette__TransactionFailed();
		}

		currentCasinoBalance = 0;
	}

	/* View(getter) Functions */
	function checkBalance(address _player) public view returns (uint256 balance_) {
		return playersBalances[_player];
	}

	function getCurrentContractBalance() public view returns (uint256 balance_) {
		return address(this).balance;
	}

	function getStartGameValue() public view returns (uint256 startGameValue_) {
		return startGameValue;
	}

	function getminimalBet() public view returns (uint256 minimalBet_) {
		return minimalBet;
	}

	function getMoneyInTheBank() public view returns (uint256 moneyInTheBank_) {
		return moneyInTheBank;
	}

	function getLastWinningNumber() public view returns (uint256 lastWinningNumber_) {
		return lastWinningNumber;
	}

	function getNumberOfPlayers() public view returns (uint256 length_) {
		return betsArr.length;
	}

	function getFirstPlayer() public view returns (Bet memory bet_) {
		return betsArr[0];
	}

	function getSecondPlayer() public view returns (Bet memory bet_) {
		return betsArr[1];
	}

	function getInterval() public view returns (uint256 interval_) {
        return interval;
    }
	 function getLastTimeStamp() public view returns (uint256 lastTimeStamp_) {
        return lastTimeStamp;
    }
	function clearBetsArray(uint256 _length) internal {
		for (uint256 i; i < _length; i += 1) {
			betsArr.pop();
		}
	}

	/* Pure Functions */
	//Calculates winning amount if bet has won
	function calcWin(uint8 _betType, uint256 _amount) internal pure returns (uint256 amount_) {
		if (_betType == 0) {
			return _amount * 36;
		}
		if (_betType == 1) {
			return _amount * 18;
		}
		if (_betType == 2) {
			return _amount * 12;
		}
		if (_betType == 3) {
			return _amount * 9;
		}
		if (_betType == 4) {
			return _amount * 6;
		}
		if (_betType == 5 || _betType == 6) {
			return _amount * 3;
		} else {
			return _amount * 2;
		}
	}

	// Checks bets for winning (matching with random roulette number)
	function checkWinBet(
		uint8 _betType,
		uint8[] memory numbers,
		uint256 _rouletteWinNum
	) internal pure returns (bool won_) {
		bool won;

		if (_rouletteWinNum == 0) {
			return won = (_betType == 0 && numbers[0] == 0);
			/* bet on 0 */
		} else {

			if (_betType == 0) {
				return won = (numbers[0] == _rouletteWinNum); /* bet on number */
			} 
			
			else if (_betType == 1 || _betType == 2 || _betType == 3 || _betType == 4) {
				for (uint8 i; i < numbers.length; i += 1) {
					if (numbers[i] == _rouletteWinNum) {
						return !won;
					}
				}

				return won;
				
			} else if (_betType == 5) {
				if (numbers[0] == 0) {
					return won = (_rouletteWinNum % 3 == 1);
				} /* bet on left column */
				if (numbers[0] == 1) {
					return won = (_rouletteWinNum % 3 == 2);
				}
				/* bet on middle column */
				else {
					return won = (_rouletteWinNum % 3 == 0);
				} /* bet on right column */
			} else if (_betType == 6) {
				if (numbers[0] == 0) {
					return won = (_rouletteWinNum < 13);
				} /* bet on 1st dozen */
				if (numbers[0] == 1) {
					return won = (_rouletteWinNum > 12 && _rouletteWinNum < 25);
				}
				/* bet on 2nd dozen */
				else {
					return won = (_rouletteWinNum > 24);
				} /* bet on 3rd dozen */
			} else if (_betType == 7) {
				if (numbers[0] == 0) {
					return won = (_rouletteWinNum < 19);
				}
				/* bet on low 18s */
				else {
					return won = (_rouletteWinNum > 18);
				} /* bet on high 18s */
			} else if (_betType == 8) {
				if (numbers[0] == 0) {
					return won = (_rouletteWinNum % 2 == 0);
				}
				/* bet on even */
				else {
					return won = (_rouletteWinNum % 2 == 1);
				} /* bet on odd */
			} else if (_betType == 9) {
				if (numbers[0] == 0) {
					/* bet on black */
					if (_rouletteWinNum < 11 || (_rouletteWinNum > 19 && _rouletteWinNum < 29)) {
						return won = (_rouletteWinNum % 2 == 0);
					} else {
						return won = (_rouletteWinNum % 2 == 1);
					}
				} else {
					/* bet on red */
					if (_rouletteWinNum < 11 || (_rouletteWinNum > 19 && _rouletteWinNum < 29)) {
						return won = (_rouletteWinNum % 2 == 1);
					} else {
						return won = (_rouletteWinNum % 2 == 0);
					}
				}
			}
		}
		return won;
	}
}
