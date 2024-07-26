// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

// import {PriceConverter} from "../src/PriceConverter.sol";

contract FundMeTest is Test {
    FundMe public fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumUsd() public {
        assertEq(fundMe.MINIMUM_USD(), 4e18);
    }
}
