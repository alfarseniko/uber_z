# UBER Z

## Overview

An automated smart contract for ride hailing apps like uber using the arbitrum sepolia testnet.

## Steps

- owner address in constructor ✅
- customer / driver database??  driver/customer sign up? ✅
- formula which takes distance and gives fare ✅
- price converters from chainlink oracle ✅
- admin permissions ✅
- automated payments


## Challenges

- representing latitude and longitude in solidity
- how to maintain a driver/passenger database with finding ability
- convert ARB/USD oracle price to USD/ARB price
- how to keep track of addresses and permissions of different drivers and their passengers for each trip
- payment of each combination of drivers and passengers
- how do i create a modifier which prevents everyone from starting a trip 


ARB/USD Oracle Address on Arb Sepolia
0xD1092a65338d049DB68D7Be6bD89d17a0929945e