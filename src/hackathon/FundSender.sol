// SPDX-License-Identifer: MIT

pragma solidity 0.8.19;

import {IFundSender} from "../../src/interface/IFundSender.sol";
import {IUniswapV2Router01} from "../../src/interface/IUniswap.sol";

contract FundSender is IFundSender {
    address defaultStable;
    IUniswapV2Router01 defaultRouter;
    address weth;

    constructor(address _router, address _stable) {
        defaultRouter = IUniswapV2Router01(_router);
        defaultStable = _stable;
        weth = defaultRouter.WETH();
    }

    function pledge(
        uint amount,
        uint chaindId,
        address _raiseAddress,
        address token
    ) external payable {
        // First let's do when token is NATIVE
        if (token == address(0)) {
            if (msg.value == 0 || msg.value != amount)
                revert FundSender__InvalidETHAmount();

            address[] memory path = new address[](2);
            path[0] = weth;
            path[1] = defaultStable;
            /// SWAP FOR STABLE...
            uint[] memory amounts = defaultRouter.swapExactETHForTokens{
                value: msg.value
            }(0, path, address(this), block.timestamp);
            amount = amounts[1];
            token = defaultStable;
            /// SEND TO RECEIVER CHAIN
        }
        // TODO implement the actual CCIP interaction
        // this is pseudo code
        // CCIPRouter( transfer TO, amount, chainId, token, raiseAddress)

        emit Pledge(token, msg.sender, chaindId, amount);
    }
}
