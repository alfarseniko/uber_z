//SPDX-License-Identifier: MIT

// Pragma
pragma solidity ^0.8.24;

// Imports
import {AggregatorV3Interface} from "../lib/chainlink/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// Interfaces, Libraries and Contracts

/**
 @title An automated uber payment app
 @author Haris Waheed Bhatti
 @notice This contract is for the payment of fares after rides
         The contract is being made for US Dollars and payments made in Arbitrum
 */

contract Uber {
    // Type Declarations
    // State Variables
    address private immutable i_owner; // Address of the contract owner

    uint256 private constant RESOLUTION = 1000000; // Coordinates are calculated by dividing with RESOLUTION

    uint256 public s_ratePerKm; // Rate per Km to calculate fare
    uint256 public s_baseFare; // Base Fare for total fare calculation

    struct Point {
        int256 lat; // Latitude of the point with 6 decimal points resolution
        int256 long; // Longitude of the point with 6 decimal point resolution
    }

    struct Trip {
        address driverAddress; // Address of the driver
        address passengerAddress; // Address of the passenger
        Point startingPoint; // Coordinates of the starting point
        Point endingPoint; // Coordinates of the ending point
        uint256 distance; // Distance of the ride
        uint256 fare; // Total fare for the ride
    }

    struct DriverInfo {
        string name; // Name of the driver
        string vehicleLicensePlate; // Vehicle's license plate number
    }

    // A mapping of addresses to the information of Drivers
    mapping(address => DriverInfo) private driverDatabase;

    // A mapping of addresses to the information of Passengers
    mapping(address => string) private passengerDatabase;

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == i_owner);
        _;
    }

    // Functions Order:
    //// constructor

    constructor(uint256 _initialRatePerKm, uint256 _initialBaseFare) {
        s_ratePerKm = _initialRatePerKm; // Sets the initial rate per km
        s_baseFare = _initialBaseFare; // Sets the initial base fare
        i_owner = msg.sender; // Sets the owner to the creator of the contract
    }

    //// external

    // This function registers a driver with info in the smart contract
    function registerDriver(
        string memory _name,
        string memory _license
    ) external {
        driverDatabase[msg.sender] = DriverInfo(_name, _license);
    }

    // This function registers a passenger with info in the smart contract
    function registerPassenger(string memory _name) external {
        passengerDatabase[msg.sender] = _name;
    }

    // This function allows the owner to change the rate per KM for the fare
    function changeRatePerKm(uint256 _newRate) external onlyOwner {
        s_ratePerKm = _newRate;
    }

    // This function allows the owner to change the baseFare
    function changeBaseFare(uint256 _baseFare) external onlyOwner {
        s_baseFare = _baseFare;
    }
    //// public
    //// internal
    //// private
    //// view / pure
}
