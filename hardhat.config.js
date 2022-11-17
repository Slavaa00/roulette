require("@nomicfoundation/hardhat-toolbox")

require("hardhat-deploy")
require("hardhat-contract-sizer")
require("dotenv").config()

const GOERLI_RPC_URL = process.env.GOERLI_RPC_URL 
	

const PRIVATE_KEY = process.env.PRIVATE_KEY

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""

const REPORT_GAS = process.env.REPORT_GAS || false

/** @type import('hardhat/config').HardhatUserConfig */

module.exports = {
	defaultNetwork: "hardhat",

	networks: {
		hardhat: {
			chainId: 31337,
		},
		localhost: {
			chainId: 31337,
		},
		goerli: {
			url: GOERLI_RPC_URL,
			accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
			saveDeployments: true,
			chainId: 5,
		},
	},

	etherscan: {
		apiKey: {
			goerli: ETHERSCAN_API_KEY,
		},
	},

	gasReporter: {
		enabled: REPORT_GAS,
		currency: "USD",
		outputFile: "gas-report.txt",
		noColors: true,
		coinmarketcap: process.env.COINMARKETCAP_API_KEY,
	},

	contractSizer: {
		runOnCompile: false,
		only: ["Roulette"],
	},

	namedAccounts: {
		deployer: {
			default: 0,
			5: 0,
		},
		player: {
			default: 1,
			5: 1,
		},
	},

	solidity: {
		compilers: [
			{
				version: "0.8.17",
			},
			{
				version: "0.4.24",
			},
		],
	},

	mocha: {
		timeout: 500000,
	},
}
