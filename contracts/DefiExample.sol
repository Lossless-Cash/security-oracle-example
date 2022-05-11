// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./libraries/TransferHelper.sol";

import "./interfaces/ILosslessSecurityOracle.sol";

// DISCLAIMER: this code is not audited and 
// was written for demonstration purpose only

contract DefiExample is Ownable {
    ILssSecurityOracle public oracle;
    address public token;
    uint8 public riskApetite;

    constructor(ILssSecurityOracle _oracle) Ownable() {
        oracle = _oracle;
    }

    modifier securityCheck(address _account) {
        require(riskApetite > oracle.getRiskScore(_account), "Too risky");
        _;
    }

    function setRiskApetite(uint8 _riskApetite) public onlyOwner {
        riskApetite = _riskApetite;
    }

    function updateOracle(ILssSecurityOracle _oracle) public onlyOwner {
        oracle = _oracle;
    }

    function supply(uint256 _amount) public securityCheck(msg.sender) {
        // ...
        // your business logic
        // ...
        TransferHelper.safeTransferFrom(token, msg.sender, address(this), _amount);
    }

    function redeem(uint256 _amount) public securityCheck(msg.sender) {
        // ...
        // your business logic
        // ...
        TransferHelper.safeTransfer(token, msg.sender, _amount);
    }
}