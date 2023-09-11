//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

enum Events {
    
    // MARK: - Event List
    
    enum EventList {
        
        // MARK: - Request
        
        struct Request {
            let address: String?
            let searchTerm: String?
            
            init(address: String? = nil, searchTerm: String? = nil) {
                self.address = address
                self.searchTerm = searchTerm
            }
        }
        
        // MARK: - Response
        
        struct Response {
            let events: [EventObject]
        }
        
        // MARK: - View Model
        
        struct ViewModel {
            let events: [EventObject]
        }
        
        // MARK: - Cell View Model
        
        struct CellViewModel {
            let event: EventObject
        }
    }
    
    // MARK: - Event Object
    
    struct EventObject: Codable {
        
        // MARK: - Event Content
        
        struct EventContent: Codable {
            
            // MARK: - Bottom Info
            
            struct BottomInfo: Codable {
                let imageUrl: String?
                let text: String
            }
            
            let imageUrl: String?
            let title: String
            let subtitle: String?
            let price: Double?
            let info: String?
            let extraBottomInfo: [BottomInfo]?
            
            private enum CodingKeys: String, CodingKey {
                case imageUrl = "image_url"
                case title
                case subtitle
                case price
                case info
                case extraBottomInfo = "extra_bottom_info"
            }
        }
        
        let eventUuid: String
        let content: EventContent
        
        private enum CodingKeys: String, CodingKey {
            case eventUuid = "event_uuid"
            case content
        }
    }
    
    // MARK: - Event Fetch Error
    
    enum EventFetchError: Error {
        case networkError
        case dataParsingError
    }
}
