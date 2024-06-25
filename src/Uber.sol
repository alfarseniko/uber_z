//SPDX-License-Identifier: MIT

// Pragma
pragma solidity ^0.8.24;

// Imports
import {AggregatorV3Interface} from "../lib/chainlink/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// Interfaces, Libraries and Contracts

/**
  * @title An automated uber payment app
  * @author Haris Waheed Bhatti
  * @notice This contract is for the payment of fares after rides
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
        uint256 startTime;
        uint256 stopTime;
        uint256 distance; // Distance of the ride
        uint256 fare; // Total fare for the ride
    }

    Trip[] private tripArray;

    struct DriverInfo {
        string name; // Name of the driver
        string vehicleLicensePlate; // Vehicle's license plate number
        address payable walletAddress; // The address in which payments will be sent
    }

    struct PassengerInfo {
        string name; // Name of the passenger
        address payable walletAddress; // The address in which payments will be sent
    }

    // A mapping of addresses to the information of Drivers
    mapping(address => DriverInfo) private s_driverDatabase;

    // A mapping of addresses to the information of Passengers
    mapping(address => PassengerInfo) private s_passengerDatabase;

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
     * @dev Always input USD price with 36 decimals
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

    /**
     * @notice This function registers a driver with info in the smart contract
     * @param _name of driver and the license plate number of the car
     */
    function registerDriver(
        string memory _name,
        string memory _license,
        address payable _wallet
    ) external {
        require(
            s_driverDatabase[msg.sender].walletAddress == address(0),
            "Driver already registered!"
        );
        s_driverDatabase[msg.sender] = DriverInfo(_name, _license, _wallet);
    }

    /**
     * @notice This function registers a passenger with info in the smart contract
     * @param _name of the passenger
     */
    function registerPassenger(
        string memory _name,
        address payable _wallet
    ) external {
        require(
            s_passengerDatabase[msg.sender].walletAddress == address(0),
            "Passenger already registered!"
        );
        s_passengerDatabase[msg.sender] = PassengerInfo(_name, _wallet);
    }

    /**
     * @notice This function allows the owner to change the rate per KM for the fare
     * @param _newRate for the rate per km
     * @dev rate should be in usd expressed as 1e36 or 36 decimals
     */
    function changeRatePerKm(uint256 _newRate) external onlyOwner {
        s_ratePerKm = _newRate;
    }

    /**
     * @notice This function allows the owner to change the baseFare
     * @param _baseFare price for the base fare
     * @dev rate should be in usd expressed as 1e36 or 36 decimals
     */
    function changeBaseFare(uint256 _baseFare) external onlyOwner {
        s_baseFare = _baseFare;
    }
    //// public

    /**
     * @notice This function allows the owner to change the baseFare
     * @param _distanceInMetre is the distance of the whole trip in metres
     * @dev Distance should always be in whole numbers represented in 1000 * Kilometres
     * @return the total fare price after calculation of fare
     */
    function calculateFare(
        uint256 _distanceInMetre
    ) public view returns (uint256) {
        uint256 _basefare = convertUsdToArb(s_baseFare);
        uint256 _ratePerKm = convertUsdToArb(s_ratePerKm);
        // Rates and base fare has been converted to ARB represented as 1e18

        uint256 _farePrice = _basefare + (_ratePerKm * _distanceInMetre);
        return _farePrice;
    }

    /**
     * @notice This function allows functions to easily convert USD to ARB
     * @param _usdAmount to be converted to ARB
     * @dev USD amount should be in usd expressed as 1e36 or 36 decimals
     * @return Price in ARB converted from USD
     */
    function convertUsdToArb(
        uint256 _usdAmount
    ) internal view returns (uint256) {
        uint256 convertedAmount = _usdAmount.getConversionRate(s_priceFeed);
        return convertedAmount;
    }

    function startTrip(
        address _driverAddress,
        address _passengerAddress
    ) public onlyOwner {
        Trip memory newTrip;

        newTrip.driverAddress = _driverAddress;
        newTrip.passengerAddress = _passengerAddress;
        newTrip.startTime = block.timestamp;

        tripArray.push(newTrip);
    }

    //// private
    //// view / pure
    /**
    get driver info
    get passenger info
    get base fare
    get rate per km
    get conversion rate
    get owner
     */
}
