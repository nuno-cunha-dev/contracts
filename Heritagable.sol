// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

contract Heritagable {
    address public owner;
    address public heir;
    uint256 public heirTime;

    constructor(address _heir) {
        require(msg.sender != heir, "Only the heir can call this.");
        require(_heir != address(0), "Heir cannot be the zero address.");

        owner = msg.sender;
        heir = _heir;
        heirTime = block.timestamp + 30 days;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this.");
        _;
    }

    modifier resetHeirTime() {
        _;
        heirTime = block.timestamp + 30 days;
    }

    event Withdrawal(address indexed to, uint256 amount);
    event HeirChanged(address indexed newHeir);

    function withdraw() external onlyOwner resetHeirTime {
        payable(msg.sender).transfer(address(this).balance);

        emit Withdrawal(msg.sender, address(this).balance);
    }

    function changeHeir(address _heir) external resetHeirTime {
        require(msg.sender == heir, "Only the heir can call this.");
        require(_heir != address(0), "Heir cannot be the zero address.");
        require(_heir != heir, "Heir cannot be the same as the current heir.");
        require(block.timestamp >= heirTime, "Heir time has not passed yet.");

        owner = msg.sender;
        heir = _heir;

        emit HeirChanged(_heir);
    }
}
