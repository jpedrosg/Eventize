//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventBusinessLogic {
    func removeFavorite()
    func setFavorite()
    func fetchEvent()
    func fetchDetails()
}

protocol EventDataStore {
    var event: Event.EventObject? { get set }
}

final class EventInteractor: EventBusinessLogic, EventDataStore {
    var presenter: EventPresentationLogic?
    var worker: EventWorker?
    var event: Event.EventObject?
    
    /// The cache manager for User Preferences.
    private let cache = UserDefaultsManager.shared
    
    init(presenter: EventPresentationLogic? = nil,
         worker: EventWorker = EventWorker(),
         event: Event.EventObject? = nil) {
        self.presenter = presenter
        self.worker = worker
        self.event = event
    }

    // MARK: - Fetch Event
    
    func fetchEvent() {
        guard let event = event else {
            // TODO: Implement Error Handling for Missing Event
            return
        }
        
        let response = Event.EventDetails.Response(event: event, eventDetails: nil)
        presenter?.presentEvent(response: response)
    }
    
    // MARK: - Fetch Event Details
    
    func fetchDetails() {
        worker?.fetchDetails(completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let details):
                guard let event = self.event else {
                    // TODO: Implement Error Handling for Missing Event
                    return
                }
                
                self.presenter?.presentEvent(response: .init(event: event, eventDetails: details))
            case .failure(_):
                // TODO: Implement Error Handling for Network or Data Parsing Error
                break
            }
        })
    }
    
    // MARK: - Favorites
    
    func setFavorite() {
        // Retrieve current UserPreferences from UserDefaults
        if var userPreferences: UserPreferences = cache.getUserPreferences(),
            let eventUuid = event?.eventUuid {
            // Add a new UUID
            userPreferences.addFavoriteEvent(uuid: eventUuid)
            
            // Save the updated UserPreferences back to UserDefaults
            cache.setUserPreferences(userPreferences)
            
            presenter?.presentFavoriteButton()
        }
    }
    
    func removeFavorite() {
        // Retrieve current UserPreferences from UserDefaults
        if var userPreferences: UserPreferences = cache.getUserPreferences(), let eventUuid = event?.eventUuid {
            // Remove UUID
            userPreferences.removeFavoriteEvent(uuid: eventUuid)
            
            // Save the updated UserPreferences back to UserDefaults
            cache.setUserPreferences(userPreferences)
            
            presenter?.presentFavoriteButton()
        }
    }
}
