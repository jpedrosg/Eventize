//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventsBusinessLogic {
    func fetchEvents(request: Events.EventList.Request)
    func filterEvents(request: Events.EventList.Request)
    func selectEvent(at index: Int)
    func fetchLocation()
}

protocol EventsDataStore {
    var events: [Events.EventObject] { get set }
    var selectedEvent: Events.EventObject? { get set }
}

final class EventsInteractor: EventsBusinessLogic, EventsDataStore {
    var presenter: EventsPresentationLogic?
    var worker: EventsWorker
    
    var selectedEvent: Events.EventObject?
    var events: [Events.EventObject]
    
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
        worker.fetchEvents(address: request.address, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let events):
                self.events = events
                self.presenter?.presentEvents(response: .init(events: events))
            case .failure(_):
                // TODO: Implement Error Handling
                break
            }
        })
    }
    
    // MARK: - Filter Events
    
    func filterEvents(request: Events.EventList.Request) {
        let filteredEvents = worker.filterEvents(events: events, searchTerm: request.searchTerm)
        presenter?.presentEvents(response: .init(events: filteredEvents))
    }
    
    // MARK: - Select Event
    
    func selectEvent(at index: Int) {
        selectedEvent = events[safe: index]
    }
}

// MARK: LocationManagerDelegate

extension EventsInteractor: LocationManagerDelegate {
    func didUpdateLocation(name: String) {
        presenter?.presentAddress(response: .init(name: name))
    }
}
