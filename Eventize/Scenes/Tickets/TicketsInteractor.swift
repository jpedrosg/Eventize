//
//  TicketsInteractor.swift
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

protocol TicketsBusinessLogic {
    func doSomething(request: Tickets.Something.Request)
//    func doSomethingElse(request: Tickets.SomethingElse.Request)
}

protocol TicketsDataStore {
    //var name: String { get set }
}

class TicketsInteractor: TicketsBusinessLogic, TicketsDataStore {
    var presenter: TicketsPresentationLogic?
    var worker: TicketsWorker?
    //var name: String = ""

    // MARK: Do something (and send response to TicketsPresenter)

    func doSomething(request: Tickets.Something.Request) {
        worker = TicketsWorker()
        worker?.doSomeWork()

        let response = Tickets.Something.Response()
        presenter?.presentSomething(response: response)
    }
//
//    func doSomethingElse(request: Tickets.SomethingElse.Request) {
//        worker = TicketsWorker()
//        worker?.doSomeOtherWork()
//
//        let response = Tickets.SomethingElse.Response()
//        presenter?.presentSomethingElse(response: response)
//    }
}
