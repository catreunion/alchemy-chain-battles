One of the greatest challenges for developers coming from a Web2 background is figuring out how to connect your smart contact to a frontend project and interact with it.

By building an NFT minter—a simple UI where you can input a link to your digital asset, a title, and a description —you'll learn how to:

As a prerequisite, you should have a beginner-level understanding of React—know how components, props, useState/useEffect, and basic function calling works. If you've never heard of any of those terms before, you may want to check out this Intro to React tutorial. For the more visual learners, we highly recommend this excellent Full Modern React Tutorial video series by Net Ninja.
Without further ado, let's get started!

const [walletAddress, setWallet] = useState("");
const [status, setStatus] = useState("");
const [name, setName] = useState("");
const [description, setDescription] = useState("");
const [url, setURL] = useState("");

status - a string that contains a message to display at the bottom of the UI
name - a string that stores the NFT's name
description - a string that stores the NFT's description
url - a string that is a link to the NFT's digital asset

Near the end of this file, we have the UI of our component. If you scan this code carefully, you'll notice that we update our url, name, and description state variables when the input in their corresponding text fields change.

You'll also see that connectWalletPressed and onMintPressed are called when the buttons with IDs mintButton and walletButton are clicked respectively.

```js
<button id="walletButton" onClick={connectWalletPressed}>
  {walletAddress.length > 0 ? "Connected: " + String(walletAddress).substring(0, 6) + "..." + String(walletAddress).substring(38) : <span>Connect Wallet</span>}
</button>
```

‍

Finally, let's address where is this Minter component added.

If you go to the App.js file, which is the main component in React that acts as a container for all other components, you'll see that our Minter component is injected on line 7.

In this tutorial, we'll only be editing the Minter.js file and adding files in our src folder.

Now that we understand what we're working with, let's set up our Ethereum wallet!

Because we want to prescribe to the M-V-C paradigm, we're going to create a separate file that contains our functions to manage the logic, data, and rules of our dApp, and then pass those functions to our frontend (our Minter.js component).

To do so, let's create a new folder called utils in your src directory and add a file called interact.js inside it, which will contain all of our wallet and smart contract interaction functions.

In our interact.js file, we will write a connectWallet function, which we will then import and call in our Minter.js component.

In your interact.js file, add the following

```js
export const connectWallet = async () => {
  if (window.ethereum) {
    try {
      const addressArray = await window.ethereum.request({
        method: "eth_requestAccounts"
      })
      const obj = {
        status: "👆🏽 Write a message in the text-field above.",
        address: addressArray[0]
      }
      return obj
    } catch (err) {
      return {
        address: "",
        status: "😥 " + err.message
      }
    }
  } else {
    return {
      address: "",
      status: (
        <span>
          <p>You must install Metamask, a virtual Ethereum wallet, in your browser.</p>
        </span>
      )
    }
  }
}
```

- calling window.ethereum.request({ method: "eth_requestAccounts" });

- window.ethereum is a global API injected by Metamask and other wallet providers that allows websites to request users' Ethereum accounts

- Most of the functions we write will be returning JSON objects that we can use to update our state variables and UI.

```js
import { useEffect, useState } from "react";
import { connectWallet } from "./utils/interact.js";

const Minter = (props) => {

const connectWalletPressed = async () => {
  const walletResponse = await connectWallet();
  setStatus(walletResponse.status);
  setWallet(walletResponse.address);
};
```

Notice how most of our functionality is abstracted away from our Minter.js component from the interact.js file? This is so we comply with the M-V-C paradigm!

In connectWalletPressed, we simply make an await call to our imported connectWallet function, and using its response, we update our status and walletAddress variables via their state hooks.

Now, let's save both files (Minter.js and interact.js) and test out our UI so far.

Open your browser on the http://localhost:3000/ page, and press the "Connect Wallet" button on the top right of the page.

If you have Metamask installed, you should be prompted to connect your wallet to your dApp. Accept the invitation to connect.

You should see that the wallet button now reflects that your address is connected! Yasssss 🔥

Next, try refreshing the page... this is strange. Our wallet button is prompting us to connect Metamask, even though it is already connected...

