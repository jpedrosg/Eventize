//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventsPresentationLogic {
    func presentEvents(response: Events.EventList.Response)
    func presentAddress(response: Events.Address.Response)
}

final class EventsPresenter: EventsPresentationLogic {
    weak var viewController: EventsDisplayLogic?

    // MARK: - Presentation Logic

    /// Present events to the view controller.
    ///
    /// - Parameter response: The response containing events to be presented.
    func presentEvents(response: Events.EventList.Response) {
        viewController?.displayEvents(viewModel: .init(events: response.events))
    }
    
    /// Present address to the view controller.
    ///
    /// - Parameter response: The response containing address name to be presented.
    func presentAddress(response: Events.Address.Response) {
        viewController?.displayAddress(viewModel: .init(geolocation: response.geolocation, coordinate: response.coordinate))
    }
}
