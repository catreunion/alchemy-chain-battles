// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts@4.6.0/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AlchemyVitto is ERC721, ERC721Enumerable, ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
  uint256 MAX_SUPPLY = 100;

  constructor() ERC721("AlchemyVitto", "ALCHVT") {}

  // such as ipfs://bafkreig4rdq3nvyg2yra5x363gdo4xtbcfjlhshw63we7vtlldyyvwagbq
  function safeMint(address _to, string memory _tokenURI) public {
    _tokenIdCounter.increment();
    // ID of the 1st NFT = 1
    uint256 tokenId = _tokenIdCounter.current();

    require(tokenId <= MAX_SUPPLY, "sorry all NFTs have been minted");
    _safeMint(_to, tokenId);
    _setTokenURI(tokenId, _tokenURI);
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