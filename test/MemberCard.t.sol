// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "../src/MemberCard.sol";

contract MemberCardTest is Test {
    MemberCard public memberCard;

    function setUp() public {
        memberCard = new MemberCard(0x0000000000000000000000000000000000000000);
    }
}
