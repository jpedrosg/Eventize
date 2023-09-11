//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// MARK: - LocationManagerDelegate

protocol LocationManagerDelegate: AnyObject {
    /// Called when the location is updated.
    func didUpdateLocation(name: String)
}

// MARK: - LocationManager

class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Properties

    /// The delegate to handle location updates.
    weak var delegate: LocationManagerDelegate?

    /// The location manager responsible for handling location services.
    let manager = CLLocationManager()

    /// The name associated with the current location.
    @Published var name: String = ""

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
        if let cachedLocation = UserDefaults.standard.value(forKey: locationCacheKey) as? String {
            self.name = cachedLocation
            self.delegate?.didUpdateLocation(name: cachedLocation)
        }
        
        manager.requestLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                let geoLocation = GeoLocation(with: placemark)
                self.name = geoLocation.name

                // Cache the location
                UserDefaults.standard.set(self.name, forKey: self.locationCacheKey)

                self.delegate?.didUpdateLocation(name: geoLocation.name)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle the error here
        print("Location manager failed with error: \(error.localizedDescription)")
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
