//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// Protocol for handling routing logic related to tickets.
@objc protocol TicketsRoutingLogic {
    /// Routes from the tickets module.
    func routeFromTickets()
}

/// Protocol for passing data between tickets modules.
protocol TicketsDataPassing {
    var dataStore: TicketsDataStore? { get }
}

/// Router responsible for routing and data passing in the tickets module.
final class TicketsRouter: NSObject, TicketsRoutingLogic, TicketsDataPassing {
    /// The view controller associated with the router.
    weak var viewController: TicketsViewController?
    
    /// The data store for passing data between components.
    var dataStore: TicketsDataStore?
    
    /// Routes from the tickets module.
    func routeFromTickets() {
        // Pop the current view controller from the navigation stack.
        viewController?.navigationController?.popViewController(animated: true)
    }
}
