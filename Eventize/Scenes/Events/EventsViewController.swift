//
//  EventsViewController.swift
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

protocol EventsDisplayLogic: AnyObject
{
    func displayEvents(viewModel: Events.EventList.ViewModel)
}

class EventsViewController: UITableViewController, EventsDisplayLogic {
    
    private enum Segues: String {
        case detail = "eventDetails"
    }
    
    private static let reuseIdentifier = "EventsTableViewCell"
    var interactor: EventsBusinessLogic?
    var router: (NSObjectProtocol & EventsRoutingLogic & EventsDataPassing)?
    var viewModel: Events.EventList.ViewModel?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup Clean Code Design Pattern
    
    private func setup() {
        let viewController = self
        let interactor = EventsInteractor()
        let presenter = EventsPresenter()
        let router = EventsRouter()
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        
        setupNavigationItem()
        requestEvents()
    }
    
    // MARK: - request data from EventsInteractor
    
    func requestEvents() {
        let request = Events.EventList.Request()
        interactor?.fetchEvents(request: request)
    }
    
    // MARK: - display view model from EventsPresenter
    
    func displayEvents(viewModel: Events.EventList.ViewModel) {
        self.viewModel = viewModel
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource

extension EventsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.events.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        
        if let eventsCell = cell as? EventsCellDisplayLogic,
            let event = viewModel?.events[safe: indexPath.row] {
            
            eventsCell.display(viewModel: event.content)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.selectEvent(at: indexPath.row)
        router?.routeToEvent()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private API

private extension EventsViewController {
    func setupNavigationItem() {
        self.navigationItem.title = "Eventos"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let ticketsButton = UIBarButtonItem(image: UIImage(systemName: "ticket"))
        ticketsButton.target = self
        ticketsButton.action = #selector(didTapTickets)
        
        let searchButton = UIBarButtonItem(systemItem: .search)
        self.navigationItem.setRightBarButtonItems([ticketsButton, searchButton], animated: true)
    }
    
    @objc func didTapTickets(sender: UIButton) {
        router?.routeToTickets()
    }
    
    @objc func didTapSearch(sender: UIButton) {
        // router?.routeToSearch()
    }
}