The problem on page reload
Don't worry though! We easily can fix that by implementing a function called getCurrentWalletConnected, which will check if an address is already connected to our dApp and update our UI accordingly!

The getCurrentWalletConnected function
In your interact.js file, add the following getCurrentWalletConnected function:

```js
export const getCurrentWalletConnected = async () => {
  if (window.ethereum) {
    try {
      const addressArray = await window.ethereum.request({
        method: "eth_accounts"
      })
      if (addressArray.length > 0) {
        return {
          address: addressArray[0],
          status: "👆🏽 Write a message in the text-field above."
        }
      } else {
        return {
          address: "",
          status: "🦊 Connect to Metamask using the top right button."
        }
      }
    } catch (err) {
      return {
        address: "",
        status: "😥 " + err.message
      }
    }
  } else {
    return {
      address: "",
      status: (
        <span>
          <p>
            <a target="_blank" href={`https://metamask.io/download.html`}>
              You must install Metamask, a virtual Ethereum wallet, in your browser.
            </a>
          </p>
        </span>
      )
    }
  }
}
```

The main difference is that instead of calling the method eth_requestAccounts, which opens Metamask for the user to connect their wallet, here we call the method eth_accounts, which simply returns an array containing the Metamask addresses currently connected to our dApp.

To see this function in action, let's call it in the useEffect function of our Minter.js component.

Like we did for connectWallet, we must import this function from our interact.js file into our Minter.js file like so:

import { useEffect, useState } from "react";
import {
connectWallet,
getCurrentWalletConnected //import here
} from "./utils/interact.js";

Now, we simply call it in our useEffect function:

useEffect(async () => {
const {address, status} = await getCurrentWalletConnected();
setWallet(address)
setStatus(status);
}, []);

Notice, we use the response of our call to getCurrentWalletConnected to update our walletAddress and status state variables.

Once you've added this code, try refreshing our browser window. The button should say that you're connected, and show a preview of your connected wallet's address - even after you refresh! 😅

Implement addWalletListener
The final step in our dApp wallet setup is implementing the wallet listener so our UI updates when our wallet's state changes, such as when the user disconnects or switches accounts.

In your Minter.js file, add a function addWalletListener that looks like the following:

```js
function addWalletListener() {
  if (window.ethereum) {
    window.ethereum.on("accountsChanged", (accounts) => {
      if (accounts.length > 0) {
        setWallet(accounts[0])
        setStatus("👆🏽 Write a message in the text-field above.")
      } else {
        setWallet("")
        setStatus("🦊 Connect to Metamask using the top right button.")
      }
    })
  } else {
    setStatus(
      <p>
        <a target="_blank" href={`https://metamask.io/download.html`}>
          You must install Metamask, a virtual Ethereum wallet, in your browser.
        </a>
      </p>
    )
  }
}
```

Let's quickly break down what's happening here:

First, our function checks if window.ethereum is enabled (i.e. Metamask is installed).

If it's not, we simply set our status state variable to a JSX string that prompts the user to install Metamask.
If it is enabled, we set up the listener window.ethereum.on("accountsChanged") on line 3 that listens for state changes in the Metamask wallet, which include when the user connects an additional account to the dApp, switches accounts, or disconnects an account. If there is at least one account connected, the walletAddress state variable is updated as the first account in the accounts array returned by the listener. Otherwise, walletAddress is set as an empty string.

```js
useEffect(async () => {
  const { address, status } = await getCurrentWalletConnected()
  setWallet(address)
  setStatus(status)

  addWalletListener()
}, [])
```

The text in the "Link to Asset", "Name", "Description" fields will comprise the different properties of our NFT's metadata.

REACT_APP_PINATA_KEY =
REACT_APP_PINATA_SECRET =

- In your utils folder, let's create another file called pinata.js

```js
require("dotenv").config()
const key = process.env.REACT_APP_PINATA_KEY
const secret = process.env.REACT_APP_PINATA_SECRET
const axios = require("axios")

