// SPDX-License-Identifier: MIT
// coding by Richard Gottleber @ Chainlink
// photos by Liam Wong《TO:KY:OO》
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ChainlinkEmoji is ERC721, ERC721Enumerable, ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private tokenCounter;
  string[] metaURI = [
    "https://ipfs.filebase.io/ipfs/bafkreicaiuwhdukdtwf7ppu4xce4huhire33ftq6fjpq5zcb4c7pa5vzae",
    "https://ipfs.filebase.io/ipfs/bafkreictbsajvlgkldwymtxdwqsg4gvnqanmamxuz4f4q6wkqx4fp67tua",
    "https://ipfs.filebase.io/ipfs/bafybeicq6blefzova7lcgdf6acucvdpbrqrexc6257rzhdm5jjnperlm74",
    "https://ipfs.filebase.io/ipfs/bafkreicy2ubva7xzssrkdxknqzgjqvxfhl5ywu3r3ookqzgiegwgzjerxq",
    "https://ipfs.filebase.io/ipfs/bafkreibne5x47jyzgubhla57mwftllszgfumbetptz2ehh7lfep2uusadi",
    "https://ipfs.filebase.io/ipfs/bafkreif7wwuqt5vew5c6h7gn3nid7h6u434mvr53bdojubygsmj7i5pczm",
    "https://ipfs.filebase.io/ipfs/bafkreigf55oix65zkuc5zzfnqrzydhkd5mbkhiggxduhky3nvwv6fefphy"
  ];
  uint256 interval;
  uint256 lastTimeStamp;
  mapping (uint => uint) photoStage;
  mapping (uint => address) tokenBelong;

  constructor(uint256 _interval) ERC721("Tokyo Cyberpunk", "TCP") {
    interval = _interval;
    lastTimeStamp = block.timestamp;
  }

  // function checkUpkeep(bytes calldata /* checkData */) external view returns (bool upkeepNeeded, bytes memory /* performData */) {
  function checkUpkeep(bytes calldata /* checkData */) external view returns (bool upkeepNeeded) {
    upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
  }

  function performUpkeep(bytes calldata /* performData */) external {
    if ( (block.timestamp - lastTimeStamp) > interval ) {
      lastTimeStamp = block.timestamp;
      nextPhoto(0);
    }
  }

  // ipfs://bafkreig4rdq3nvyg2yra5x363gdo4xtbcfjlhshw63we7vtlldyyvwagbq
  function safeMint(address _to) public {
    // ID of the 1st NFT = 0
    uint256 tokenID = tokenCounter.current();
    _safeMint(_to, tokenID);
    _setTokenURI(tokenID, metaURI[0]);
    photoStage[tokenID] = 0;

    tokenCounter.increment();
  }

  function nextPhoto(uint256 _tokenID) public {
    require( photoStage[_tokenID] < 6);
    _setTokenURI(_tokenID, metaURI[photoStage[_tokenID] + 1]);
  }

  function _beforeTokenTransfer(address _from, address _to, uint256 _tokenID) internal override(ERC721, ERC721Enumerable) {
    super._beforeTokenTransfer(_from, _to, _tokenID);
  }

  function _burn(uint256 _tokenID) internal override(ERC721, ERC721URIStorage) {
    super._burn(_tokenID);
  }

  // return a URI where OpenSea can find the metadata
  function tokenURI(uint256 _tokenID) public view override(ERC721, ERC721URIStorage) returns (string memory) {
    return super.tokenURI(_tokenID);
  }

  function supportsInterface(bytes4 _interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
    return super.supportsInterface(_interfaceId);
  }
}