const { ethers } = require("hardhat")

const networkConfig = {
	default: {
		name: "hardhat",
		keepersUpdateInterval: "30",
	},
	31337: {
		name: "localhost",
		subscriptionId: "588",
		gasLane: "0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc", // 30 gwei
		keepersUpdateInterval: "20",

		linkAddress: "0x326c977e6efc84e512bb9c30f76e30c160ed06fb",
		wrapperAddress: "0x708701a1dff4f478de54383e49a627ed4852c816",
		linkRequestConfirmations: "3",
		callbackGasLimit: "500000", // 500,000 gas
		numWords: "1",
		startGameValue: ethers.utils.parseEther("0.01"),
		minimalBet: "1000000000", // 1 gwei
		maximumBet: ethers.utils.parseEther("100"),
	},
	5: {
		name: "goerli",
		subscriptionId: "6361",
		gasLane: "0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15", // 30 gwei
		keepersUpdateInterval: "20",

		vrfCoordinatorV2: "0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D",

		linkAddress: "0x326c977e6efc84e512bb9c30f76e30c160ed06fb",
		wrapperAddress: "0x708701a1dff4f478de54383e49a627ed4852c816",
		linkRequestConfirmations: "3",
		callbackGasLimit: "500000", // 500,000 gas
		numWords: "1",
		startGameValue: ethers.utils.parseEther("0.000000001"), // 1 gwei
		minimalBet: "1000", // 1000 wei
		maximumBet: ethers.utils.parseEther("0.01"),
	},
	1: {
		name: "mainnet",
		keepersUpdateInterval: "20",
	},
}

const developmentChains = ["hardhat", "localhost"]
const VERIFICATION_BLOCK_CONFIRMATIONS = 6
const frontEndContractsFile = "../nextjs-roulette/constants/contractAddresses.json"
const frontEndAbiFile = "../nextjs-roulette/constants/abi.json"

module.exports = {
	networkConfig,
	developmentChains,
	VERIFICATION_BLOCK_CONFIRMATIONS,
	frontEndContractsFile,
	frontEndAbiFile,
}
