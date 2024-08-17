// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

// import {PriceConverter} from "../src/PriceConverter.sol";

contract FundMeTest is Test {
    FundMe public fundMe;
    address USER = makeAddr("user");
    uint256 constant fundedEth = 7 ether;
    uint256 constant startingBalance = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, startingBalance);
    }

    function testMinimumUsdIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testCorrectOwner() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // function testPriceFeedCorrectVersion() public {
    //     uint256 version = fundMe.getVersion();
    //     assertEq(version, 4);
    // }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundPassUpdateDataStructures() public {
        vm.prank(USER);
        fundMe.fund{value: fundedEth}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, fundedEth);
    }

    function testAddsFundedArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: fundedEth}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwnerCanWithraw() public {
        vm.prank(USER);
        fundMe.fund{value: fundedEth}();

        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }
}
