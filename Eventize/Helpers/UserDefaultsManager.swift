//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import Foundation
import CoreLocation

/// A struct to represent user preferences.
struct UserPreferences: Codable, Equatable {
    var favoriteEventsUuids: [Int] = []

    mutating func addFavoriteEvent(uuid: Int) {
        if !favoriteEventsUuids.contains(uuid) {
            favoriteEventsUuids.append(uuid)
        }
    }

    mutating func removeFavoriteEvent(uuid: Int) {
        favoriteEventsUuids.removeAll { $0 == uuid }
    }
    
    static func ==(lhs: UserPreferences, rhs: UserPreferences) -> Bool {
       return lhs.favoriteEventsUuids == rhs.favoriteEventsUuids
    }
}

/// A protocol defining methods for managing user preferences using UserDefaults.
protocol UserDefaultsManagerProtocol {
    /// Retrieves the cached location from UserDefaults.
    ///
    /// - Returns: The cached location as a `CLLocation` instance, or `nil` if no location is cached.
    func getCachedLocation() -> CLLocation?

    /// Sets the cached location in UserDefaults.
    ///
    /// - Parameter location: The location to be cached as a `CLLocation` instance.
    func setCachedLocation(_ location: CLLocation?)

    /// Retrieves the user preferences from UserDefaults.
    ///
    /// - Returns: The user preferences as a `UserPreferences` instance, or `nil` if no preferences are found.
    func getUserPreferences() -> UserPreferences?

    /// Sets the user preferences in UserDefaults.
    ///
    /// - Parameter preferences: The user preferences to be stored as a `UserPreferences` instance. Pass `nil` to clear preferences.
    func setUserPreferences(_ preferences: UserPreferences?)
}

/// A manager class for handling UserDefaults caching and user preferences.
public class UserDefaultsManager {
    
    // MARK: Singleton
    
    static let shared: UserDefaultsManagerProtocol = UserDefaultsManager()
    
    private init() {}
}

// MARK: - UserDefaultsManagerProtocol

extension UserDefaultsManager: UserDefaultsManagerProtocol {
    func getCachedLocation() -> CLLocation? {
        if let cachedLocationDict = UserDefaults.standard.dictionary(forKey: "CachedLocation"),
           let latitude = cachedLocationDict["latitude"] as? CLLocationDegrees,
           let longitude = cachedLocationDict["longitude"] as? CLLocationDegrees {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    func setCachedLocation(_ location: CLLocation?) {
        if let location = location {
            let locationDict: [String: Any] = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ]
            UserDefaults.standard.set(locationDict, forKey: "CachedLocation")
        } else {
            UserDefaults.standard.removeObject(forKey: "CachedLocation")
        }
    }
    
    func getUserPreferences() -> UserPreferences? {
        if let data = UserDefaults.standard.data(forKey: "UserPreferences") {
            let decoder = JSONDecoder()
            if let preferences = try? decoder.decode(UserPreferences.self, from: data) {
                return preferences
            }
        }
        
        // New clean preferences.
        return UserPreferences()
    }
    
    func setUserPreferences(_ preferences: UserPreferences?) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(preferences) {
            UserDefaults.standard.set(data, forKey: "UserPreferences")
        } else {
            UserDefaults.standard.removeObject(forKey: "UserPreferences")
        }
    }
}
