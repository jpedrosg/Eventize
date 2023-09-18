//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import Foundation
import CoreLocation


// Protocol for location updates
protocol LocationManagerDelegate: AnyObject {
    /// Called when the location is updated.
    ///
    /// - Parameters:
    ///   - geolocation: The reverse-geocoded location information.
    ///   - coordinate: The coordinates of the location.
    func didUpdateLocation(geolocation: GeoLocation?, coordinate: CLLocationCoordinate2D?)
}

// Protocol for location management
protocol LocationManaging {
    /// The delegate responsible for handling location updates.
    var delegate: LocationManagerDelegate? { get set }

    /// The current coordinates of the device's location.
    var currentCoordinate: CLLocationCoordinate2D? { get }

    /// The current reverse-geocoded location information.
    var currentGeolocation: GeoLocation? { get }

    /// A flag indicating whether a manual location has been selected.
    var hasManualLocationSelected: Bool { get }

    /// Requests the current location information.
    ///
    /// This method triggers the process of obtaining the device's current location and geolocation.
    /// The results will be provided to the delegate via the `didUpdateLocation(geolocation:coordinate:)` method.
    func requestLocation()

    /// Manually sets the user's location.
    ///
    /// - Parameter newUserCoordinate: The new coordinate to set as the user's location.
    ///
    /// Use this method to set a custom user location for testing or other scenarios where manual location selection is required.
    func setUserLocation(_ newUserCoordinate: CLLocationCoordinate2D)
}

/// A manager class for handling location services and caching the last known location.
class LocationManager: NSObject, LocationManaging {
    // MARK: Singleton
    
    static let shared: LocationManaging = LocationManager()
    
    // MARK: Properties

    /// The delegate to handle location updates.
    weak var delegate: LocationManagerDelegate?

    /// The location manager responsible for handling location services.
    let manager = CLLocationManager()

    /// The current coordinates.
    var currentCoordinate: CLLocationCoordinate2D?

    /// The current reverse-geocoded location.
    var currentGeolocation: GeoLocation?
    
    /// If the currentCoordinate was manually selected.
    var hasManualLocationSelected: Bool = false

    /// The cache manager for location data.
    private let cache = UserDefaultsManager.shared
    
    /// Filter to avoid unecessary location changes.
    private static let distanceFilter: CGFloat = 500

    // MARK: Initialization

    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: LocationManaging

    /// Requests the current location.
    func requestLocation() {
        hasManualLocationSelected = false
        manager.requestWhenInUseAuthorization()

        if let cachedLocation: CLLocation = cache.getCachedLocation() {
            handleLocation(cachedLocation)
        }

        manager.requestLocation()
    }
    
    func setUserLocation(_ newUserCoordinate: CLLocationCoordinate2D) {
        hasManualLocationSelected = true
        let location = CLLocation(coordinate: newUserCoordinate, altitude: .zero, horizontalAccuracy: .zero, verticalAccuracy: .zero, timestamp: .now)
        handleLocation(location)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, !hasManualLocationSelected else { return }
        
        if let lat = currentCoordinate?.latitude, let long = currentCoordinate?.longitude {
            guard location.distance(from: .init(latitude: lat, longitude: long)) >= Self.distanceFilter else { return }
        }
        
        cache.setCachedLocation(location)
        handleLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

// MARK: - Private API

private extension LocationManager {
    func handleLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error {
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

/// A struct to handle the location information.
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
