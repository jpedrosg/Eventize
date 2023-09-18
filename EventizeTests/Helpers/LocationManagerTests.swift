//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest
import CoreLocation
@testable import Eventize

class LocationManagerTests: XCTestCase {
    var locationManager: LocationManaging!
    var delegateMock: LocationManagerDelegateMock!

    override func setUp() {
        super.setUp()
        locationManager = LocationManager.shared
        delegateMock = LocationManagerDelegateMock()
        locationManager.delegate = delegateMock
    }

    override func tearDown() {
        locationManager = nil
        delegateMock = nil
        super.tearDown()
    }

    func testSetUserLocation_WhenUserLocationIsManuallySet_ShouldUpdateLocationAndGeolocation() {
        // Arrange
        let newUserCoordinate = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        
        // Create an expectation
        let expectation = XCTestExpectation(description: "Location update expectation")
        
        // Assign the expectation to a property in your delegate mock
        delegateMock.expectation = expectation
        
        // Act
        locationManager.setUserLocation(newUserCoordinate)
        
        // Wait for the expectation with a timeout
        wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertEqual(locationManager.currentCoordinate?.latitude, newUserCoordinate.latitude)
        XCTAssertEqual(locationManager.currentCoordinate?.longitude, newUserCoordinate.longitude)
        XCTAssertEqual(locationManager.currentGeolocation?.city, "Los Angeles")
        XCTAssertEqual(delegateMock.updatedCoordinate?.latitude, newUserCoordinate.latitude)
        XCTAssertEqual(delegateMock.updatedCoordinate?.longitude, newUserCoordinate.longitude)
        XCTAssertEqual(delegateMock.updatedGeolocation?.city, "Los Angeles")
        XCTAssertEqual(delegateMock.didUpdateLocationCallCount, 2)
    }
}

// Mock LocationManagerDelegate for testing
class LocationManagerDelegateMock: LocationManagerDelegate {
    var didUpdateLocationCallCount: Int = 0
    var updatedCoordinate: CLLocationCoordinate2D?
    var updatedGeolocation: GeoLocation?
    var expectation: XCTestExpectation?
    
    func didUpdateLocation(geolocation: GeoLocation?, coordinate: CLLocationCoordinate2D?) {
        didUpdateLocationCallCount += 1
        updatedCoordinate = coordinate
        updatedGeolocation = geolocation
        
        // Ignored first one called on AppDelegate.
        if didUpdateLocationCallCount == 2 {
            expectation?.fulfill()
        }
    }
}
