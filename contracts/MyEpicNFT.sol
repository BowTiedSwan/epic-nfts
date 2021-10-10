// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.0;

// Import OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// Imported contracts are inherited so we have access to each contract methods
contract MyEpicNFT is ERC721URIStorage {
    // Functionality from OpenZeppelin to keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    //SVG generator code
    string svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    // Add arrays with random words to pick up from
    string[] firstWords = ["Banks", "HedgeFunds", "Clowns", "Politicians", "ThinkTanks", "Sociopaths"];
    string[] secondWords = ["Love", "Are", "Like", "WillBe", "Order", "ReallyLike"];
    string[] thirdWords = ["Scorts", "Zeros", "Clowns", "Clownmasks", "Dinosaurs", "Sociopaths"];

    // Declare background colors
    string[] colors = ["black", "#022F40", "#38AECC", "#0090C1", "#183446", "#046E8F"];

    // Set event to send information on minted
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // Create NFT object with a name and symbol as parameters
    constructor() ERC721 ("SwanNFT", "SWAN") {
        console.log("Behold my NFT contract. Woah!");
    }

    // Create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    // Pick random color for each mint
    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("COLOR", Strings.toString(tokenId))));
        rand = rand % colors.length;
        return colors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
    }


    // A function used by the user to get their NFT
    function makeAnEpicNFT() public {
        // Get current tokenId, stars at 0.
        uint256 newItemId = _tokenIds.current();

        // Randomly get one word from each array of
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));

        // Add random color
        string memory randomColor = pickRandomColor(newItemId);

        // Concatenate words together and add background color
        string memory finalSvg = string(abi.encodePacked(svgPartOne, randomColor, svgPartTwo, combinedWord, "</text></svg>"));

        // Get allJSON metadata in place and encode it in base64
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "An exclusive collection of random names, worth more than the banking industry", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );


        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        // Mint the NFT to the sender using msg.sender
        _safeMint(msg.sender, newItemId);

        // Set the NFT data
        _setTokenURI(newItemId, finalTokenUri);

        // Incremnt the counter once the next NFT is minted.
        _tokenIds.increment();

        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}