// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./utils/LosslessDevEnvironment.t.sol";
import "../interfaces/ILosslessSecurityOracle.sol";


contract DefiExampleTests is LosslessDevEnvironment {
    RiskScores[] public newScores;

    /// @notice Test getting risk scores with subscription
    /// @notice should not revert
    function testAcceptableRisk() public {
        evm.prank(defiOwner);
        defi.setRiskApetite(12);
        evm.stopPrank();

        address user1 = address(10);
        newScores.push(RiskScores(user1, 10));

        evm.prank(oracle);
        securityOracle.setRiskScores(newScores);

        uint256 depositAmount = 100;
        evm.prank(erc20Admin);
        erc20Token.transfer(user1, depositAmount);

        evm.startPrank(user1);
        erc20Token.approve(address(defi), depositAmount);
        defi.supply(depositAmount);
        defi.redeem(depositAmount);
        evm.stopPrank();


        evm.prank(defiOwner);
        defi.setRiskApetite(12);
    }

        /// @notice Test getting risk scores with subscription
    /// @notice should not revert
    function testNonAcceptableRisk() public {
        evm.prank(defiOwner);
        defi.setRiskApetite(5);
        evm.stopPrank();

        address user1 = address(10);
        newScores.push(RiskScores(user1, 10));

        evm.prank(oracle);
        securityOracle.setRiskScores(newScores);

        uint256 depositAmount = 100;
        evm.prank(erc20Admin);
        erc20Token.transfer(user1, depositAmount);

        evm.startPrank(user1);
        erc20Token.approve(address(defi), depositAmount);
        evm.expectRevert("Too risky");
        defi.supply(depositAmount);
        evm.stopPrank();


        evm.prank(defiOwner);
        defi.setRiskApetite(12);
    }
}