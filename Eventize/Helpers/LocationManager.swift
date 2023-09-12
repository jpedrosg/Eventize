//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - LocationManagerDelegate

protocol LocationManagerDelegate: AnyObject {
    /// Called when the location is updated.
    func didUpdateLocation(geolocation: GeoLocation?, coordinate: CLLocationCoordinate2D?)
}

// MARK: - LocationManager

class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Properties

    /// The delegate to handle location updates.
    weak var delegate: LocationManagerDelegate?

    /// The location manager responsible for handling location services.
    let manager = CLLocationManager()

    var currentCoordinate: CLLocationCoordinate2D?
    var currentGeolocation: GeoLocation?

    // Cache location using UserDefaults
    private let locationCacheKey = "CachedLocation"

    // MARK: Initialization

    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: Public Methods

    /// Requests the current location.
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        
        // Try to load cached location
        if let cachedLocationDict = UserDefaults.standard.dictionary(forKey: self.locationCacheKey),
           let latitude = cachedLocationDict["latitude"] as? CLLocationDegrees,
           let longitude = cachedLocationDict["longitude"] as? CLLocationDegrees {
            let cachedLocation = CLLocation(latitude: latitude, longitude: longitude)
            // Now you have the CLLocation object back
            handleLocation(cachedLocation)
        }
        
        manager.requestLocation()
    }
    
    func generateRandomCoordinateNearUser() -> CLLocationCoordinate2D? {
        guard let userCoordinate = currentCoordinate else {
            return nil
        }
        
        let metersPerDegreeLatitude: CLLocationDistance = 111319.9 // Approximate meters per degree of latitude
        let metersPerDegreeLongitude: CLLocationDistance = 111412.84 // Approximate meters per degree of longitude at equator
        
        // Generate random offsets in meters (adjust these values based on how close you want the generated coordinate to be)
        let latitudeOffsetMeters = Double.random(in: -5000.0...5000.0)
        let longitudeOffsetMeters = Double.random(in: -5000.0...5000.0)
        
        // Calculate the new coordinates
        let latitude = userCoordinate.latitude + (latitudeOffsetMeters / metersPerDegreeLatitude)
        let longitude = userCoordinate.longitude + (longitudeOffsetMeters / metersPerDegreeLongitude)
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Cache the location
        // Convert CLLocation to a dictionary
        let locationDict: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]

        // Save the dictionary to UserDefaults
        UserDefaults.standard.set(locationDict, forKey: self.locationCacheKey)
        
        handleLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle the error here
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

// MARK: - Private API

private extension LocationManager {
    func handleLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self else { return }
            
            if let error {
                print("Error reverse geocoding: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                let geoLocation = GeoLocation(with: placemark)
                self.currentGeolocation = geoLocation
                self.currentCoordinate = location.coordinate
                
                self.delegate?.didUpdateLocation(geolocation: self.currentGeolocation, coordinate: self.currentCoordinate)
            }
        }
    }
}

// MARK: - GeoLocation

struct GeoLocation {
    let name: String
    let streetName: String
    let city: String
    let state: String
    let zipCode: String
    let country: String
    
    init(with placemark: CLPlacemark) {
        self.name = placemark.name ?? ""
        self.streetName = placemark.thoroughfare ?? ""
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.zipCode = placemark.postalCode ?? ""
        self.country = placemark.country ?? ""
    }
}
