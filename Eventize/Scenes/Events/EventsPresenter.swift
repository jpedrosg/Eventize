//
//  EventsPresenter.swift
//  Eventize
//
//  Created by JP Giarrante on 09/09/23.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol EventsPresentationLogic {
    func presentEvents(response: Events.EventList.Response)
}

final class EventsPresenter: EventsPresentationLogic {
    weak var viewController: EventsDisplayLogic?

    // MARK: Parse and calc respnse from EventsInteractor and send simple view model to EventsViewController to be displayed

    func presentEvents(response: Events.EventList.Response) {
        viewController?.displayEvents(viewModel: .init(events: response.events))
    }
}
