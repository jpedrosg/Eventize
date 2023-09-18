//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// The Tickets module contains structures and enums related to ticket management.
enum Tickets {
    
    /// Represents the ticket list use case.
    enum TicketList {
        /// Request structure for fetching a list of tickets.
        struct Request {}
        
        /// Response structure containing a list of ticket objects.
        struct Response {
            let tickets: [TicketObject]
        }
        
        /// View model structure for displaying a list of tickets.
        struct ViewModel {
            let tickets: [TicketObject]
        }
        
        /// View model structure for individual ticket cells.
        struct CellViewModel {
            let ticket: TicketObject
        }
    }
    
    /// Represents a ticket object.
    struct TicketObject: Codable {
        let date: String
        let isValid: Bool
        let eventUuid: String
        let title: String
        let description: String?
        let imageUrl: String?
        var quantity: Int?
        
        enum CodingKeys: String, CodingKey {
            case date
            case isValid = "is_valid"
            case eventUuid = "event_uuid"
            case title
            case description
            case imageUrl = "image_url"
            case quantity
        }
    }
    
    /// Represents errors that can occur during ticket fetching.
    enum TicketFetchError: Error {
        /// Network error while fetching tickets.
        case networkError
        
        /// Error related to parsing ticket data.
        case dataParsingError
    }
}
