const hre = require("hardhat")

async function main() {
  await hre.run("compile")

  const AlchemyVittoFactory = await hre.ethers.getContractFactory("AlchemyVitto")
  const alchemyVittoInstance = await AlchemyVittoFactory.deploy()
  await alchemyVittoInstance.deployed()
  console.log("contract address:", alchemyVittoInstance.address)

  const [deployer] = await hre.ethers.getSigners()
  console.log("deployer address:", deployer.address)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err)
    process.exit(1)
  })

// ❯ yarn hardhat verify 0x036A8366e332A20AE55807DE76544DE8e52a7c88 --network ropsten
// https://ropsten.etherscan.io/address/0x036A8366e332A20AE55807DE76544DE8e52a7c88#code

// ❯ yarn hardhat run scripts/AlchemyVitto.js --network mumbai
// contract address: 0x309c5b7c9bA8f28F0Aa4CBC7928AB315783B6daa
// deployer address: 0xA99B4eCA5929CF2999EBaf638357fc805795CBeA

// ❯ yarn hardhat verify 0x309c5b7c9bA8f28F0Aa4CBC7928AB315783B6daa --network mumbai
// https://mumbai.polygonscan.com/address/0x309c5b7c9bA8f28F0Aa4CBC7928AB315783B6daa#code
