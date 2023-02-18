// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

interface IMemberCard {
    enum TIERS {
        BRONZE,
        SILVER,
        GOLD,
        PLATINUM
    }

    struct Skill {
        string name;
        uint256 xp;
        uint256 level;
    }

    struct Badge {
        string name;
        address token;
        uint256 level;
        uint256 xp;
    }

    struct Attributes {
        address holder;
        string name;
        uint256 mintDate;
        uint256 lastModified;
        uint256 experiencePoints;
        uint256 activityPoints;
        uint256 attendedEvents;
    }

    struct Event {
        string title;
        uint256 id;
        uint256 timestampOfEvent;
        address owner;
        uint16 maxAttendees;
        bytes32[] hashes;
        uint256 attendeesXp;
        Skill[] skills;
    }
}
