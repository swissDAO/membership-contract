// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;

import "forge-std/Script.sol";
import "../src/MemberCard.sol";

contract MemberCardScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new MemberCard(0x0000000000000000000000000000000000000000);
        vm.stopBroadcast();
    }
}
