// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address pandit = makeAddr("pandit");
    address pranav = makeAddr("pranav");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(pandit, STARTING_BALANCE);
    }

    function testPanditBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(pandit));
    }

    function testAllowanceWorks() public {
        // transferfrom()
        uint256 initialAllowance = 1000;

        // pandit approves pranav to spend tokens on him behalf
        vm.prank(pandit);
        ourToken.approve(pranav, initialAllowance);

        uint256 transferAmount = 500;
        vm.prank(pranav);
        ourToken.transferFrom(pandit, pranav, transferAmount);

        assertEq(ourToken.balanceOf(pranav), transferAmount);
        assertEq(ourToken.balanceOf(pandit), STARTING_BALANCE - transferAmount);
    }
}
