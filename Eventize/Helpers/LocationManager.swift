import Foundation
import CoreLocation

/// A protocol to handle location updates.
protocol LocationManagerDelegate: AnyObject {
    /// Called when the location is updated.
    /// - Parameters:
    ///   - geolocation: The reverse-geocoded location information.
    ///   - coordinate: The coordinates of the location.
    func didUpdateLocation(geolocation: GeoLocation?, coordinate: CLLocationCoordinate2D?)
}

/// A manager class for handling location services and caching the last known location.
class LocationManager: NSObject, CLLocationManagerDelegate {
    // MARK: Properties

    /// The delegate to handle location updates.
    weak var delegate: LocationManagerDelegate?

    /// The location manager responsible for handling location services.
    let manager = CLLocationManager()

    /// The current coordinates.
    var currentCoordinate: CLLocationCoordinate2D?

    /// The current reverse-geocoded location.
    var currentGeolocation: GeoLocation?

    /// The cache manager for location data.
    private let cache = UserDefaultsManager.shared

    // MARK: Initialization

    override init() {
        super.init()
        manager.delegate = self
    }

    // MARK: Public Methods

    /// Requests the current location.
    func requestLocation() {
        manager.requestWhenInUseAuthorization()

        if let cachedLocation: CLLocation = cache.getCachedLocation() {
            handleLocation(cachedLocation)
        }

        manager.requestLocation()
    }

    // MARK: CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        cache.setCachedLocation(location)

        handleLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    // MARK: Private Methods

    private func handleLocation(_ location: CLLocation) {
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
