//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

@objc protocol EventsRoutingLogic {
    func previewEvent() -> EventViewController
    func routeToEvent()
    func routeToEvent(_ destinationVC: EventViewController?)
    func routeToTickets()
}

protocol EventsDataPassing {
    var dataStore: EventsDataStore? { get }
}

final class EventsRouter: NSObject, EventsRoutingLogic, EventsDataPassing {
    weak var viewController: EventsViewController?
    var dataStore: EventsDataStore?

    // MARK: - Routing (navigating to other screens)

    /// Create and return a view controller for previewing an event.
    /// - Returns: A view controller for event preview.
    func previewEvent() -> EventViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToEvent(source: dataStore!, destination: &destinationDS)
        return destinationVC
    }
    
    /// Navigate to the event screen.
    func routeToEvent() {
        routeToEvent(nil)
    }

    /// Navigate to the event screen with an optional destination view controller.
    /// - Parameter destinationVC: An optional destination view controller.
    func routeToEvent(_ destinationVC: EventViewController?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = destinationVC ?? storyboard.instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToEvent(source: dataStore!, destination: &destinationDS)
        navigateToEvent(source: viewController!, destination: destinationVC)
    }
        
    /// Navigate to the tickets screen.
    func routeToTickets() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "TicketsViewController") as! TicketsViewController
        navigateToTickets(source: viewController!, destination: destinationVC)
    }

    // MARK: - Navigation to other screens

    /// Navigate from the source view controller to the destination event view controller.
    /// - Parameters:
    ///   - source: The source view controller.
    ///   - destination: The destination event view controller.
    func navigateToEvent(source: EventsViewController, destination: EventViewController) {
        source.show(destination, sender: nil)
    }
    
    /// Navigate from the source view controller to the destination tickets view controller.
    /// - Parameters:
    ///   - source: The source view controller.
    ///   - destination: The destination tickets view controller.
    func navigateToTickets(source: EventsViewController, destination: TicketsViewController) {
        source.show(destination, sender: nil)
    }

    // MARK: - Passing data to other screens

    /// Pass data from the source data store to the destination event data store.
    /// - Parameters:
    ///   - source: The source data store.
    ///   - destination: The destination event data store.
    func passDataToEvent(source: EventsDataStore, destination: inout EventDataStore) {
        destination.event = source.selectedEvent
    }
}
