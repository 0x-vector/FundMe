// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_VALUE = 2000e8;

    struct NetworkConfig {
        address priceFeed; // Eth/Usd priceFeed.
    }

    // ====== CONSTRUCTOR FUNCTION =======
    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        }
        // else if (block.chainid == 42) {
        //     activeNetworkConfig = getOptimismConfig();
        // } else if (block.chainid == 421611) {
        //     activeNetworkConfig = getArbitriumConfig();
        // }
        else {
            activeNetworkConfig = getOrCreateAnvilConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }

    // function getOptimismConfig() public pure returns (NetworkConfig memory) {
    //     NetworkConfig memory optimismConfig = NetworkConfig({
    //         priceFeed: 0x0D276FC14719f9292D5C1eA2198673d1f4269246
    //     });
    //     return optimismConfig;
    // }

    // function getArbitriumConfig() public pure returns (NetworkConfig memory) {
    //     NetworkConfig memory arbitriumConfig = NetworkConfig({
    //         priceFeed: 0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6
    //     });
    //     return arbitriumConfig;
    // }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_VALUE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
    }
}
