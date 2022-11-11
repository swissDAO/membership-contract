// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Script.sol";
import "../src/MemberCard.sol";

contract MemberCardScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new MemberCard(0x0000000000000000000000000000000000000000, "Joe Doe");
        vm.stopBroadcast();
    }
}
