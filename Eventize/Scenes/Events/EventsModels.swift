//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit
import CoreLocation

enum Events {
    
    // MARK: - Address
    
    enum Address {
        struct Response {
            let geolocation: GeoLocation?
            let coordinate: CLLocationCoordinate2D?
        }
        
        struct ViewModel {
            let geolocation: GeoLocation?
            let coordinate: CLLocationCoordinate2D?
        }
    }
    
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
        
        struct ViewModel: Equatable {
            let events: [EventObject]

            // Implement the Equatable protocol by comparing the events array
            static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
                return lhs.events == rhs.events
            }
        }
        
        // MARK: - Cell View Model
        
        struct CellViewModel {
            let event: EventObject
        }
        
        // MARK: - Header View Model
        
        struct HeaderViewModel {
            let address: String?
        }
    }
    
    // MARK: - Event Object
    
    struct EventObject: Codable, Equatable {
        
        // MARK: - Event Content
        
        struct EventContent: Codable, Equatable {
            // MARK: - Bottom Info
            
            struct BottomInfo: Codable, Equatable {
                let imageUrl: String?
                let text: String
            }
            
            let imageUrl: String?
            let title: String
            let subtitle: String?
            let price: Double?
            let info: String?
            let extraBottomInfo: [BottomInfo]?
            let latitude: CLLocationDegrees?
            let longitude: CLLocationDegrees?
            
            private enum CodingKeys: String, CodingKey {
                case imageUrl = "image_url"
                case title
                case subtitle
                case price
                case info
                case extraBottomInfo = "extra_bottom_info"
                case latitude
                case longitude
            }
            
            static func ==(lhs: EventContent, rhs: EventContent) -> Bool {
                return lhs.imageUrl == rhs.imageUrl &&
                lhs.title == rhs.title &&
                lhs.subtitle == rhs.subtitle &&
                lhs.price == rhs.price &&
                lhs.info == rhs.info &&
                lhs.extraBottomInfo == rhs.extraBottomInfo
            }
        }
        
        let eventUuid: String
        let content: EventContent
        
        private enum CodingKeys: String, CodingKey {
            case eventUuid = "event_uuid"
            case content
        }
        
        static func ==(lhs: EventObject, rhs: EventObject) -> Bool {
            return lhs.eventUuid == rhs.eventUuid &&
            lhs.content == rhs.content
        }
    }
    
    // MARK: - Event Fetch Error
    
    enum EventFetchError: Error {
        case networkError
        case dataParsingError
    }
}

extension Array where Element == Events.EventObject {
    func filterEvent(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Events.EventObject? {
        return self.first { event in
            if let eventLatitude = event.content.latitude, let eventLongitude = event.content.longitude {
                return eventLatitude == latitude && eventLongitude == longitude
            }
            return false
        }
    }
}
