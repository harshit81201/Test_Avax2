// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Assessment{
    string public name;
    string public symbol;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event TokensMinted(address indexed account, uint256 amount);
    event TokensBurned(address indexed account, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    constructor(string memory tokenName, string memory tokenSymbol) {
        name = tokenName;
        symbol = tokenSymbol;
    }

    function mint(address account, uint256 amount) public {
        require(account != address(0), "Invalid address");
        balanceOf[account] += amount;
        emit TokensMinted(account, amount);
    }

    function burn(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        emit TokensBurned(msg.sender, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(balanceOf[from] >= value, "Not enough balance for the transaction");
        require(allowance[from][msg.sender] >= value, "Not enough allowance for the transaction");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    function transfer(address recipient, uint256 amount) public {
        require(recipient != address(0), "Invalid recipient address");
        require(balanceOf[msg.sender] >= amount, "Not enough balance for the transaction");

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) public {
        require(spender != address(0), "Invalid spender address");
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
    }
}
