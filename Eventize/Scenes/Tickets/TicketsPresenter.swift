//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// Protocol for presenting tickets.
protocol TicketsPresentationLogic {
    /// Presents the list of tickets.
    /// - Parameter response: The response containing ticket data.
    func presentTickets(response: Tickets.TicketList.Response)
}

/// Presenter for handling ticket presentation logic.
final class TicketsPresenter: TicketsPresentationLogic {
    /// The view controller to which the presenter will communicate.
    weak var viewController: TicketsDisplayLogic?

    /// Presents the list of tickets.
    /// - Parameter response: The response containing ticket data.
    func presentTickets(response: Tickets.TicketList.Response) {
        // Call the displayTickets method of the view controller to show the tickets.
        viewController?.displayTickets(viewModel: .init(tickets: response.tickets))
    }
}
