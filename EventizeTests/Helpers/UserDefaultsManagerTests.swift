//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import XCTest
import CoreLocation
@testable import Eventize

class UserDefaultsManagerTests: XCTestCase {
    var userDefaultsManager: UserDefaultsManagerProtocol!

    override func setUp() {
        super.setUp()
        userDefaultsManager = UserDefaultsManagerMock()
    }

    override func tearDown() {
        userDefaultsManager = nil
        super.tearDown()
    }

    func testGetSetCachedLocation() {
        // Create a sample location
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)

        // Set and get the cached location
        userDefaultsManager.setCachedLocation(location)
        let cachedLocation = userDefaultsManager.getCachedLocation()

        XCTAssertEqual(location.coordinate.latitude, cachedLocation?.coordinate.latitude)
        XCTAssertEqual(location.coordinate.longitude, cachedLocation?.coordinate.longitude)
    }

    func testGetSetUserPreferences() {
        // Create a sample user preferences
        let preferences = UserPreferences()

        // Set and get the user preferences
        userDefaultsManager.setUserPreferences(preferences)
        let retrievedPreferences = userDefaultsManager.getUserPreferences()

        XCTAssertEqual(preferences, retrievedPreferences)
    }

    func testClearUserPreferences() {
        // Create and set user preferences
        let preferences = UserPreferences()
        userDefaultsManager.setUserPreferences(preferences)

        // Clear user preferences
        userDefaultsManager.setUserPreferences(nil)

        // Attempt to get user preferences after clearing
        let retrievedPreferences = userDefaultsManager.getUserPreferences()
        XCTAssertNil(retrievedPreferences)
    }
}

class UserDefaultsManagerMock: UserDefaultsManagerProtocol {
    var cachedLocation: CLLocation?
    var userPreferences: UserPreferences?

    func getCachedLocation() -> CLLocation? {
        return cachedLocation
    }

    func setCachedLocation(_ location: CLLocation?) {
        cachedLocation = location
    }

    func getUserPreferences() -> UserPreferences? {
        return userPreferences
    }

    func setUserPreferences(_ preferences: UserPreferences?) {
        userPreferences = preferences
    }
}

