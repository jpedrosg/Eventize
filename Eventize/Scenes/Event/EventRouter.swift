//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

@objc protocol EventRoutingLogic {}

protocol EventDataPassing {
    var dataStore: EventDataStore? { get }
}

final class EventRouter: NSObject, EventRoutingLogic, EventDataPassing {
    weak var viewController: EventViewController?
    var dataStore: EventDataStore?
}
