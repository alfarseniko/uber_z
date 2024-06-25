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
    /**
    @dev Always input USD price with 36 decimals
     */
    using PriceConverter for uint256;
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
    mapping(address => DriverInfo) private s_driverDatabase;

    // A mapping of addresses to the information of Passengers
    mapping(address => string) private s_passengerDatabase;

    // An instance of the contract AggregatorV3Interface
    AggregatorV3Interface private s_priceFeed;

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == i_owner);
        _;
    }

    // Functions Order:
    //// constructor
    /**
    @dev Always input USD price with 36 decimals
     */
    constructor(
        uint256 _initialRatePerKm,
        uint256 _initialBaseFare,
        address priceFeedAddress
    ) {
        s_ratePerKm = _initialRatePerKm; // Sets the initial rate per km
        s_baseFare = _initialBaseFare; // Sets the initial base fare
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
        i_owner = msg.sender; // Sets the owner to the creator of the contract
    }

    //// external

    // This function registers a driver with info in the smart contract
    function registerDriver(
        string memory _name,
        string memory _license
    ) external {
        s_driverDatabase[msg.sender] = DriverInfo(_name, _license);
    }

    // This function registers a passenger with info in the smart contract
    function registerPassenger(string memory _name) external {
        s_passengerDatabase[msg.sender] = _name;
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

    /**
    @dev Distance should always be in whole numbers represented in metres (m)
     */
    function calculateFare(uint256 _distanceInMetre) public pure returns (uint256) {
        uint256 _basefare = convertUsdToArb(s_baseFare);;
        uint256 _ratePerKm = convertUsdToArb(s_ratePerKm);
        // Rates and base fare has been converted to ARB represented as 1e18

        uint256 _farePrice = _basefare + (_ratePerKm * _distanceInMetre);
    }
    //// internal
    function convertUsdToArb(uint256 _usdAmount) internal view returns (uint256) {
        uint256 convertedAmount = _usdAmount.getConversionRate(s_priceFeed);
        return convertedAmount;
    }
    //// private
    //// view / pure
}
