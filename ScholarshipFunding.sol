// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract ScholarshipFunding {
    address public owner;
    uint public totalFunds;
    address internal cUsdTokenAddress =
        0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    
    struct Scholarship {
        uint amount;
        uint minimumGPA;
        uint graduationYear;
    }
    
    mapping(address => Scholarship) public scholarships;
    
    event ScholarshipGranted(address indexed recipient, uint amount);
    
    constructor() {
        owner = msg.sender;
        totalFunds = 0;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this action.");
        _;
    }
    
    function allocateFunds(uint _amount) public onlyOwner {
        require(_amount > 0, "Funds amount should be greater than zero.");
        totalFunds += _amount;
    }
    
    function createScholarship(address _recipient, uint _amount, uint _minimumGPA, uint _graduationYear) public onlyOwner {
        require(_recipient != address(0), "Invalid recipient address.");
        require(_amount > 0, "Scholarship amount should be greater than zero.");
        scholarships[_recipient] = Scholarship(_amount, _minimumGPA, _graduationYear);
    }
    
    function checkEligibility(address _recipient, uint _gpa, uint _graduationYear) public view returns (bool) {
        Scholarship storage scholarship = scholarships[_recipient];
        return (_gpa >= scholarship.minimumGPA && _graduationYear >= scholarship.graduationYear);
    }
    
    function disburseScholarship(address _recipient) public {
        Scholarship storage scholarship = scholarships[_recipient];
        require(scholarship.amount > 0, "No scholarship available for the recipient.");
        require(checkEligibility(_recipient, getGPA(_recipient), getGraduationYear(_recipient)), "Recipient is not eligible for the scholarship.");
        
        uint amount = scholarship.amount;
        scholarship.amount = 0;
        totalFunds -= amount;
        emit ScholarshipGranted(_recipient, amount);
    }
    
    // Helper functions to fetch recipient's GPA and graduation year from an external system
    
    function getGPA(address _recipient) private view returns (uint) {
        // Call external system or API to fetch the recipient's GPA
        // Return the GPA value
    }
    
    function getGraduationYear(address _recipient) private view returns (uint) {
        // Call external system or API to fetch the recipient's graduation year
        // Return the graduation year value
    }
}

