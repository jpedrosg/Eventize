//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

/// Protocol for routing logic of the event module.
@objc protocol EventRoutingLogic {}

/// Protocol for passing data between components in the event module.
protocol EventDataPassing {
    var dataStore: EventDataStore? { get }
}

/// Router responsible for routing within the event module and passing data.
final class EventRouter: NSObject, EventRoutingLogic, EventDataPassing {
    weak var viewController: EventViewController?
    var dataStore: EventDataStore?
}
