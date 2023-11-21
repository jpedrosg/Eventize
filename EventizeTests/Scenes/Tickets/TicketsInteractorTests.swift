//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest
@testable import Eventize

class TicketsInteractorTests: XCTestCase {

    // MARK: - Test Doubles

    class MockPresentationLogic: TicketsPresentationLogic {
        var presentTicketsCalled = false

        func presentTickets(response: Tickets.TicketList.Response) {
            presentTicketsCalled = true
        }
    }

    class MockWorker: TicketsWorker {
        var fetchTicketsCalled = false
        var validateTicketCalled = false

        override func fetchTickets(request: Tickets.TicketList.Request, completion: @escaping (Result<[Tickets.TicketObject], Tickets.TicketFetchError>) -> Void) {
            fetchTicketsCalled = true
            // Simulate a successful ticket fetch with mock data
            completion(.success([.init(date: "2023-09-18T15:30:00Z", isValid: true, eventUuid: 1234, title: "Title", description: nil, imageUrl: nil)]))
        }

        override func validateTicket(request: Tickets.TicketObject, completion: @escaping (Result<Tickets.TicketObject, Tickets.TicketFetchError>) -> Void) {
            validateTicketCalled = true
            // Simulate a successful ticket validation with mock data
            completion(.success(request))
        }
    }

    // MARK: - Properties

    var interactor: TicketsInteractor!
    var mockPresenter: MockPresentationLogic!
    var mockWorker: MockWorker!

    override func setUp() {
        super.setUp()
        mockPresenter = MockPresentationLogic()
        mockWorker = MockWorker()

        interactor = TicketsInteractor(presenter: mockPresenter, worker: mockWorker)
    }

    override func tearDown() {
        mockPresenter = nil
        mockWorker = nil
        interactor = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchTicketsCallsPresentTickets() {
        let request = Tickets.TicketList.Request()
        interactor.fetchTickets(request: request)

        XCTAssertTrue(mockWorker.fetchTicketsCalled)
        XCTAssertTrue(mockPresenter.presentTicketsCalled)
    }

    func testValidateTicketCallsPresentTickets() {
        let mockTicket = Tickets.TicketObject.init(date: "2023-09-18T15:30:00Z", isValid: true, eventUuid: 1234, title: "Title", description: nil, imageUrl: nil)
        interactor.validateTicket(mockTicket)

        // Verify that the ticket validation is called and then presentTickets is called.
        XCTAssertTrue(mockWorker.validateTicketCalled)
        XCTAssertTrue(mockPresenter.presentTicketsCalled)
    }
}
