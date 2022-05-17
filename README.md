https://docs.alchemy.com/alchemy/road-to-web3/weekly-learning-challenges/3.-how-to-make-nfts-with-on-chain-metadata-hardhat-and-javascript

## Make NFTs with On-Chain Metadata

store our metadata on-chain

- develop a fully dynamic NFT with on-chain metadata that changes based on your interactions with it

- store NFTs metadata on chain

- process and store on-chain SVG images and JSON objects

- dynamic NFTs smart contract

- Polygon PoS - Lower Gas fees and Faster Transactions

- a decentralized EVM compatible scaling platform

- Layer 2 chains (L2)

- built on top of Ethereum to solve some of the issues characterizing it, ultimately relying on it to function

- dig deeper on

- Add Polygon Mumbai to Metamask Wallet

- mumbai.polygonscanner.com

- click "Add Polygon Network" button at the bottom of the page

- mumbaifaucet.com

faucet.polygon.technology

`mkdir ChainBattled`

`yarn add @openzeppelin/contract`

- create NFTs with on-chain metadata

- **generateCharacter** : generate and update the SVG image of our NFT on-chain

  - the "bytes" type, a dynamically sized array of up to 32 bytes where you can store strings, and integers

  - store the SVG code representing the image of our NFT transformed into an array of bytes

  - the abi.encodePacked() function : take one or more variables, and encode

  - specify to the browser that the Base64 string is an SVG image and how to open it

  - encode our svg into Base64

===

**getLevels** : get the current level of an NFT

```js

```

- metadata, including the image, is completely stored on chain

Click on the newly created app, copy the API Key, and paste the API as "TESTNET_RPC" value in the .env file we create above:

Open your Metamask wallet, click on the three dots menu > account details > and copy paste your private key as "PRIVATE_KEY" value in the .env.
Lastly, got on polygonscan.com ADD LINK, and create a new account:

We're simply calling the get.contractFactory from Hardhat ethers, passing the name of our Smart Contract. We then call the deploy() function and wait for it to be deployed logging the address.

Everything is wrapped into a try{} catch{} block to catch any error that might occur and print it out for debugging purposes.
Now that our deployment script is ready, it's time to compile and deploy our dynamic NFT smart contract on Polygon Mumbai.
Compile and Deploy the smart contract

[MINT] Interact with your Smart Contract Through Polygon Scan

Copy the smart contract address, go to testnet.opensea.com ADD LINK. and paste it into the search bar:
​
===

# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.js
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
