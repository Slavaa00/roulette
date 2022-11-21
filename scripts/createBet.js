import { ethers } from "hardhat" 

async function createBet() {
    const roulette = await ethers.getContract("Roulette")
    
    await roulette.createBet(5, [0], {value: ethers.utils.parseEther("0.000000001")})
    console.log("Entered!")
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})