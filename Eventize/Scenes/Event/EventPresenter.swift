//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// Protocol for handling presentation logic of an event.
protocol EventPresentationLogic {
    /// Presents the event and its details.
    ///
    /// - Parameter response: The response containing the event and its details.
    func presentEvent(response: Event.EventDetails.Response)
    
    /// Presents the favorite button.
    func presentFavoriteButton()
}

/// Presenter responsible for handling event-related presentation logic.
final class EventPresenter: EventPresentationLogic {
    weak var viewController: EventDisplayLogic?

    // MARK: Presentation Logic
    
    /// Presents the event and its details to the view controller.
    ///
    /// - Parameter response: The response containing the event and its details.
    func presentEvent(response: Event.EventDetails.Response) {
        let viewModel = Event.EventDetails.ViewModel(event: response.event, eventDetails: response.eventDetails)
        
        DispatchQueue.main.async {
            self.viewController?.displayEvent(viewModel: viewModel)
        }
    }
    
    /// Presents the favorite button to the view controller.
    func presentFavoriteButton() {
        viewController?.displayFavoriteButton()
    }
}
