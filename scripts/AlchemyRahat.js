const hre = require("hardhat")

async function main() {
  await hre.run("compile")

  const AlchemyRahatFactory = await hre.ethers.getContractFactory("AlchemyRahat")
  const alchemyRahatInstance = await AlchemyRahatFactory.deploy()
  await alchemyRahatInstance.deployed()
  console.log("contract address:", alchemyRahatInstance.address)

  const [deployer] = await hre.ethers.getSigners()
  console.log("deployer address:", deployer.address)
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err)
    process.exit(1)
  })

// ❯ yarn hardhat run scripts/ChainBattles.js --network mumbai
// contract address: 0x893879E882763f781eB948FDB4561D02908D28aa
// ❯ yarn hardhat verify 0x893879E882763f781eB948FDB4561D02908D28aa --network mumbai
// https://mumbai.polygonscan.com/address/0x893879E882763f781eB948FDB4561D02908D28aa#code

// ❯ yarn hardhat run scripts/AlchemyRahat.js --network mumbai
// contract address: 0x5E8668153F30d57036416671E5E9E23F830d51cA
// deployer address: 0xA99B4eCA5929CF2999EBaf638357fc805795CBeA

// ❯ yarn hardhat verify 0x5E8668153F30d57036416671E5E9E23F830d51cA --network mumbai
// https://mumbai.polygonscan.com/address/0x5E8668153F30d57036416671E5E9E23F830d51cA#code

// ❯ yarn hardhat run scripts/AlchemyRahat.js --network mumbai
// contract address: 0xD36738601a475c912273B52B429348b488b90989
// deployer address: 0xA99B4eCA5929CF2999EBaf638357fc805795CBeA

// ❯ yarn hardhat verify 0xD36738601a475c912273B52B429348b488b90989 --network mumbai
// https://mumbai.polygonscan.com/address/0xD36738601a475c912273B52B429348b488b90989#code
