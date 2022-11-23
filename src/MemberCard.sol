// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Interfaces
import "./interfaces/IMemberCard.sol";

contract MemberCard is
    AccessControl,
    ERC721URIStorage,
    ERC721Enumerable,
    ERC721Burnable
{
    using Counters for Counters.Counter;

    enum TIERS {
        BRONZE,
        SILVER,
        GOLD,
        PLATINUM
    }

    struct Skills {
        string name;
    }

    struct Attributes {
        address holder;
        string name;
        uint256 mintDate;
        uint256 lastModified;
        Skills[] skills;
        TIERS tier;
    }

    mapping(address => mapping(uint256 => TIERS)) memberToTokenIdToTIER;

    mapping(address => Attributes) public holdersAttributes;

    uint256 experiencePointsOverall;
    uint256 numberOfAttendedEvents;

    Counters.Counter private _tokenIds;

    address public DISPATCHER_ADDRESS;

    constructor(address _dispatcher, string memory _name)
        ERC721("MemberCard", "SWSS")
    {
        Skills[] memory initalSkills;

        Attributes memory _holdersAttributes = Attributes(
            msg.sender,
            _name,
            block.timestamp,
            block.timestamp,
            initalSkills,
            TIERS.BRONZE
        );

        holdersAttributes[msg.sender] = _holdersAttributes;

        _grantRole(DEFAULT_ADMIN_ROLE, _dispatcher);
    }

    function mintMemberCard() public returns (uint256) {
        //require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "NOT_DISPATCHER");

        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, tokenURI(newItemId));

        memberToTokenIdToTIER[msg.sender][newItemId] = TIERS.BRONZE;

        _tokenIds.increment();

        return newItemId;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        return super._beforeTokenTransfer(from, to, amount, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        ERC721._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return
            "https://gateway.pinata.cloud/ipfs/QmRj91zjBaMjUHtxJnGh32UvM6Wtd4fXNXt8czABLuuCsE";
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // function updateSkills() public {
    //     ERC721 _memberCard = ERC721();
    // }

    // function earnExperience() public {
    //     ERC721 _memberCard = ERC721();
    // }
}
