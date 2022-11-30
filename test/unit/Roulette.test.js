const { assert, expect } = require("chai")
const { network, deployments, ethers } = require("hardhat")
const { developmentChains, networkConfig } = require("../../helper-hardhat-config")

!developmentChains.includes(network.name)
	? describe.skip
	: describe("Roulette Unit Tests", function () {
			let roulette, rouletteContract, vrfCoordinatorV2Mock, interval
			const chainId = network.config.chainId
			
			beforeEach(async () => {
				[deployer, player] = await ethers.getSigners()
				await deployments.fixture(["all"])
				vrfCoordinatorV2Mock = await ethers.getContract("VRFCoordinatorV2Mock")
				rouletteContract = await ethers.getContract("Roulette", deployer) // Returns a new connection to the Roulette contract
				roulette = rouletteContract.connect(player) // Returns a new instance of the Roulette contract connected to player
				await roulette.createBet(5, [0], {value: ethers.utils.parseEther("1")}) // HERE equal2players
				await roulette.createBet(9, [1], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(8, [0], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(7, [1], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(6, [2], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(4, [25,26,27,28,29,30], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(3, [28,29,31,32], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(2, [28,29,30], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(1, [28,31], {value: ethers.utils.parseEther("1")}) 
				await roulette.createBet(0, [28], {value: ethers.utils.parseEther("1")}) 

				// await roulette.createBet(9, [1], {value: 1000000001}) // For CheckUpkeep tests only!
				
				interval = await roulette.getInterval();
				
			})

			describe("constructor", function () {
				
				it("initializes the roulette correctly", async () => {
					
					
					assert.equal(await roulette.owner(), deployer.address.toString())

					assert.equal(
						await roulette.minimalBet(),
						networkConfig[chainId]["minimalBet"]
					)
					assert.equal(
						await roulette.startGameValue(),
						"10000000000000000"
					)
					assert.equal(
						interval.toString(),
						networkConfig[network.config.chainId]["keepersUpdateInterval"]
					)
					
		
       
				})
			})
			describe("deposit, betsArr, ciao, fallback, receive, createBetSpendDeposit", function () {
				
				it("deposits money to player's balance, increasing allPlayersWinnings and allow to createBetSpendDeposit", async () => {
					
					
					await expect(await roulette.deposit({value: ethers.utils.parseEther("1")})).to.changeEtherBalances([rouletteContract, player], [ethers.utils.parseEther("1"), ethers.utils.parseEther("-1")]);
					
					assert.equal(await roulette.allPlayersWinnings(), ethers.utils.parseEther("1").toString())
					
					
					
       
				})
				

				// it('should invoke the fallback function', async () => {
				// 	await player.sendTransaction({
				// 		to: rouletteContract.address,
				// 		data: "0x12",
				// 		value: ethers.utils.parseEther("1").toString()
				// 	});
					

				// 	expect(await roulette.betsArr().length).to.be.equal(11)

				// })

				it("createBetSpendDeposit", async () => {
					await roulette.deposit({value: ethers.utils.parseEther("1")})
					expect(await roulette.playersBalances(player.address)).to.be.equal(ethers.utils.parseEther("1"))

					await roulette.createBetSpendDeposit(0,
						[0],
						1000000000)


					const betsArr = await roulette.getArrayOfBets()

					expect(betsArr.length).to.be.equal(11)
		
       
				})

				it("changes player's balance", async () => {
					await roulette.deposit({value: ethers.utils.parseEther("1")})
					
					
					expect(await roulette.playersBalances(player.address)).to.be.equal(ethers.utils.parseEther("1"))
					
		
       
				})
				

				it("returns Array Of Bets", async () => {
					const betsArr = await roulette.getArrayOfBets()

			
					assert.equal(betsArr[0][0], player.address)
					assert.equal(betsArr[0][1].toString(), ethers.utils.parseEther("1").toString())
					assert.equal(betsArr[0][2], 5)
					assert.equal(betsArr[0][3], 0)

					assert.equal(betsArr[1][0], player.address)
					assert.equal(betsArr[1][1].toString(), ethers.utils.parseEther("1").toString())
					assert.equal(betsArr[1][2], 9)
					assert.equal(betsArr[1][3], 1)
	
		
       
				})
			})

			describe("createBet", function () {

				it("reverts when you don't pay enough", async () => {
				await expect(roulette.createBet(0, [0], {value: 1})).to.be.reverted
				})

				it("reverts when you exceed max bet", async () => {
				await expect(roulette.createBet(0, [0], {value: ethers.utils.parseEther("101")})).to.be.reverted
				})
				
				it("creates a bet and adds it in the array of Bets with correct data", async () => {
					
					expect(await roulette.getNumberOfPlayers()).to.be.equal(10) // HERE equal2players
					
					// const bet = await roulette.getFirstPlayer()
					// expect(bet[0]).to.be.equal(player.address)
					// expect(bet[1]).to.be.equal(ethers.utils.parseEther("1"))
					// expect(bet[2]).to.be.equal(5)
					// expect(bet[3].join()).to.be.equal("0")

					expect(await roulette.moneyInTheBank()).to.be.equal(BigInt(ethers.utils.parseEther("10"))) // HERE equal2players
					
					})
				
				it("emits event on createBet", async () => {
					await expect(roulette.createBet(0, [0], {value: ethers.utils.parseEther("1")})).to.emit(
						roulette,
						"BetCreated"
					)
				})
			
				it("reverts wrong numbers length", async () => {
					await expect(roulette.createBet(9, [0,1], {value: ethers.utils.parseEther("1")})).to.be.reverted
				})

				it("reverts impossible bet", async () => {
					await expect(roulette.createBet(3, [1,2,3,4], {value: ethers.utils.parseEther("1")})).to.be.reverted
				})

			})



			describe("checkUpkeep", function () {

				// TEST FOR WITHOUT ANY BET
				
				// it("returns false if betsArr is empty", async () => {
				// 	await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
				// 	await network.provider.request({ method: "evm_mine", params: [] })

				// 	const { upkeepNeeded } = await roulette.callStatic.checkUpkeep("0x") // upkeepNeeded = (timePassed && hasPlayers && hasStartGameValue);

                //   	assert(!upkeepNeeded)

				// })



				// TEST FOR SMALL AMOUNT BET

				// it("returns false if startGameValue threshold not crossed", async () => {
				// 	await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
				// 	await network.provider.request({ method: "evm_mine", params: [] })

				// 	const { upkeepNeeded } = await roulette.callStatic.checkUpkeep("0x") // upkeepNeeded = (timePassed && hasPlayers && hasStartGameValue);

                //   	assert(!upkeepNeeded)

				// })


				// TEST FOR NOT ENOUGH TIME PASSED

				it("returns false if enough time hasn't passed", async () => {
					await network.provider.send("evm_increaseTime", [interval.toNumber() - 16]) // use a higher number here if this test fails
					await network.provider.request({ method: "evm_mine", params: [] })

					const { upkeepNeeded } = await roulette.callStatic.checkUpkeep("0x") // upkeepNeeded = (timePassed && hasPlayers && hasStartGameValue);

                  	assert(!upkeepNeeded)

				})

				// TEST FOR EVERYTHING IS OK

				it("returns true if startGameValue threshold IS crossed, betsArr length greater than 0 and enough time has passed", async () => {
					await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
					await network.provider.request({ method: "evm_mine", params: [] })

					const { upkeepNeeded } = await roulette.callStatic.checkUpkeep("0x") // upkeepNeeded = (timePassed && hasPlayers && hasStartGameValue);

                  	assert(upkeepNeeded)

				})

				
			})

			

			describe("performUpkeep", function () {
				beforeEach(async () => {
					await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
					await network.provider.request({ method: "evm_mine", params: [] })
					
				})

				it ("emits RequestedNumber event", async () => {
					await expect(roulette.performUpkeep("0x")).to.emit(
									roulette,
									"RequestedNumber"
								)

				})
				it ("emits GameStarted event", async () => {
					await expect(roulette.performUpkeep("0x")).to.emit(
									roulette,
									"GameStarted"
								)

				})
			

				it("starts a game", async () => {

					expect(await roulette.getNumberOfPlayers()).to.be.equal(10) // HERE equal2players

					

					const tx = await roulette.performUpkeep("0x")
					const txRec = await tx.wait(1) 
					const requestId = txRec.events[1].args.requestId

					assert.equal(requestId.toNumber(), 1)

					

					// await expect(await roulette.getNumberOfPlayers()).to.be.equal(0)
					// expect(await roulette.moneyInTheBank()).to.be.equal(0)

				})
			
				

			})



			
			describe("fulfillRandomWords", function () {

				beforeEach(async () => {
					await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
					await network.provider.request({ method: "evm_mine", params: [] })
				})
			
				it ("emits GameFinished event", async () => {
					const tx = await roulette.performUpkeep("0x")
					const txRec = await tx.wait(1) 
					const requestId = txRec.events[1].args.requestId
					assert.equal(requestId.toNumber(), 1) // requestId
					
					expect(vrfCoordinatorV2Mock.fulfillRandomWords(1, roulette.address)).to.emit(
						roulette,
						"GameFinished"
					)

					

				})
				
				it("Receiving random number; checking all bets for winning; payout winning bets to mapping; returning losing bets amounts to casino; refreshing betsArr, lastWinningNumber and moneyInTheBank; starting new spin; allowing to withdraw for players and owner", async () => {
					await expect(await roulette.getNumberOfPlayers()).to.be.equal(10) // HERE equal2players

					// const bet = await roulette.getFirstPlayer()
					// expect(bet[0]).to.be.equal(player.address)
					// expect(bet[1]).to.be.equal(ethers.utils.parseEther("1"))
					// expect(bet[2]).to.be.equal(5)
					// expect(bet[3].join()).to.be.equal("0")

					// const bet2 = await roulette.getSecondPlayer()
					// expect(bet2[0]).to.be.equal(player.address)
					// expect(bet2[1]).to.be.equal(ethers.utils.parseEther("1"))
					// expect(bet2[2]).to.be.equal(9)
					// expect(bet2[3].join()).to.be.equal("1")

					const tx = await roulette.performUpkeep("0x")
					const txRec = await tx.wait(1) 
					const requestId = txRec.events[1].args.requestId
					assert.equal(requestId.toNumber(), 1) // requestId
					
					await vrfCoordinatorV2Mock.fulfillRandomWords(1, roulette.address)  // requestId
					 
				
				
					expect(await roulette.moneyInTheBank()).to.be.equal(0)

					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("1"))

					expect(await roulette.getNumberOfPlayers()).to.be.equal(0) // HERE equal2players
					 
					expect(await roulette.lastWinningNumber()).to.be.equal(28)
					
					expect(await roulette.checkBalance(player.address)).to.be.equal(ethers.utils.parseEther("91")) //ethers.utils.parseEther("2")
					expect(await roulette.allPlayersWinnings()).to.be.equal(ethers.utils.parseEther("91")) 

					await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
					await network.provider.request({ method: "evm_mine", params: [] })


					// NEXT SPIN
					await roulette.createBet(9, [1], {value: ethers.utils.parseEther("1")})
					await expect(await roulette.getNumberOfPlayers()).to.be.equal(1)


					const tx2 = await roulette.performUpkeep("0x")
					const txRec2 = await tx2.wait(1) 
					const requestId2 = txRec2.events[1].args.requestId
					assert.equal(requestId2.toNumber(), 2)	

					await vrfCoordinatorV2Mock.fulfillRandomWords(2, roulette.address) 

					expect(await roulette.moneyInTheBank()).to.be.equal(0)
					expect(await roulette.lastWinningNumber()).to.be.equal(12)

					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("1"))
					expect(await roulette.checkBalance(player.address)).to.be.equal(ethers.utils.parseEther("93")) //ethers.utils.parseEther("2")
					expect(await roulette.allPlayersWinnings()).to.be.equal(ethers.utils.parseEther("93"))



					// Withdrawing for player
					expect(await roulette.getCurrentContractBalance()).to.be.equal(ethers.utils.parseEther("111"))

					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("1"))

					expect(await roulette.checkBalance(player.address)).to.be.equal(ethers.utils.parseEther("93")) 

					// // await roulette.withdrawPlayer()

					await expect(await roulette.withdrawPlayer()).to.changeEtherBalances([rouletteContract, player], [ethers.utils.parseEther("-93"), ethers.utils.parseEther("93")]);

					expect(await roulette.checkBalance(player.address)).to.be.equal(ethers.utils.parseEther("0"))

					expect(await roulette.getCurrentContractBalance()).to.be.equal(ethers.utils.parseEther("18"))
					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("1"))

					expect(await roulette.allPlayersWinnings()).to.be.equal(ethers.utils.parseEther("0")) 



					// Withdrawing for owner

					// await roulette.connect(deployer).withdrawOwner()	

					await expect(await roulette.connect(deployer).withdrawOwner()).to.changeEtherBalances([rouletteContract, deployer], [ethers.utils.parseEther("-1"), ethers.utils.parseEther("1")]);

					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("0"))

					expect(await roulette.getCurrentContractBalance()).to.be.equal(ethers.utils.parseEther("17"))





					// 3rd SPIN
					await roulette.createBet(8, [1], {value: ethers.utils.parseEther("100")}) // 2
					await roulette.createBet(7, [0], {value: ethers.utils.parseEther("5")}) // lost
					await roulette.createBet(6, [0], {value: ethers.utils.parseEther("5")}) // lost
					await roulette.createBet(6, [1], {value: ethers.utils.parseEther("5")}) // lost
					await roulette.createBet(5, [1], {value: ethers.utils.parseEther("5")}) // lost
					await roulette.createBet(5, [2], {value: ethers.utils.parseEther("5")}) // lost
			
					await expect(await roulette.getNumberOfPlayers()).to.be.equal(6)

					


					await network.provider.send("evm_increaseTime", [interval.toNumber() + 1])
					await network.provider.request({ method: "evm_mine", params: [] })


					const tx3 = await roulette.performUpkeep("0x")
					const txRec3 = await tx3.wait(1) 
					const requestId3 = txRec3.events[1].args.requestId
					assert.equal(requestId3.toNumber(), 3)	

					await vrfCoordinatorV2Mock.fulfillRandomWords(3, roulette.address) 

					expect(await roulette.lastWinningNumber()).to.be.equal(31)


					expect(await roulette.moneyInTheBank()).to.be.equal(0)


					expect(await roulette.getCurrentContractBalance()).to.be.equal(ethers.utils.parseEther("142"))

					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("25"))


					expect(await roulette.checkBalance(player.address)).to.be.equal(ethers.utils.parseEther("200")) 

					await expect(roulette.connect(deployer).withdrawOwner()).to.be.revertedWithCustomError(roulette,"Roulette__PleaseWaitForLiquidity")

					await expect(roulette.withdrawPlayer()).to.changeEtherBalances([rouletteContract, player], [ethers.utils.parseEther("-142"), ethers.utils.parseEther("142")]);

					expect(await roulette.getCurrentContractBalance()).to.be.equal(ethers.utils.parseEther("0"))

					expect(await roulette.checkBalance(player.address)).to.be.equal(ethers.utils.parseEther("58"))

					expect(await roulette.currentCasinoBalance()).to.be.equal(ethers.utils.parseEther("25"))
					
					expect(roulette.connect(deployer).ciao()).to.be.reverted
				})

				
			})
	  })
