//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit
import CoreLocation

protocol EventsBusinessLogic {
    func setFavorite(_ event: Events.EventObject)
    func removeFavorite(_ event: Events.EventObject)
    func fetchEvents(request: Events.EventList.Request)
    func filterEvents(request: Events.EventList.Request)
    func selectEvent(at index: Int)
    func selectEvent(_ event: Events.EventObject)
    func fetchLocation()
}

protocol EventsDataStore {
    var events: [Events.EventObject] { get set }
    var selectedEvent: Events.EventObject? { get set }
}

final class EventsInteractor: EventsBusinessLogic, EventsDataStore {
    var presenter: EventsPresentationLogic?
    var worker: EventsWorker
    
    var lastFilterRequest: Events.EventList.Request?
    var selectedEvent: Events.EventObject?
    var events: [Events.EventObject]
    var filteredEvents: [Events.EventObject]?
    
    /// The cache manager for User Preferences.
    private let cache = UserDefaultsManager.shared
    
    private var currentCoordinate: CLLocationCoordinate2D?
    let locationManager = LocationManager()
    
    init(presenter: EventsPresentationLogic? = nil,
         worker: EventsWorker = EventsWorker(),
         selectedEvent: Events.EventObject? = nil,
         events: [Events.EventObject] = []) {
        self.presenter = presenter
        self.worker = worker
        self.selectedEvent = selectedEvent
        self.events = events
    }

    // MARK: - Fetch Events
    
    func fetchLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func fetchEvents(request: Events.EventList.Request) {
        worker.fetchEvents(request: request, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let events):
                // TODO: Remove this mock when in production
                // We just did it because otherwise you wouldn't be able to test and see items next to your location.
                let events = events.map { event in
                    let generatedCoordinate = self.generateRandomCoordinateNearUser()
                    return Events.EventObject(eventUuid: event.eventUuid, content: .init(imageUrl: event.content.imageUrl,
                                                                                         title: event.content.title,
                                                                                         subtitle: event.content.subtitle,
                                                                                         price: event.content.price,
                                                                                         info: event.content.info,
                                                                                         extraBottomInfo: event.content.extraBottomInfo,
                                                                                         latitude: generatedCoordinate?.latitude,
                                                                                         longitude: generatedCoordinate?.longitude))
                }
                
                self.events = events
                self.presenter?.presentEvents(response: .init(events: events))
            case .failure(_):
                // TODO: Implement Error Handling
                break
            }
        })
    }
    
    // MARK: - Filter Events
    
    func filterEvents() {
        guard let request = lastFilterRequest else { return }
        
        filterEvents(request: request)
    }
    
    func filterEvents(request: Events.EventList.Request) {
        lastFilterRequest = request
        let filteredEvents = worker.filterEvents(events: events, filters: request)
        self.filteredEvents = filteredEvents
        presenter?.presentEvents(response: .init(events: filteredEvents))
    }
    
    // MARK: - Select Event
    
    func selectEvent(at index: Int) {
        selectedEvent = (filteredEvents ?? events)[safe: index]
    }
    
    func selectEvent(_ event: Events.EventObject) {
        selectedEvent = event
    }
    
    // MARK: - Favorites
    
    func setFavorite(_ event: Events.EventObject) {
        // Retrieve current UserPreferences from UserDefaults
        if var userPreferences: UserPreferences = cache.getUserPreferences() {
            // Add a new UUID
            userPreferences.addFavoriteEvent(uuid: event.eventUuid)
            
            // Save the updated UserPreferences back to UserDefaults
            cache.setUserPreferences(userPreferences)
            
            filterEvents()
        }
    }
    
    func removeFavorite(_ event: Events.EventObject) {
        // Retrieve current UserPreferences from UserDefaults
        if var userPreferences: UserPreferences = cache.getUserPreferences() {
            // Remove UUID
            userPreferences.removeFavoriteEvent(uuid: event.eventUuid)
            
            // Save the updated UserPreferences back to UserDefaults
            cache.setUserPreferences(userPreferences)
            
            filterEvents()
        }
    }
    
    // TODO: Remove this mock when in production
    // We just did it because otherwise you wouldn't be able to test and see items next to your location.
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
}

// MARK: LocationManagerDelegate

extension EventsInteractor: LocationManagerDelegate {
    func didUpdateLocation(geolocation: GeoLocation?, coordinate: CLLocationCoordinate2D?) {
        self.currentCoordinate = coordinate
        presenter?.presentAddress(response: .init(geolocation: geolocation, coordinate: coordinate))
    }
}
