// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract OnChainNFT is ERC721, Ownable {
    using Strings for uint256;

    uint256 private _tokenIdCounter;
    //uint256 owner;

    constructor() ERC721("OliveNFT", "NFT") Ownable(msg.sender) {}

    function mint() public {
        _tokenIdCounter += 1;
        _safeMint(msg.sender, _tokenIdCounter);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "Token does not exist");

        string memory name = string(
            abi.encodePacked("OliveNFT #", tokenId.toString())
        );
        string memory description = "This is an on-chain NFT";
        string memory image = generateBase64Image();

        string memory json = string(
            abi.encodePacked(
                '{"name":"',
                name,
                '",',
                '"description":"',
                description,
                '",',
                '"image":"',
                image,
                '"}'
            )
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(bytes(json))
                )
            );
    }

    function generateBase64Image() internal pure returns (string memory) {
        string memory svg = string(
            abi.encodePacked(
                "<svg width='200' height='60' xmlns='http://www.w3.org/2000/svg'>",
                "<defs>",
                "<linearGradient id='gradient' x1='0%' x2='100%' y1='0%' y2='0%'>",
                "<stop offset='0%' stop-color='#0044ff'/>",
                "<stop offset='100%' stop-color='#00aaff'/>",
                "</linearGradient>",
                "</defs>",
                "<rect width='100%' height='100%' rx='10' ry='10' fill='url(#gradient)'/>",
                "<text x='50%' y='50%' font-size='21px' font-family='Arial, sans-serif' ",
                "paint-order='stroke' stroke='white' stroke-width='2px' fill='black' ",
                "text-anchor='middle' dominant-baseline='central'>OliveNFT</text>",
                "</svg>"
            )
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(bytes(svg))
                )
            );
    }
}
