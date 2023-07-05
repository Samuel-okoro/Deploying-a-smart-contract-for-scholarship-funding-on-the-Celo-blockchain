// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Scholarship is Ownable {
    uint256 public scholarshipAmount;
    uint256 public applicationDeadline;
    mapping(address => bool) public applicants;
    mapping(address => bool) public recipients;
    IERC20 public CUSDToken;

    event ApplicationSubmitted(address indexed applicant);
    event ScholarshipAwarded(address indexed recipient, uint256 amount);

    constructor(
        uint256 _scholarshipAmount,
        uint256 _applicationDeadline,
        address _CUSDTokenAddress
    ) {
        scholarshipAmount = _scholarshipAmount;
        applicationDeadline = _applicationDeadline;
        CUSDToken = IERC20(_CUSDTokenAddress);
    }

    function applyForScholarship() public {
        require(!applicants[msg.sender], "You have already applied");
        require(
            block.timestamp <= applicationDeadline,
            "Application deadline has passed"
        );

        applicants[msg.sender] = true;
        emit ApplicationSubmitted(msg.sender);
    }

    function awardScholarship(address recipient) public onlyOwner {
        require(applicants[recipient], "The recipient has not applied");
        require(
            !recipients[recipient],
            "The recipient has already been awarded the scholarship"
        );

        recipients[recipient] = true;
        require(
            CUSDToken.balanceOf(address(this)) >= scholarshipAmount,
            "Insufficient contract balance"
        );
        CUSDToken.transfer(recipient, scholarshipAmount);
        emit ScholarshipAwarded(recipient, scholarshipAmount);
    }

    function depositTokens(uint256 amount) public onlyOwner {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(
            CUSDToken.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );
    }
}
