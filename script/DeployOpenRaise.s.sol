// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/EthOpenRaise.sol";

contract OpenRaiseDeployScript is Script {
    uint BSC_MIN = 0.84 ether;
    uint BSC_MAX = 8.4 ether;

    uint ETH_MIN = 0.12 ether;
    uint ETH_MAX = 1.2 ether;

    uint PLS_MIN = 2_000_000 ether;
    uint PLS_MAX = 20_000_000 ether;

    function run() public {
        uint min;
        uint max;
        string memory raiseName;
        if (block.chainid == 56) {
            raiseName = "DRX-BSC";
            min = BSC_MIN;
            max = BSC_MAX;
        } else if (block.chainid == 1) {
            raiseName = "DRX-ETH";
            min = ETH_MIN;
            max = ETH_MAX;
        } else if (block.chainid == 369) {
            raiseName = "DRX-PLS";
            min = PLS_MIN;
            max = PLS_MAX;
        } else {
            revert("Unsupported chain");
        }
        vm.broadcast();
        new EthOpenRaise(raiseName, min, max);
    }
}
