//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventPresentationLogic {
    func presentEvent(response: Event.EventDetails.Response)
    func presentFavoriteButton()
}

final class EventPresenter: EventPresentationLogic {
    weak var viewController: EventDisplayLogic?

    // MARK: Presentation Logic
    
    /// Presents the event and its details to the view controller.
    ///
    /// - Parameter response: The response containing the event and its details.
    func presentEvent(response: Event.EventDetails.Response) {
        let viewModel = Event.EventDetails.ViewModel(event: response.event, eventDetails: response.eventDetails)
        viewController?.displayEvent(viewModel: viewModel)
    }
    
    func presentFavoriteButton() {
        viewController?.displayFavoriteButton()
    }
}
