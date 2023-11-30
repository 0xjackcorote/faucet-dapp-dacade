// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address payable public owner;
    IERC20 public token;

    uint256 public withdrawalAmount = 50 * (10**18);
    uint256 public lockTime = 1 days;

    event Withdrawal(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    mapping(address => uint256) lastAccessTime;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
        owner = payable(msg.sender);
    }

    function requestTokens() public {
        require(msg.sender != address(0), "Invalid request address");
        require(token.balanceOf(address(this)) >= withdrawalAmount, "Insufficient balance in faucet");
        require(block.timestamp >= lastAccessTime[msg.sender] + lockTime, "Withdrawal not allowed yet");

        // Prevent reentrancy attacks
        uint256 currentBalance = token.balanceOf(address(this));
        require(currentBalance >= withdrawalAmount, "Insufficient balance in faucet");

        lastAccessTime[msg.sender] = block.timestamp;

        // Transfer after state changes to prevent reentrancy
        require(token.transfer(msg.sender, withdrawalAmount), "Token transfer failed");

        emit Withdrawal(msg.sender, withdrawalAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawalAmount(uint256 amount) public onlyOwner {
        withdrawalAmount = amount * (10**18);
    }

    function setLockTime(uint256 amountInDays) public onlyOwner {
        // Validate lock time duration
        require(amountInDays > 0, "Lock time must be greater than 0");
        lockTime = amountInDays * 1 days;
    }

    function withdraw() external onlyOwner {
        uint256 currentBalance = token.balanceOf(address(this));
        require(currentBalance > 0, "No balance to withdraw");

        require(token.transfer(owner, currentBalance), "Token transfer failed");

        emit Withdrawal(owner, currentBalance);
    }
}
