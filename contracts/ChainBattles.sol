// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // implement the toString() function
import "@openzeppelin/contracts/utils/Base64.sol"; // handle base64 data 

contract ChainBattles is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private totalToken;
  // associate all the methods in the "Strings" library to the uint256 type
  using Strings for uint256;
  mapping(uint256 => uint256) private tokenIDtoLv; // store the levels of all NFTs

  constructor() ERC721("Chain Battles", "CBTLS") {}

  function mint() public {
    totalToken.increment();
    uint256 newItemID = totalToken.current();
    _safeMint(msg.sender, newItemID);

    tokenIDtoLv[newItemID] = 0;
    _setTokenURI(newItemID, getTokenURI(newItemID));
  }

  function getTokenURI(uint256 _tokenID) public view returns (string memory) {
    bytes memory dataURI = abi.encodePacked(
      '{',
        '"name":"Chain Battles #', _tokenID.toString(), '",',
        '"description":"Battles on chain",',
        '"image":"', generateCharacter(_tokenID), '"',
      '}'
    );

    return string( abi.encodePacked( "data:application/json;base64,", Base64.encode(dataURI) ) );
  }

  function generateCharacter(uint256 _tokenID) public view returns (string memory) {
    bytes memory svg = abi.encodePacked(
      '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
      '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
      '<rect width="100%" height="100%" fill="black" />',
      '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Warrior", '</text>',
      '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ", getLevels(_tokenID), '</text>',
      '</svg>'
    );

    return string( abi.encodePacked( "data:image/svg+xml;base64,", Base64.encode(svg) ) );
  }

  function getLevels(uint256 _tokenID) public view returns (string memory) {
    uint256 levels = tokenIDtoLv[_tokenID];
    return levels.toString();
  }

  function train(uint256 _tokenID) public {
    require(_exists(_tokenID), "the NFT you entered doesn't exist");
    require(ownerOf(_tokenID) == msg.sender, "you are NOT the owner of this NFT");
    uint256 currentLevel = tokenIDtoLv[_tokenID];
    tokenIDtoLv[_tokenID] = currentLevel + 1;
    _setTokenURI(_tokenID, getTokenURI(_tokenID));
  }
}