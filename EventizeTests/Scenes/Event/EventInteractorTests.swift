//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import XCTest
import CoreLocation
@testable import Eventize

class EventInteractorTests: XCTestCase {
    
    // MARK: - Test Doubles
    
    class MockPresentationLogic: EventPresentationLogic {
        var presentEventCalled = false
        var presentFavoriteButtonCalled = false
        
        func presentEvent(response: Event.EventDetails.Response) {
            presentEventCalled = true
        }
        
        func presentFavoriteButton() {
            presentFavoriteButtonCalled = true
        }
    }
    
    class MockWorker: EventWorker {
        override func fetchDetails(completion: @escaping (Result<Event.DetailsContent, Event.EventFetchError>) -> Void) {
            completion(.success(.init(description: "")))
        }
    }
    
    class MockCache: UserDefaultsManagerProtocol {
        func getCachedLocation() -> CLLocation? {
            return .init(latitude: 1234, longitude: 1234)
        }
        
        func setCachedLocation(_ location: CLLocation?) {
            return
        }
        
        func getUserPreferences() -> Eventize.UserPreferences? {
            return .init(favoriteEventsUuids: ["1234"])
        }
        
        func setUserPreferences(_ preferences: Eventize.UserPreferences?) {
            return
        }
    }
    
    // MARK: - Properties
    
    var interactor: EventInteractor!
    var mockPresenter: MockPresentationLogic!
    var mockWorker: MockWorker!
    var mockCache: MockCache!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockPresentationLogic()
        mockWorker = MockWorker()
        mockCache = MockCache()
        
        interactor = EventInteractor(presenter: mockPresenter,
                                     worker: mockWorker,
                                     cache: mockCache,
                                     event: .init(eventUuid: "uuid",
                                                  content: .init(imageUrl: nil,
                                                                 title: "title",
                                                                 subtitle: nil,
                                                                 price: nil,
                                                                 info: nil,
                                                                 extraBottomInfo: nil,
                                                                 latitude: nil,
                                                                 longitude: nil)))
    }
    
    override func tearDown() {
        mockPresenter = nil
        interactor = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchEventCallsPresentEvent() {
        interactor.fetchEvent()
        
        XCTAssertTrue(mockPresenter.presentEventCalled)
        XCTAssertFalse(mockPresenter.presentFavoriteButtonCalled)
    }
    
    func testFetchDetailsCallsPresentEvent() {
        interactor.fetchDetails()
        
        XCTAssertTrue(mockPresenter.presentEventCalled)
        XCTAssertFalse(mockPresenter.presentFavoriteButtonCalled)
    }
    
    func testSetFavoriteCallsPresentFavoriteButton() {
        interactor.setFavorite()
        
        XCTAssertTrue(mockPresenter.presentFavoriteButtonCalled)
        XCTAssertFalse(mockPresenter.presentEventCalled)
    }
    
    func testRemoveFavoriteCallsPresentFavoriteButton() {
        interactor.removeFavorite()
        
        XCTAssertTrue(mockPresenter.presentFavoriteButtonCalled)
        XCTAssertFalse(mockPresenter.presentEventCalled)
    }
}
