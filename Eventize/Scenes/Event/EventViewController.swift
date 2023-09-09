//
//  EventViewController.swift
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

protocol EventDisplayLogic: AnyObject
{
    func displayEvent(viewModel: Event.EventDetails.ViewModel)
//    func displaySomethingElse(viewModel: Event.SomethingElse.ViewModel)
}

class EventViewController: UIViewController, EventDisplayLogic {
    var interactor: EventBusinessLogic?
    var router: (NSObjectProtocol & EventRoutingLogic & EventDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    @IBOutlet weak var test: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup Clean Code Design Pattern 

    private func setup() {
        let viewController = self
        let interactor = EventInteractor()
        let presenter = EventPresenter()
        let router = EventRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
//        doSomethingElse()
    }
    
    //MARK: - receive events from UI
    
    //@IBOutlet weak var nameTextField: UITextField!
//
//    @IBAction func someButtonTapped(_ sender: Any) {
//
//    }
//
//    @IBAction func otherButtonTapped(_ sender: Any) {
//
//    }
    
    // MARK: - request data from EventInteractor

    func doSomething() {
        let request = Event.EventDetails.Request()
        interactor?.doSomething(request: request)
    }
//
//    func doSomethingElse() {
//        let request = Event.SomethingElse.Request()
//        interactor?.doSomethingElse(request: request)
//    }

    // MARK: - display view model from EventPresenter

    func displayEvent(viewModel: Event.EventDetails.ViewModel) {
        test.text = viewModel.event.content.title
    }
//
//    func displaySomethingElse(viewModel: Event.SomethingElse.ViewModel) {
//        // do sometingElse with viewModel
//    }
}
