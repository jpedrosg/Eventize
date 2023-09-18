//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// Protocol for displaying tickets.
protocol TicketsDisplayLogic: AnyObject {
    func displayTickets(viewModel: Tickets.TicketList.ViewModel)
}

/// View controller for displaying a list of tickets.
final class TicketsViewController: UITableViewController, TicketsDisplayLogic {
    static let reuseIdentifier: String = "TicketsViewCell"
    
    private var viewModel: Tickets.TicketList.ViewModel?
    var interactor: TicketsBusinessLogic?
    var router: (NSObjectProtocol & TicketsRoutingLogic & TicketsDataPassing)?

    // MARK: - Object lifecycle

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
        let interactor = TicketsInteractor()
        let presenter = TicketsPresenter()
        let router = TicketsRouter()
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
        
        requestTickets()
        setupNavigationItem()
    }

    func requestTickets() {
        let request = Tickets.TicketList.Request()
        interactor?.fetchTickets(request: request)
    }

    func displayTickets(viewModel: Tickets.TicketList.ViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

// MARK: - Private API

private extension TicketsViewController {
    func setupNavigationItem() {
        self.navigationItem.title = "Ingressos"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    
        let ticketsButton = UIBarButtonItem(image: UIImage(systemName: "ticket.fill"))
        ticketsButton.target = self
        ticketsButton.action = #selector(didTapTickets)
        
        self.navigationItem.setRightBarButtonItems([ticketsButton], animated: true)
    }
    
    @objc func didTapTickets(sender: UIButton) {
        HapticFeedbackHelper.shared.selectionFeedback()
        router?.routeFromTickets()
    }
}

// MARK: - UITableViewDataSouce + UITableViewDelegate

extension TicketsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tickets.count ?? .zero
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
        
        if let ticketCell = cell as? TicketsViewCellDisplayLogic, let ticket = viewModel?.tickets[safe: indexPath.row] {
            ticketCell.displayTicket(viewModel: .init(ticket: ticket))
            
            if let listener = interactor as? TicketsViewCellInteractions {
                ticketCell.setListener(listener)
            }
        }
        
        return cell
    }
}
