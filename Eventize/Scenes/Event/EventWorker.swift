//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// The worker responsible for fetching event details.
class EventWorker {
    
    // MARK: - Public Methods
    
    /// Fetch event details from a data source.
    ///
    /// - Parameters:
    ///   - completion: A closure to handle the result of the fetch operation.
    ///
    /// - Note: This method fetches event details from a mocked data source for demonstration purposes.
    ///         In a real implementation, you should create a URL and use the NetworkManager for network requests.
    ///
    /// - Parameter completion: A closure to handle the result of the fetch operation. The closure will be called with either
    ///                        a success result containing event details or a failure result with an error.
    func fetchDetails(completion: @escaping (Result<Event.DetailsContent, Event.EventFetchError>) -> Void) {
        // TODO: - Mocked Network Call! Create URL here in the future.
        guard let jsonData = JsonMocks.Event_EventDetails else {
            completion(.failure(.dataParsingError))
            return
        }
        
        NetworkManager.fetchData(jsonData: jsonData, responseType: Event.DetailsContent.self, callerName: String(describing: self)) { result in
            switch result {
            case .success(let eventDetails):
                completion(.success(eventDetails))
                
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
}
