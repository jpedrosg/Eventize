//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// Business logic protocol for handling ticket-related operations.
protocol TicketsBusinessLogic {
    func fetchTickets(request: Tickets.TicketList.Request)
}

/// Data store protocol for storing ticket data.
protocol TicketsDataStore {
    var tickets: [Tickets.TicketObject] { get set }
}

/// Interactor responsible for ticket-related operations.
final class TicketsInteractor: TicketsBusinessLogic, TicketsDataStore {
    var presenter: TicketsPresentationLogic?
    var worker: TicketsWorker
    var tickets: [Tickets.TicketObject]
    
    /// Initializes the interactor with optional dependencies.
    /// - Parameters:
    ///   - presenter: The presenter responsible for displaying tickets.
    ///   - worker: The worker responsible for fetching and validating tickets.
    ///   - tickets: The initial list of tickets.
    init(presenter: TicketsPresentationLogic? = nil,
         worker: TicketsWorker = TicketsWorker(),
         tickets: [Tickets.TicketObject] = []) {
        self.presenter = presenter
        self.worker = worker
        self.tickets = tickets
    }

    /// Fetches a list of tickets.
    /// - Parameter request: The request object containing information about the ticket list request.
    func fetchTickets(request: Tickets.TicketList.Request) {
        worker.fetchTickets(request: request) { result in
            switch result {
            case .success(let tickets):
                self.tickets = tickets
                self.presenter?.presentTickets(response: .init(tickets: tickets))
            case .failure(_):
                // TODO: Handle Error
                break
            }
        }
    }
}

// MARK: - TicketsViewCellInteractions

extension TicketsInteractor: TicketsViewCellInteractions {
    /// Validates a ticket.
    /// - Parameter ticket: The ticket object to be validated.
    func validateTicket(_ ticket: Tickets.TicketObject) {
        worker.validateTicket(request: ticket) { result in
            switch result {
            case .success(let resultTicket):
                let newTickets = self.tickets.map { storedTicket in
                    if storedTicket.eventUuid == resultTicket.eventUuid {
                        return resultTicket
                    } else {
                        return storedTicket
                    }
                }
                
                self.tickets = newTickets
                self.presenter?.presentTickets(response: .init(tickets: newTickets))
            case .failure(_):
                // TODO: Handle Error
                break
            }
        }
        presenter?.presentTickets(response: .init(tickets: tickets))
    }
}