export const pinJSONToIPFS = async (JSONBody) => {
  const url = `https://api.pinata.cloud/pinning/pinJSONToIPFS`
  //making axios POST request to Pinata ⬇️
  return axios
    .post(url, JSONBody, {
      headers: {
        pinata_api_key: key,
        pinata_secret_api_key: secret
      }
    })
    .then(function (response) {
      return {
        success: true,
        pinataUrl: "https://gateway.pinata.cloud/ipfs/" + response.data.IpfsHash
      }
    })
    .catch(function (error) {
      console.log(error)
      return {
        success: false,
        message: error.message
      }
    })
}
```

- axios, a promise based HTTP client for the browser and node.js

takes a JSONBody as its input and the Pinata api key and secret in its header, all to make a POST request to their pinJSONToIPFS API.

- pinataUrl = tokenURI

upload our NFT metadata to IPFS via our pinJSONToIPFS function

REACT_APP_PINATA_KEY =
REACT_APP_PINATA_SECRET =
REACT_APP_ALCHEMY_KEY = https://eth-ropsten.alchemyapi.io/v2/

Next let's go back to our interact.js file. At the top of the file, add the following code to import your Alchemy key from your .env file and set up your Alchemy Web3 endpoint:

- Alchemy Web3 is a wrapper around Web3.js, providing enhanced API methods and other crucial benefits

require('dotenv').config();
const alchemyKey = process.env.REACT_APP_ALCHEMY_KEY;
const { createAlchemyWeb3 } = require("@alch/alchemy-web3");
const web3 = createAlchemyWeb3(alchemyKey);
const contractABI = require('../contract-abi.json')
const contractAddress = "0x4C4a07F737Bf57F6632B6CAB089B78f62385aCaE";

Inside your interact.js file, let's define our function, mintNFT, which eponymously will mint our NFT.

Because we will be making numerous asynchronous calls (to Pinata to pin our metadata to IPFS, Alchemy Web3 to load our smart contract, and Metamask to sign our transactions), our function will also be asynchronous.

The three inputs to our function will be the url of our digital asset, name, and description. Add the following function signature below the connectWallet function:

export const mintNFT = async(url, name, description) => {
}

Input error handling
Naturally, it makes sense to have some sort of input error handling at the start of the function, so we exit this function if our input parameters aren't correct. Inside our function, let's add the following code:

export const mintNFT = async(url, name, description) => {
//error handling
if (url.trim() == "" || (name.trim() == "" || description.trim() == "")) {
return {
success: false,
status: "❗Please make sure all fields are completed before minting.",
}
}
}

Essentially, if any of the input parameters are an empty string, then we return a JSON object where the success boolean is false, and the status string relays that all fields in our UI must be complete.

- wrap metadata into a JSON object and upload it to IPFS via the pinJSONToIPFS

import {pinJSONToIPFS} from './pinata.js'

- format our url, name, and description parameters into a JSON object

- create a JSON object called metadata and then make a call to pinJSONToIPFS with this metadata parameter

```js
export const mintNFT = async (url, name, description) => {
  //error handling
  if (url.trim() == "" || name.trim() == "" || description.trim() == "") {
    return {
      success: false,
      status: "❗Please make sure all fields are completed before minting."
    }
  }

  //make metadata
  const metadata = new Object()
  metadata.name = name
  metadata.image = url
  metadata.description = description

  //make pinata call
  const pinataResponse = await pinJSONToIPFS(metadata)
  if (!pinataResponse.success) {
    return {
      success: false,
      status: "😢 Something went wrong while uploading your tokenURI."
    }
  }
  const tokenURI = pinataResponse.pinataUrl
}
```

Notice, we store the response of our call to pinJSONToIPFS(metadata) in the pinataResponse object. Then, we parse this object for any errors.

If there's an error, we return a JSON object where the success boolean is false and our status string relays that our call failed. Otherwise, we extract the pinataURL from the pinataResponse and store it as our tokenURIvariable.

Now it's time to load our smart contract using the Alchemy Web3 API that we initialized at the top of our file. Add the following line of code to the bottom of the mintNFT function to set the contract at the window.contract global variable:

```js
const transactionParameters = {
  to: contractAddress, // Required except during contract publications.
  from: window.ethereum.selectedAddress, // must match user's active address.
  data: window.contract.methods.mintNFT(window.ethereum.selectedAddress, tokenURI).encodeABI() //make call to NFT smart contract
}

