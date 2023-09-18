//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest
import CoreLocation
import Contacts
@testable import Eventize

class EventsInteractorTests: XCTestCase {

    // MARK: - Test Doubles

    class MockPresentationLogic: EventsPresentationLogic {
        var presentEventsCalled = false
        var presentAddressCalled = false

        func presentEvents(response: Events.EventList.Response) {
            presentEventsCalled = true
        }

        func presentAddress(response: Events.Address.Response) {
            presentAddressCalled = true
        }
    }

    class MockWorker: EventsWorker {
        var fetchEventsCalled = false

        override func fetchEvents(request: Events.EventList.Request, completion: @escaping (Result<[Events.EventObject], Events.EventFetchError>) -> Void) {
            fetchEventsCalled = true
            completion(.success([.init(eventUuid: "uuid",
                                       content: .init(imageUrl: nil,
                                                      title: "title",
                                                      subtitle: nil,
                                                      price: nil,
                                                      info: nil,
                                                      extraBottomInfo: nil,
                                                      latitude: nil,
                                                      longitude: nil))]))
        }

        override func filterEvents(events: [Events.EventObject], filters: Events.EventList.Request) -> [Events.EventObject] {
            // Mock the filterEvents method if needed
            return []
        }
    }

    class MockLocationManager: LocationManaging {
        init() {
            hasManualLocationSelected = false
        }
        
        var requestLocationCalled = false
        var setUserLocationCalled = false
        
        var delegate: Eventize.LocationManagerDelegate?
        
        var currentCoordinate: CLLocationCoordinate2D?
        
        var currentGeolocation: Eventize.GeoLocation?
        
        var hasManualLocationSelected: Bool
        
        func requestLocation() {
            requestLocationCalled = true
        }
        
        func setUserLocation(_ newUserCoordinate: CLLocationCoordinate2D) {
            setUserLocationCalled = true
        }
    }
    
    class MockCache: UserDefaultsManagerProtocol {
        var getCachedLocationCalled = false
        var setCachedLocationCalled = false
        var getUserPreferencesCalled = false
        var setUserPreferencesCalled = false
        
        func getCachedLocation() -> CLLocation? {
            getCachedLocationCalled = true
            return .init(latitude: 1234, longitude: 1234)
        }
        
        func setCachedLocation(_ location: CLLocation?) {
            setCachedLocationCalled = true
        }
        
        func getUserPreferences() -> Eventize.UserPreferences? {
            getUserPreferencesCalled = true
            return .init(favoriteEventsUuids: ["1234"])
        }
        
        func setUserPreferences(_ preferences: Eventize.UserPreferences?) {
            setUserPreferencesCalled = true
        }
    }

    // MARK: - Properties

    var interactor: EventsInteractor!
    var mockPresenter: MockPresentationLogic!
    var mockWorker: MockWorker!
    var mockLocationManager: MockLocationManager!
    var mockCache: MockCache!

    override func setUp() {
        super.setUp()
        mockPresenter = MockPresentationLogic()
        mockWorker = MockWorker()
        mockLocationManager = MockLocationManager()
        mockCache = MockCache()
        
        interactor = EventsInteractor(presenter: mockPresenter, worker: mockWorker, cache: mockCache, locationManager: mockLocationManager)
    }

    override func tearDown() {
        mockPresenter = nil
        mockWorker = nil
        mockLocationManager = nil
        interactor = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testFetchEventsCallsPresentEvents() {
        let request = Events.EventList.Request(isFavorite: false)
        interactor.fetchEvents(request: request)

        XCTAssertTrue(mockWorker.fetchEventsCalled)
        XCTAssertTrue(mockPresenter.presentEventsCalled)
        XCTAssertFalse(mockPresenter.presentAddressCalled)
        XCTAssertFalse(mockLocationManager.requestLocationCalled)
    }

    func testFetchLocationCallsPresentAddress() {
        interactor.fetchLocation()

        XCTAssertTrue(mockLocationManager.delegate === interactor)
        XCTAssertFalse(mockPresenter.presentEventsCalled)
        XCTAssertTrue(mockLocationManager.requestLocationCalled)
    }
    
    func testSetUserLocation() {
        let newUserCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        interactor.setUserLocation(newUserCoordinate)
        
        // Verify that the location manager's setUserLocation method was called
        XCTAssertTrue(mockLocationManager.setUserLocationCalled)
    }

    func testResetUserLocation() {
        interactor.resetUserLocation()
        
        // Verify that the location manager's requestLocation method was called.
        XCTAssertTrue(mockLocationManager.requestLocationCalled)
    }

    func testSetFavorite() {
        let mockEvent = Events.EventObject.init(eventUuid: "uuid",
                                                content: .init(imageUrl: nil,
                                                               title: "title",
                                                               subtitle: nil,
                                                               price: nil,
                                                               info: nil,
                                                               extraBottomInfo: nil,
                                                               latitude: nil,
                                                               longitude: nil))
        interactor.setFavorite(mockEvent)
        
        // Verify that the mock event is added to favorites, and the filterEvents method is called.
        XCTAssertTrue(mockCache.setUserPreferencesCalled)
        XCTAssertTrue(mockPresenter.presentEventsCalled)
    }

    func testRemoveFavorite() {
        let mockEvent = Events.EventObject.init(eventUuid: "uuid",
                                                content: .init(imageUrl: nil,
                                                               title: "title",
                                                               subtitle: nil,
                                                               price: nil,
                                                               info: nil,
                                                               extraBottomInfo: nil,
                                                               latitude: nil,
                                                               longitude: nil))
        interactor.removeFavorite(mockEvent)
        
        // Verify that the mock event is removed from favorites, and the filterEvents method is called.
        XCTAssertTrue(mockCache.getUserPreferencesCalled)
        XCTAssertTrue(mockCache.setUserPreferencesCalled)
        XCTAssertTrue(mockPresenter.presentEventsCalled)
    }

    func testSelectEventAtIndex() {
        interactor.events = [.init(eventUuid: "uuid",
                                   content: .init(imageUrl: nil,
                                                  title: "title",
                                                  subtitle: nil,
                                                  price: nil,
                                                  info: nil,
                                                  extraBottomInfo: nil,
                                                  latitude: nil,
                                                  longitude: nil))]
        let index = 0
        interactor.selectEvent(at: index)
        
        // Verify that the selected event is updated based on the index.
        XCTAssertEqual(interactor.selectedEvent?.eventUuid, "uuid")
    }

    func testSelectEventObject() {
        let mockEvent = Events.EventObject.init(eventUuid: "uuid",
                                                content: .init(imageUrl: nil,
                                                               title: "title",
                                                               subtitle: nil,
                                                               price: nil,
                                                               info: nil,
                                                               extraBottomInfo: nil,
                                                               latitude: nil,
                                                               longitude: nil))
        interactor.selectEvent(mockEvent)
        
        // Verify that the selected event is updated based on the provided event object.
        XCTAssertEqual(interactor.selectedEvent?.eventUuid, "uuid")
    }

}
