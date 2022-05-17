const hre = require("hardhat")

async function main() {
  await hre.run("compile")
  const ChainBattlesFactory = await hre.ethers.getContractFactory("ChainBattles")
  const chainBattlesInstance = await ChainBattlesFactory.deploy()
  await chainBattlesInstance.deployed()
  console.log("contract address:", chainBattlesInstance.address)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.err(err)
    process.exit(1)
  })

// ❯ yarn hardhat run scripts/ChainBattles.js --network mumbai
// contract address: 0x2eEe8E2A8c55B6555Da9320991f750D5AdCfF0d2

// ❯ yarn hardhat verify 0x2eEe8E2A8c55B6555Da9320991f750D5AdCfF0d2 --network mumbai
// https://mumbai.polygonscan.com/address/0x2eEe8E2A8c55B6555Da9320991f750D5AdCfF0d2#code
