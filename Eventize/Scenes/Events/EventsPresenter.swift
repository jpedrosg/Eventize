//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventsPresentationLogic {
    func presentEvents(response: Events.EventList.Response)
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
}
