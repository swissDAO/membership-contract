// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

// Interfaces
import "./interfaces/IMemberCard.sol";
import "./Dispatcher.sol";

contract MemberCard is
    IMemberCard,
    AccessControl,
    Ownable,
    ERC721URIStorage,
    ERC721Enumerable,
    ERC721Burnable
{
    using Counters for Counters.Counter;

    uint256 experiencePointsOverall;
    uint256 numberOfAttendedEvents;

    Counters.Counter private _tokenIds;

    address public DISPATCHER_ADDRESS;

    mapping(address => Attributes) public holdersAttributes;

    constructor(address _dispatcher) ERC721("MemberCard", "swissDAO") {
        DISPATCHER_ADDRESS = _dispatcher;

        _grantRole(DEFAULT_ADMIN_ROLE, _dispatcher);
    }

    modifier onlyDispatcher() {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "NOT_DISPATCHER");
        _;
    }

    function mint(string memory _name) public returns (uint256) {
        require(balanceOf(msg.sender) == 0, "You already have a Membership");

        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, tokenURI(newItemId));

        holdersAttributes[msg.sender].holder = msg.sender;
        holdersAttributes[msg.sender].name = _name;
        holdersAttributes[msg.sender].mintDate = block.timestamp;
        holdersAttributes[msg.sender].lastModified = block.timestamp;
        holdersAttributes[msg.sender].timeUntilDegradation =
            block.timestamp +
            90 days;
        holdersAttributes[msg.sender].tier = TIERS.BRONZE;

        _tokenIds.increment();

        return newItemId;
    }

    function updateMembercardAttributes(string memory _name) public onlyOwner {
        // TODO add all attributes that can be updated through ui (name, cv, ...)
        holdersAttributes[msg.sender].name = _name;
    }

    function earnExperience(Event memory _event) public onlyDispatcher {
        Attributes storage _holdersAttributes = holdersAttributes[msg.sender];

        Skill memory skill;

        for (uint256 x = 0; x < _holdersAttributes.skills.length; x++) {
            for (uint256 y = 0; y < _event.skills.length; y++) {
                if (
                    keccak256(
                        abi.encodePacked(_holdersAttributes.skills[x].name)
                    ) == keccak256(abi.encodePacked(_event.skills[y].name))
                ) {
                    skill = _holdersAttributes.skills[x];
                } else {}
            }

            _holdersAttributes.skills.push(skill);
        }
    }

    function updateTier() internal onlyDispatcher {
        Attributes storage _holdersAttributes = holdersAttributes[msg.sender];
        _holdersAttributes.tier = getNextTierLevel(TIERS.BRONZE, false);
    }

    function updateSkills(Skill memory _skill) internal onlyDispatcher {
        Attributes storage _holdersAttributes = holdersAttributes[msg.sender];
        _holdersAttributes.skills.push(_skill);
    }

    function updateBadges(Badge memory _badge) internal onlyDispatcher {
        Attributes storage _holdersAttributes = holdersAttributes[msg.sender];
        _holdersAttributes.badges.push(_badge);
    }

    function getNextTierLevel(TIERS _newTier, bool isDegrading)
        internal
        returns (TIERS)
    {
        for (uint256 index = 1; index < 4; index++) {
            if (isDegrading) {
                index--;
            }

            return TIERS.BRONZE;
        }
    }

    // Override functions
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
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
        return "ipfs://QmRj91zjBaMjUHtxJnGh32UvM6Wtd4fXNXt8czABLuuCsE";
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
}
