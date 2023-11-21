//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit
import CoreLocation

/// The worker responsible for fetching and filtering events.
class EventsWorker {
    
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
        guard let url = NetworkManager.createURL(path: APIEndpoint.Events.path) else {
            completion(.failure(.dataParsingError))
            return
        }
        
        NetworkManager.fetchData(from: url, responseType: [Events.EventObject].self, callerName: String(describing: self)) { result in
            switch result {
            case .success(var events):
                // Filter events based on the search term if provided.
                if let searchTerm = request.searchTerm, !searchTerm.isEmpty {
                    events = self.filterEvents(events: events, filters: .init(coordinate: request.coordinate, searchTerm: searchTerm, isFavorite: request.isFavorite))
                }
                
                // TODO: Remove this mock when in production
                // We just did it because otherwise you wouldn't be able to test and see items next to your location.
                let events = events.map { event in
                    let generatedCoordinate = self.generateRandomCoordinateNearUser(request.coordinate)
                    return Events.EventObject(eventUuid: event.eventUuid, content: .init(imageUrl: event.content.imageUrl,
                                                                                         title: event.content.title,
                                                                                         subtitle: event.content.subtitle,
                                                                                         price: event.content.price,
                                                                                         info: event.content.info,
                                                                                         extraBottomInfo: event.content.extraBottomInfo,
                                                                                         latitude: generatedCoordinate?.latitude,
                                                                                         longitude: generatedCoordinate?.longitude))
                }
                
                DispatchQueue.main.async {
                    completion(.success(events))
                }
                
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

// MARK: - Private API

private extension EventsWorker {
    // TODO: Remove this mock when in production
    // We just did it because otherwise you wouldn't be able to test and see items next to your location.
    func generateRandomCoordinateNearUser(_ currentCoordinate: CLLocationCoordinate2D?) -> CLLocationCoordinate2D? {
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
