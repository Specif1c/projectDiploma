
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/Counters.sol";
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

// contract RealEstate is ERC721, ERC721URIStorage, ERC721Enumerable {
//     using Counters for Counters.Counter;
//     Counters.Counter private _tokenIds;

//     event NewRealEstateToken(address indexed owner, uint256 indexed tokenId, string tokenURI);

//     constructor() ERC721("Real Estate", "REAL") {}

//     /// @notice Before token transfer hook to manage token enumeration
//     /// @dev See {ERC721Enumerable-_beforeTokenTransfer} and {ERC721-_beforeTokenTransfer}.
//     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
//         internal
//         override(ERC721, ERC721Enumerable)
//     {
//         super._beforeTokenTransfer(from, to, tokenId);
//     }

//     /// @notice Burns a token, cleaning up metadata and enumerable information
//     /// @dev See {ERC721URIStorage-_burn} and {ERC721-_burn}.
//     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
//         super._burn(tokenId);
//     }

//     /// @notice Returns the URI for a token ID
//     /// @dev See {ERC721URIStorage-tokenURI} and {ERC721-tokenURI}.
//     function tokenURI(uint256 tokenId)
//         public
//         view
//         override(ERC721, ERC721URIStorage)
//         returns (string memory)
//     {
//         return super.tokenURI(tokenId);
//     }

//     /// @notice Indicates whether a given interface is supported
//     /// @dev See {ERC721-supportsInterface} and {ERC721Enumerable-supportsInterface}.
//     function supportsInterface(bytes4 interfaceId)
//         public
//         view
//         override(ERC721, ERC721Enumerable)
//         returns (bool)
//     {
//         return super.supportsInterface(interfaceId);
//     }

//     /// @notice Mints a new token with a given URI.
//     /// @param uri The URI of the token to be minted.
//     /// @return newItemId The new token ID that is minted.
//     function mint(string memory uri) public returns (uint256) {
//         _tokenIds.increment();

//         uint256 newItemId = _tokenIds.current();
//         _mint(msg.sender, newItemId);
//         _setTokenURI(newItemId, uri);

//         emit NewRealEstateToken(msg.sender, newItemId, uri);

//         return newItemId;
//     }

//     /// @notice Returns the total supply of tokens
//     /// @dev Overridden to use the counter directly.
//     function totalSupply() public view override returns (uint256) {
//         return _tokenIds.current();
//     }
// }
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract RealEstate is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Real Estate", "REAL") {}

    function mint(string memory tokenURI) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds.current();
    }
}