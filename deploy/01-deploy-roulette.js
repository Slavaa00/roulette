const { network, ethers } = require("hardhat")

const {
	networkConfig,
	developmentChains,
	VERIFICATION_BLOCK_CONFIRMATIONS,
} = require("../helper-hardhat-config")

const { verify } = require("../utils/verify")

const FUND_AMOUNT = ethers.utils.parseEther("1") // 1 Ether, or 1e18 (10^18) Wei
const INITIAL_AMOUNT = 50000000

module.exports = async ({ getNamedAccounts, deployments }) => {
	const { deploy, log } = deployments
	const { deployer , player } = await getNamedAccounts()
	const chainId = network.config.chainId

	// let linkAddress = networkConfig[chainId]["linkAddress"]
	// let wrapperAddress = networkConfig[chainId]["wrapperAddress"]
	
	

	
	if (chainId == 31337) {
		// create VRFV2 Subscription
		vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")
		vrfCoordinatorV2Address = vrfCoordinatorV2Mock.address
		const transactionResponse = await vrfCoordinatorV2Mock.createSubscription()
		const transactionReceipt = await transactionResponse.wait()
		subscriptionId = transactionReceipt.events[0].args.subId
		// Fund the subscription
		// Our mock makes it so we don't actually have to worry about sending fund
		await vrfCoordinatorV2Mock.fundSubscription(subscriptionId, FUND_AMOUNT)
	} else {
		vrfCoordinatorV2Address = networkConfig[chainId]["vrfCoordinatorV2"]
		subscriptionId = networkConfig[chainId]["subscriptionId"]
	}

	const waitBlockConfirmations = developmentChains.includes(network.name)
		? 1
		: VERIFICATION_BLOCK_CONFIRMATIONS

	log("----------------------------------------------------")
	
	const arguments = [
		vrfCoordinatorV2Address,
		subscriptionId,
		networkConfig[chainId]["gasLane"],
		networkConfig[chainId]["keepersUpdateInterval"],
		networkConfig[chainId]["startGameValue"],
		networkConfig[chainId]["minimalBet"],
		
		
	]
	const roulette = await deploy("Roulette", {
		from: deployer,
		args: arguments,
		log: true,
		value: INITIAL_AMOUNT,
		waitConfirmations: waitBlockConfirmations,
	})

	// Ensure the Roulette contract is a valid consumer of the VRFCoordinatorV2Mock contract.
	if (developmentChains.includes(network.name)) {
		const vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")
		await vrfCoordinatorV2Mock.addConsumer(subscriptionId, roulette.address)
	}

	// Verify the deployment
	if (!developmentChains.includes(network.name) && process.env.ETHERSCAN_API_KEY) {
		log("Verifying...")
		await verify(roulette.address, arguments)
	}

	// log("Enter lottery with command:")
	// const networkName = network.name == "hardhat" ? "localhost" : network.name
	// log(`yarn hardhat run scripts/enterRaffle.js --network ${networkName}`)
	// log("----------------------------------------------------")
}

module.exports.tags = ["all", "roulette"]
