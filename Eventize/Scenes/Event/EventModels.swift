//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

enum Event {
    typealias EventObject = Events.EventObject
    
    enum EventDetails {
        struct Request {
            let eventUuid: Int
        }

        struct Response {
            let event: EventObject
            let eventDetails: DetailsContent?
        }
        
        struct ViewModel {
            let event: EventObject
            let eventDetails: DetailsContent?
        }
    }
    
    struct DetailsContent: Codable {
        let description: String?
        
        private enum CodingKeys: String, CodingKey {
            case description
        }
    }
    
    enum EventFetchError: Error {
        case networkError
        case dataParsingError
    }
}