try {
  const txHash = await window.ethereum.request({
    method: "eth_sendTransaction",
    params: [transactionParameters]
  })
  return {
    success: true,
    status: "✅ Check out your transaction on Etherscan: https://ropsten.etherscan.io/tx/" + txHash
  }
} catch (error) {
  return {
    success: false,
    status: "😥 Something went wrong: " + error.message
  }
}
```

If you're already familiar with Ethereum transactions, you'll notice that the structure is pretty similar to what you've seen.

First, we set up our transactions parameters.

to specifies the the recipient address (our smart contract)
from specifies the signer of the transaction (the user's connected address to Metamask: window.ethereum.selectedAddress)
data contains the call to our smart contract mintNFT method, which receives our tokenURI and the user's wallet address, window.ethereum.selectedAddress, as inputs
Then, we make an await call, window.ethereum.request, where we ask Metamask to sign the transaction. Notice, in this request, we're specifying our eth method (eth_SentTransaction) and passing in our transactionParameters. At this point, Metamask will open up in the browser, and prompt the user to sign or reject the transaction.

If the transaction is successful, the function will return a JSON object where the boolean success is set to true and the status string prompts the user to check out Etherscan for more information about their transaction.
If the transaction fails, the function will return a JSON object where the success boolean is set to false, and the status string relays the error message.
Altogether, our mintNFT function should look like this:

```js
export const mintNFT = async (url, name, description) => {
  //error handling
  if (url.trim() == "" || name.trim() == "" || description.trim() == "") {
    return {
      success: false,
      status: "❗Please make sure all fields are completed before minting."
    }
  }

  //make metadata
  const metadata = new Object()
  metadata.name = name
  metadata.image = url
  metadata.description = description

  //pinata pin request
  const pinataResponse = await pinJSONToIPFS(metadata)
  if (!pinataResponse.success) {
    return {
      success: false,
      status: "😢 Something went wrong while uploading your tokenURI."
    }
  }
  const tokenURI = pinataResponse.pinataUrl

  //load smart contract
  window.contract = await new web3.eth.Contract(contractABI, contractAddress) //loadContract();

  //set up your Ethereum transaction
  const transactionParameters = {
    to: contractAddress, // Required except during contract publications.
    from: window.ethereum.selectedAddress, // must match user's active address.
    data: window.contract.methods.mintNFT(window.ethereum.selectedAddress, tokenURI).encodeABI() //make call to NFT smart contract
  }

  //sign transaction via Metamask
  try {
    const txHash = await window.ethereum.request({
      method: "eth_sendTransaction",
      params: [transactionParameters]
    })
    return {
      success: true,
      status: "✅ Check out your transaction on Etherscan: https://ropsten.etherscan.io/tx/" + txHash
    }
  } catch (error) {
    return {
      success: false,
      status: "😥 Something went wrong: " + error.message
    }
  }
}
```

Open up your Minter.js file and update the import { connectWallet } from "./utils/interact.js"; line at the top to be:

import { connectWallet, mintNFT } from "./utils/interact.js";

Finally, implement the onMintPressed function to make await call to your imported mintNFT function and update the status state variable to reflect whether our transaction succeeded or failed:

```js
const onMintPressed = async () => {
  const { status } = await mintNFT(url, name, description)
  setStatus(status)
}
```

===

https://docs.alchemy.com/alchemy/road-to-web3/weekly-learning-challenges/3.-how-to-make-nfts-with-on-chain-metadata-hardhat-and-javascript

- Polygon PoS - Lower Gas fees and Faster Transactions

- built on the top of Ethereum

- **generateCharacter** : generate and update the SVG image of our NFT on-chain

  - the "bytes" type, a dynamically sized array of up to 32 bytes where you can store strings, and integers

  - store the SVG code representing the image of our NFT transformed into an array of bytes

  - the abi.encodePacked() function : take one or more variables, and encode

  - specify to the browser that the Base64 string is an SVG image and how to open it

  - encode our svg into Base64
