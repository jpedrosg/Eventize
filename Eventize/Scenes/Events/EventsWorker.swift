//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

/// The worker responsible for fetching and filtering events.
struct EventsWorker {
    
    // MARK: - Public Methods
    
    /// Fetch events from a data source and optionally filter them based on a search term.
    ///
    /// - Parameters:
    ///   - request: The request to fetch the events.
    ///   - completion: A closure to handle the result of the fetch operation.
    ///
    /// - Note: This method fetches events from a mocked data source for demonstration purposes.
    ///         In a real implementation, you should create a URL and use the NetworkManager for network requests.
    func fetchEvents(request: Events.EventList.Request, completion: @escaping (Result<[Events.EventObject], Events.EventFetchError>) -> Void) {
        // TODO: - Mocked Network Call! Create a URL here in the future.
        guard let jsonData = JsonMocks.Events_EventObject_Array else {
            completion(.failure(.dataParsingError))
            return
        }
        
        NetworkManager.fetchData(jsonData: jsonData, responseType: [Events.EventObject].self, callerName: String(describing: self)) { result in
            switch result {
            case .success(var events):
                // Filter events based on the search term if provided.
                if let searchTerm = request.searchTerm, !searchTerm.isEmpty {
                    events = filterEvents(events: events, filters: .init(searchTerm: searchTerm, isFavorite: request.isFavorite))
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    completion(.success(events))
                })
                
            case .failure(let networkError):
                switch networkError {
                case .invalidURL:
                    completion(.failure(.networkError))
                case .networkError(_):
                    completion(.failure(.networkError))
                case .invalidResponse:
                    completion(.failure(.dataParsingError))
                case .dataParsingError:
                    completion(.failure(.dataParsingError))
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Filter events based on a search term.
    ///
    /// - Parameters:
    ///   - events: The array of events to be filtered.
    ///   - filters: The filters.
    ///
    /// - Returns: An array of filtered events matching the search term.
    func filterEvents(events: [Events.EventObject], filters: Events.EventList.Request) -> [Events.EventObject] {
        var filteredEvents = events
        
        // Filter by searchTerm
        if let searchTerm = filters.searchTerm?.lowercased(), !searchTerm.isEmpty {
            filteredEvents = filteredEvents.filter { event in
                // Check if any of the event's fields contain the search term.
                return event.content.title.lowercased().contains(searchTerm) ||
                event.content.subtitle?.lowercased().contains(searchTerm) == true ||
                event.content.info?.lowercased().contains(searchTerm) == true ||
                (event.content.extraBottomInfo?.contains { $0.text.lowercased().contains(searchTerm) } ?? false)
            }
        }
        
        // Filter by favorite
        if filters.isFavorite {
            filteredEvents = filteredEvents.filter { event in
                // Check if any of the event's fields contain the search term.
                return event.isFavorite
            }
        }
        
        return filteredEvents
    }
}
