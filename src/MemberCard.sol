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
    Counters.Counter private _tokenIds;

    mapping(address => Attributes) public holdersAttributes;

    constructor(address _multisig) ERC721("MemberCard", "swissDAO") {
        _grantRole(DEFAULT_ADMIN_ROLE, _multisig);
    }

    modifier onlyDispatcher() {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "NOT_DEFAULT_ADMIN_ROLE"
        );
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
        holdersAttributes[msg.sender].experiencePoints = 0;
        holdersAttributes[msg.sender].activityPoints = 0;
        holdersAttributes[msg.sender].attendedEvents = 0;

        _tokenIds.increment();

        return newItemId;
    }

    function updateMembercardAttributes(string memory _name) public onlyOwner {
        // TODO add all attributes that can be updated through ui (name, cv, ...)
        holdersAttributes[msg.sender].name = _name;
    }

    function earnExperience(Event memory _event) public onlyDispatcher {
        Attributes storage _holdersAttributes = holdersAttributes[msg.sender];
        _holdersAttributes.experiencePoints++;
        _holdersAttributes.activityPoints++;
        _holdersAttributes.attendedEvents++;
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
