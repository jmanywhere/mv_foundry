// SPDX-License-Identifer: MIT

pragma solidity >=0.8.19;

interface IFundSender {
    /**
     *
     * @param amount amount in TOKEN that will be sent to the receiver chain
     * @param chaindId the chain ID of the receiver chain - this is used to identify the receiver chain by Chainlink -> it's not directly the actual chain's id
     * @param _raiseAddress  the contract address that will receive funds on the receiver chain
     * @param token The token address of funds to send.
     */
    function pledge(
        uint amount,
        uint chaindId,
        address _raiseAddress,
        address token
    ) external payable;

    event Pledge(
        address indexed token,
        address indexed user,
        uint indexed receiverChain,
        uint amount
    );

    error FundSender__InvalidETHAmount();
}
