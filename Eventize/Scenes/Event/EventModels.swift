//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// Enum containing event-related components.
enum Event {
    typealias EventObject = Events.EventObject
    
    /// Represents a request for event details.
    struct EventDetails {
        /// Request structure for fetching event details.
        struct Request {
            /// The unique identifier of the event.
            let eventUuid: Int
        }

        /// Response structure containing event and its details.
        struct Response {
            /// The event object.
            let event: EventObject
            /// Details content associated with the event.
            let eventDetails: DetailsContent?
        }
        
        /// View model structure for presenting event and its details.
        struct ViewModel {
            /// The event object.
            let event: EventObject
            /// Details content associated with the event.
            let eventDetails: DetailsContent?
        }
    }
    
    /// Represents the details content of an event.
    struct DetailsContent: Codable {
        /// The description of the event.
        let description: String?
        
        private enum CodingKeys: String, CodingKey {
            case description
        }
    }
    
    /// Enum representing errors that can occur during event data fetching.
    enum EventFetchError: Error {
        /// Network error during data fetch.
        case networkError
        /// Error while parsing data.
        case dataParsingError
    }
}
