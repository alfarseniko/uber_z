//SPDX-License-Identifier: MIT

// Pragma
pragma solidity ^0.8.24;

// Imports

// Interfaces, Libraries and Contracts

/**
 @title An automated uber payment app
 @author Haris Waheed Bhatti
 @notice This contract is for the payment of fares after rides
 */

contract Uber {
    // Type Declarations
    // State Variables
    address private immutable i_owner; // Address of the contract owner

    uint256 private constant RESOLUTION = 1000000; // Coordinates are calculated by dividing with RESOLUTION

    uint256 public s_ratePerKM;

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
    // Events

    // Functions Order:
    //// constructor

    constructor() {
        i_owner = msg.sender;
    }
    //// receive
    receive() external;

    //// fallback
    fallback() external;

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
    //// public
    //// internal
    //// private
    //// view / pure
}
