//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import CoreLocation

/// A struct to represent user preferences.
struct UserPreferences: Codable {
    var favoriteEventsUuids: [String] = []

    mutating func addFavoriteEvent(uuid: String) {
        if !favoriteEventsUuids.contains(uuid) {
            favoriteEventsUuids.append(uuid)
        }
    }

    mutating func removeFavoriteEvent(uuid: String) {
        favoriteEventsUuids.removeAll { $0 == uuid }
    }
}

/// A manager class for handling UserDefaults caching and user preferences.
class UserDefaultsManager {
    
    // MARK: Singleton
    
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    // MARK: Location Cache
    
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
    
    // MARK: User Preferences
    
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
