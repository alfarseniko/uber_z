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

    // Restricted options for the gender of the Passenger/Driver
    enum Gender {
        MALE,
        FEMALE
    }

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
        Gender gender; // Gender of the driver
        string vehicleLicensePlate; // Vehicle's license plate number
        bool isActive; // Indicates if the driver is currently active
    }

    struct PassengerInfo {
        string name; // Name of the passenger
        Gender gender; // Gender of the passenger
    }

    // A mapping of addresses to the information of Drivers
    mapping(address => DriverInfo) private driverDatabase;

    // A mapping of addresses to the information of Passengers
    mapping(address => PassengerInfo) private passengerDatabase;

    // Modifiers

    // Functions Order:
    //// constructor

    constructor() {
        i_owner = msg.sender;
    }
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure
}
