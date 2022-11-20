const { assert, expect } = require("chai")
const { getNamedAccounts, ethers, network } = require("hardhat")
const { developmentChains } = require("../../helper-hardhat-config")

developmentChains.includes(network.name)
	? describe.skip
	: describe("Roulette Staging Tests", function () {
			let roulette, deployer

			beforeEach(async function () {
				deployer = (await getNamedAccounts()).deployer
				roulette = await ethers.getContract("Roulette", deployer)
				
			})

			describe("fulfillRandomWords", function () {
				
				it("works with live Chainlink Keepers and Chainlink VRF, we get a random number", async function () {
					
					const startingTimeStamp = await roulette.getLastTimeStamp()
					const accounts = await ethers.getSigners()

					await new Promise(async (resolve, reject) => {
						// setup listener before we enter the raffle
						// Just in case the blockchain moves REALLY fast
						roulette.once("GameFinished", async () => {
							console.log("Spin completed")
						
								try {
								const moneyInTheBank = await roulette.getMoneyInTheBank();
								const endingTimeStamp = await roulette.getLastTimeStamp();
								
								assert.equal(moneyInTheBank, 0);
								// assert.equal(
								// 	winnerEndingBalance.toString(),
								// 	winnerStartingBalance.add(raffleEntranceFee).toString()
								// )
								assert(endingTimeStamp > startingTimeStamp);
								resolve();
							}
							catch (error) {
								console.log(error)
                              	reject(error)
							}
						})
					
						console.log("Entering Casino...")

						const tx = await roulette.createBet(5, [0], {value: ethers.utils.parseEther("0.000000001")}) 
						await tx.wait(1)
						
						// const winnerStartingBalance = await accounts[0].getBalance()
						
						

						// and this code WONT complete until our listener has finished listening!
					})
				})
			})
	  })
