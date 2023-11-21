//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// Worker responsible for handling ticket-related operations.
class TicketsWorker {
    /// Fetches a list of tickets.
    /// - Parameters:
    ///   - request: The request object containing information about the ticket list request.
    ///   - completion: A closure called when the fetch operation is completed.
    func fetchTickets(request: Tickets.TicketList.Request, completion: @escaping (Result<[Tickets.TicketObject], Tickets.TicketFetchError>) -> Void) {
        guard let url = NetworkManager.createURL(path: APIEndpoint.Tickets.path) else {
            completion(.failure(.dataParsingError))
            return
        }
        
        NetworkManager.fetchData(from: url, responseType: [Tickets.TicketObject].self, callerName: String(describing: self)) { result in
            switch result {
            case .success(let tickets):
                completion(.success(tickets))
                
            case .failure(let networkError):
                switch networkError {
                case .invalidURL:
                    completion(.failure(.networkError))
                case .networkError(_):
                    completion(.failure(.networkError))
                case .invalidResponse:
                    completion(.failure(.dataParsingError))
                case .dataParsingError:
                    completion(.failure(.dataParsingError))
                }
            }
        }
    }
    
    /// Validates a ticket.
    /// - Parameters:
    ///   - request: The ticket object to be validated.
    ///   - completion: A closure called when the validation is completed.
    func validateTicket(request: Tickets.TicketObject, completion: @escaping (Result<Tickets.TicketObject, Tickets.TicketFetchError>) -> Void) {
        guard let url = NetworkManager.createURL(path: APIEndpoint.ValidateTicket.path(request.eventUuid)) else {
            completion(.failure(.dataParsingError))
            return
        }
        
        NetworkManager.fetchData(from: url, responseType: Tickets.ValidatedTicket.self, callerName: String(describing: self)) { result in
            switch result {
            case .success(let result):
                completion(.success(result.validated))
                
            case .failure(let networkError):
                switch networkError {
                case .invalidURL:
                    completion(.failure(.networkError))
                case .networkError(_):
                    completion(.failure(.networkError))
                case .invalidResponse:
                    completion(.failure(.dataParsingError))
                case .dataParsingError:
                    completion(.failure(.dataParsingError))
                }
            }
        }
    }
}
