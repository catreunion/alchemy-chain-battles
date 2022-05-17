require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("solidity-coverage")

const { ALCHEMY_MUMBAI_URL, PRIVATE_KEY, REPORT_GAS, POLYGONSCAN_KEY } = process.env

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners()

  for (const account of accounts) {
    console.log(account.address)
  }
})

module.exports = {
  solidity: "0.8.7",
  networks: {
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts: PRIVATE_KEY !== undefined ? [`0x${PRIVATE_KEY}`] : []
    },
    mumbai: {
      url: ALCHEMY_MUMBAI_URL || "",
      accounts: PRIVATE_KEY !== undefined ? [`0x${PRIVATE_KEY}`] : []
    },
    localhost: { url: "http://127.0.0.1:8545" }
  },
  gasReporter: {
    enabled: REPORT_GAS !== undefined,
    currency: "USD"
  },
  etherscan: {
    apiKey: POLYGONSCAN_KEY
  }
}
