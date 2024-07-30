// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// import {PriceConverter} from "../src/PriceConverter.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumUsdIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testCorrectOwner() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedCorrectVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }
}
