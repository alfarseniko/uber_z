//SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "../lib/chainlink/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // Sepolia Arb -> USD price feed
        // answer can be negative or positive
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // Returns the ETH/USD rate in 18 digits because we have to do calculation in ETH later
        return uint256(answer * 10000000000);
    }

    // Answer in 820000000000000000 USD for 1 ARB
    // I have 1 USD represented as 1e36
    // To find answer in ARB I would need to divide 1e36/0.82e18 = 1219512195121951219 ARB

    /***
    @dev _usdAmount should be in 1e36 format with 36 decimals
     */
    function getConversionRate(
        uint256 _usdAmount,
        AggregatorV3Interface _pricefeed
    ) internal view returns (uint256) {
        uint256 _ethPrice = getPrice(_pricefeed);
        uint256 usdAmountInEth = _usdAmount / _ethPrice;
        // Return the USD amount converted to ARB
        return usdAmountInEth;
    }
}
