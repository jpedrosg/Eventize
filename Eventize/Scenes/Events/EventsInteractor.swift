//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit
import CoreLocation

protocol EventsBusinessLogic {
    func setUserLocation(_ newUserCoordinate: CLLocationCoordinate2D)
    func resetUserLocation()
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
    
    var lastFilterRequest: Events.EventList.Request? = .init(isFavorite: false)
    var selectedEvent: Events.EventObject?
    var events: [Events.EventObject]
    var filteredEvents: [Events.EventObject]?
    private var currentCoordinate: CLLocationCoordinate2D?
    
    /// The cache manager for User Preferences.
    private let cache: UserDefaultsManagerProtocol
    /// The location service manager.
    private var locationManager: LocationManaging
    
    init(presenter: EventsPresentationLogic? = nil,
         worker: EventsWorker = EventsWorker(),
         cache: UserDefaultsManagerProtocol = UserDefaultsManager.shared,
         locationManager: LocationManaging = LocationManager.shared,
         selectedEvent: Events.EventObject? = nil,
         events: [Events.EventObject] = []) {
        self.presenter = presenter
        self.worker = worker
        self.cache = cache
        self.locationManager = locationManager
        self.selectedEvent = selectedEvent
        self.events = events
    }

    // MARK: - Fetch Events
    
    func fetchLocation() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func fetchEvents(request: Events.EventList.Request) {
        worker.fetchEvents(request: .init(coordinate: request.coordinate ?? currentCoordinate, searchTerm: request.searchTerm, isFavorite: request.isFavorite), completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let events):
                self.events = events
                self.filteredEvents = events
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
    
    func setUserLocation(_ newUserCoordinate: CLLocationCoordinate2D) {
        locationManager.setUserLocation(newUserCoordinate)
    }
    
    func resetUserLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - LocationManagerDelegate

extension EventsInteractor: LocationManagerDelegate {
    func didUpdateLocation(geolocation: GeoLocation?, coordinate: CLLocationCoordinate2D?) {
        self.currentCoordinate = coordinate
        presenter?.presentAddress(response: .init(geolocation: geolocation, coordinate: coordinate))
    }
}
