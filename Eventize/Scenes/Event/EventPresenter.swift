//
//  EventPresenter.swift
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

protocol EventPresentationLogic {
    func presentSomething(response: Event.Something.Response)
}

class EventPresenter: EventPresentationLogic {
    weak var viewController: EventDisplayLogic?

    // MARK: Parse and calc respnse from EventInteractor and send simple view model to EventViewController to be displayed

    func presentSomething(response: Event.Something.Response) {
        let viewModel = Event.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
//
//    func presentSomethingElse(response: Event.SomethingElse.Response) {
//        let viewModel = Event.SomethingElse.ViewModel()
//        viewController?.displaySomethingElse(viewModel: viewModel)
//    }
}
