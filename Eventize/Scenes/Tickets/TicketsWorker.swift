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
        // TODO: Replace this with a real network call and URL creation.
        guard let jsonData = JsonMocks.Tickets_TicketObject_Array else {
            completion(.failure(.dataParsingError))
            return
        }
        
        NetworkManager.fetchData(jsonData: jsonData, responseType: [Tickets.TicketObject].self, callerName: String(describing: self)) { result in
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
        // TODO: Remove this mocked code and implement real ticket validation logic.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let ticket = Tickets.TicketObject(date: request.date,
                                              isValid: false,
                                              eventUuid: request.eventUuid,
                                              title: request.title,
                                              description: request.description,
                                              imageUrl: request.imageUrl)
            
            completion(.success(ticket))
        }
    }
}
