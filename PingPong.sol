// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.1;

contract PingPong {
    address public pinger;

    constructor() {
        pinger = msg.sender;
    }

    event Ping();
    event Pong(bytes32 txHash);

    function ping() external {
        require(msg.sender == pinger, "Only the pinger can call this.");

        emit Ping();
    }

    function pong(bytes32 _txHash) external {
        emit Pong(_txHash);
    }
}
