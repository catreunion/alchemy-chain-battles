// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

// import functions from ./KeeperBase.sol & ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract BullBear is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable, KeeperCompatibleInterface  {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
  uint256 MAX_SUPPLY = 100;
  AggregatorV3Interface public priceFeed;
  int public currentPrice;

  // interval in seconds and a timestamp to slow execution of Upkeep
  uint public /* immutable */ interval; 
  uint public lastTimeStamp;
    
  // IPFS URIs for the dynamic nft graphics/metadata.
  // You should upload the contents of the /ipfs folder to your own node for development.
  string[] bullUrisIpfs = [
"https://ipfs.io/ipfs/QmRXyfi3oNZCubDxiVFre3kLZ8XeGt6pQsnAQRZ7akhSNs?filename=gamer_bull.json",
"https://ipfs.io/ipfs/QmRJVFeMrtYS2CUVUM2cHJpBV5aX2xurpnsfZxLTTQbiD3?filename=party_bull.json",
"https://ipfs.io/ipfs/QmdcURmN1kEEtKgnbkVJJ8hrmsSWHpZvLkRgsKKoiWvW9g?filename=simple_bull.json" ];

  string[] bearUrisIpfs = [
"https://ipfs.io/ipfs/Qmdx9Hx7FCDZGExyjLR6vYcnutUR8KhBZBnZfAPHiUommN?filename=beanie_bear.json",
"https://ipfs.io/ipfs/QmTVLyTSuiKGUEmb88BgXG3qNC8YgpHZiFbjHrXKH3QHEu?filename=coolio_bear.json",
"https://ipfs.io/ipfs/QmbKhBXVWmwrYsTPFYfroR2N7NAekAMxHUVg2CWks7i9qj?filename=simple_bear.json" ];

  // a MockPriceFeed.sol contract address : 0xD753A1c190091368EaC67bbF3Ee5bAEd265aC420
  // price feed contract address of BTC/USD on Rinkeby
  // https://rinkeby.etherscan.io/address/0xECe365B379E1dD183B20fc5f022230C044d51404
  constructor(uint _updateInterval, address _priceFeed) ERC721("Bull&Bear", "BBTK") {
    interval = _updateInterval; // keeper update interval
    lastTimeStamp = block.timestamp;
    priceFeed = AggregatorV3Interface(_priceFeed);
    currentPrice = getLatestPrice();
  }

  event TokensUpdated(string marketTrend);

  function safeMint(address _to) public  {
    uint tokenId = _tokenIdCounter.current();
    require(tokenId <= MAX_SUPPLY, "sorry all NFTs have been minted");
    _safeMint(_to, tokenId);
    string memory defaultUri = bullUrisIpfs[0];
    _setTokenURI(tokenId, defaultUri);
    console.log("minted token: ", tokenId);
    console.log("token url: ", defaultUri);
    _tokenIdCounter.increment();
  }

  function checkUpkeep(bytes calldata /* checkData */ ) external view override returns (bool upkeepNeeded, bytes memory /*performData */ ) {
    upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
  }

  function performUpkeep(bytes calldata /* performData */ ) external override {
    if ((block.timestamp - lastTimeStamp) > interval ) {
      lastTimeStamp = block.timestamp;         
      int latestPrice =  getLatestPrice(); 
    
      if (latestPrice == currentPrice) {
        console.log("NO CHANGE -> returning!");
        return;
      }

      if (latestPrice < currentPrice) {
        console.log("bear time");
        updateAllTokenUris("bear");
      } else {
        console.log("bull time");
        updateAllTokenUris("bull");
      }

      currentPrice = latestPrice;
    } else {
      console.log("INTERVAL NOT UP!");
      return;
    }
  }

  function getLatestPrice() public view returns (int) {
    (
      /*uint80 roundID*/,
      int price,
      /*uint startedAt*/,
      /*uint timeStamp*/,
      /*uint80 answeredInRound*/
    ) = priceFeed.latestRoundData();

    return price; // example price returned 3034715771688
  }
  
  function updateAllTokenUris(string memory trend) internal {
    if (compareStrings("bear", trend)) {
      console.log(" UPDATING TOKEN URIS WITH ", "bear", trend);
      for (uint i = 0; i < _tokenIdCounter.current(); i++) {
        _setTokenURI(i, bearUrisIpfs[0]);
      } 
        
    } else {     
      console.log(" UPDATING TOKEN URIS WITH ", "bull", trend);
      for (uint i = 0; i < _tokenIdCounter.current(); i++) {
        _setTokenURI(i, bullUrisIpfs[0]);
      }  
    }   
    emit TokensUpdated(trend);
  }

  function compareStrings(string memory _a, string memory _b) internal pure returns (bool) {
    return ( keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b)) );
  }

  function setPriceFeed(address _newFeed) public onlyOwner {
    priceFeed = AggregatorV3Interface(_newFeed);
  }
  
  function setInterval(uint256 _newInterval) public onlyOwner {
    interval = _newInterval;
  }

  function _beforeTokenTransfer(address _from, address _to, uint256 _tokenId) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(_from, _to, _tokenId);
  }

  function _burn(uint256 _tokenId) internal override(ERC721, ERC721URIStorage) {
    super._burn(_tokenId);
  }

  // for OpenSea to show the metadata
  function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return super.tokenURI(_tokenId);
  }

  function supportsInterface(bytes4 _interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(_interfaceId);
  }
}