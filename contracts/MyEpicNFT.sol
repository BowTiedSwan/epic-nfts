// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Imported contracts are inherited so we have access to each contract methods
contract MyEpicNFT is ERC721URIStorage {
    // Functionality from OpenZeppelin to keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Create NFT object with a name and symbol as parameters
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("Behold my NFT contract. Woah!");
    }

    // A function used by the user to get their NFT
    function makeAnEpicNFT() public {
        // Get current tokenId, stars at 0.
        uint256 newItemId = _tokenIds.current();

        // Mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        // Set the NFT data
        _setTokenURI(newItemId, "A special edition, one of a kind!");
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);


        // Incremnt the counter once the next NFT is minted.
        _tokenIds.increment();
    }
}