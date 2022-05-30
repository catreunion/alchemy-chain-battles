// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract AlchemyRahat is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private tokenIdCounter;
  // associate all the methods inside the "Strings" library to the uint256 type
  using Strings for uint256;
  mapping(uint256 => uint256) private tokenIDtoLv;
  uint256 MAX_SUPPLY = 100;

  constructor() ERC721("AlchemyRahat", "ALCHRH") {}

  function mint() public {
    tokenIdCounter.increment();
    // ID of the 1st NFT = 1
    uint256 tokenId = tokenIdCounter.current();

    require(tokenId <= MAX_SUPPLY, "sorry all NFTs have been minted");
    _safeMint(msg.sender, tokenId);
    tokenIDtoLv[tokenId] = 0;
    _setTokenURI(tokenId, getTokenURI(tokenId));
  }

  function getTokenURI(uint256 _tokenID) public view returns (string memory) {
    bytes memory dataURI = abi.encodePacked(
      '{',
        '"name":"AlchemyRahat #', _tokenID.toString(), '",',
        '"description":"a battle of storing metadata on blockchain",',
        '"image":"', generateSVG(_tokenID), '"',
      '}'
    );

    return string( abi.encodePacked( "data:application/json;base64,", Base64.encode(dataURI) ) );
  }

  function generateSVG(uint256 _tokenID) public view returns (string memory) {
    bytes memory svg = abi.encodePacked(
      '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
      '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
      '<rect width="100%" height="100%" fill="black" />',
      '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Warrior", '</text>',
      '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ", getLv(_tokenID), '</text>',
      '</svg>'
    );

    return string( abi.encodePacked( "data:image/svg+xml;base64,", Base64.encode(svg) ) );
  }

  function getLv(uint256 _tokenID) public view returns (string memory) {
    uint256 lv = tokenIDtoLv[_tokenID];
    return lv.toString();
  }

  // train an NFT and raise its level by 1
  // update TokenURI to reflect the training
  function train(uint256 _tokenID) public {
    require(_exists(_tokenID), "the NFT you entered doesn't exist");
    require(ownerOf(_tokenID) == msg.sender, "you are NOT the owner of this NFT");
    uint256 currentLv = tokenIDtoLv[_tokenID];
    tokenIDtoLv[_tokenID] = currentLv + 1;
    _setTokenURI(_tokenID, getTokenURI(_tokenID));
  }
}