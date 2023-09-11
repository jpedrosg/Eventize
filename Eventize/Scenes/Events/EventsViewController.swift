//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventsDisplayLogic: AnyObject {
    func displayEvents(viewModel: Events.EventList.ViewModel)
    func displayAddress(viewModel: Events.Address.ViewModel)
}

final class EventsViewController: UITableViewController, EventsDisplayLogic {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private enum ScreenMode {
        case list
        case map
        
        mutating func toggle() {
            if self == .list {
                self = .map
            } else {
                self = .list
            }
        }
    }
    
    private enum Segues: String {
        case detail = "eventDetails"
    }
    
    private static let headerReuseIdentifier = "EventsTableViewHeader"
    private static let cellReuseIdentifier = "EventsTableViewCell"
    private static let mapReuseIdentifier = "EventsMapTableViewCell"
    
    private var addressName: String?
    private var viewModel: Events.EventList.ViewModel?
    private var searchBarFrame: CGRect?
    private var currentScreenMode: ScreenMode = .list {
        didSet {
            setupNavigationItem()
            
            tableView.reloadData()
            tableView.showsVerticalScrollIndicator = currentScreenMode == .list
        }
    }
    
    var interactor: EventsBusinessLogic?
    var router: (NSObjectProtocol & EventsRoutingLogic & EventsDataPassing)?
    
    private var isSearchBarHidden: Bool = false {
        didSet {
            searchBar.text = nil
            setupNavigationItem()
            interactor?.filterEvents(request: .init())
            
            if !isSearchBarHidden, let frame = searchBarFrame, frame.height > .zero {
                
                UIView.animate(withDuration: 0.25) {
                    self.searchBar.frame = self.searchBarFrame ?? .zero
                    self.searchBar.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self.tableView.setContentOffset(.zero, animated: true)
                    self.searchBar.becomeFirstResponder()
                }
            } else {
                searchBarFrame = searchBar.frame
                
                UIView.animate(withDuration: 0.25) {
                    self.searchBar.frame = .zero
                    self.searchBar.isHidden = true
                }
                
                DispatchQueue.main.async {
                    self.searchBar.resignFirstResponder()
                }
            }
        }
    }
    
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
        tableView.sectionHeaderTopPadding = .zero
        
        setupSearchBar()
        setupNavigationItem()
        setupRefreshControl()
        requestLocation()
    }
    
    // MARK: - Request data from EventsInteractor
    
    func requestEvents() {
        searchBar.text = nil
        interactor?.fetchEvents(request: .init(address: addressName))
    }
    
    func requestLocation() {
        interactor?.fetchLocation()
    }
    
    // MARK: - Display view model from EventsPresenter
    
    func displayEvents(viewModel: Events.EventList.ViewModel) {
        self.viewModel = viewModel
        
        tableView.reloadData()
    }
    
    func displayAddress(viewModel: Events.Address.ViewModel) {
        self.addressName = viewModel.name
        
        requestEvents()
        tableView.reloadData()
    }
}

// MARK: - EventsCellListener

extension EventsViewController: EventsCellListener {
    func didTapHeader() {
        // TODO: Allow entering address in future.
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource

extension EventsViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.headerReuseIdentifier, for: .init())
        
        if let headerCell = cell as? EventsHeaderDisplayLogic, let addressName {
            headerCell.displayEventHeader(viewModel: .init(address: addressName))
            headerCell.setListener(self)
            
            return cell
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return EventsTableViewHeader.headerHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentScreenMode == .list {
            return viewModel?.events.count ?? .zero
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let interaction = UIContextMenuInteraction(delegate: self)
        
        if currentScreenMode == .list {
            cell = tableView.dequeueReusableCell(withIdentifier: Self.cellReuseIdentifier, for: indexPath)
            
            if let eventsCell = cell as? EventsCellDisplayLogic,
               let event = viewModel?.events[safe: indexPath.row] {
                
                eventsCell.displayEventCell(viewModel: .init(event: event))
                eventsCell.setMenuInteraction(interaction)
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Self.mapReuseIdentifier, for: indexPath)
            
            if let mapCell = cell as? EventsMapDisplayLogic, let viewModel {
                
                mapCell.displayEvents(viewModel: viewModel)
                mapCell.setMenuInteraction(interaction)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor?.selectEvent(at: indexPath.row)
        router?.routeToEvent()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension EventsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        handleSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        handleSearch()
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension EventsViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(previewProvider: {
            // Converts point from the view Y to tableView relative Y positions.
            let point = self.tableView.convert(location, from: interaction.view)
            guard let indexPath = self.tableView.indexPathForRow(at: point) else { return nil }
            
            self.interactor?.selectEvent(at: indexPath.row)
            return self.router?.previewEvent()
        })
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            // Route to Event when previewed context menu is tapped on.
            self.router?.routeToEvent(animator.previewViewController as? EventViewController)
        }
    }
}

// MARK: - Private API

private extension EventsViewController {
    func setupNavigationItem() {
        self.navigationItem.title = currentScreenMode == .list ? "Eventos" : "Mapa"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let ticketsButton = UIBarButtonItem(image: UIImage(systemName: "ticket"))
        ticketsButton.target = self
        ticketsButton.action = #selector(didTapTickets)
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: isSearchBarHidden ? "magnifyingglass.circle" : "magnifyingglass.circle.fill"))
        searchButton.target = self
        searchButton.action = #selector(didTapSearch)
        
        let screenModeButton = UIBarButtonItem(image: UIImage(systemName: currentScreenMode == .list ? "tablecells.fill" : "map.fill"))
        screenModeButton.target = self
        screenModeButton.action = #selector(didTapScreenMode)
        self.navigationItem.setRightBarButtonItems([ticketsButton, searchButton, screenModeButton], animated: true)
    }
    
    func setupRefreshControl() {
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        isSearchBarHidden = true
    }
    
    func handleSearch() {
        guard let term = searchBar.text, !term.isEmpty else {
            isSearchBarHidden.toggle()
            return
        }
        
        interactor?.filterEvents(request: .init(searchTerm: searchBar.text))
    }
    
    @objc func refresh(sender: AnyObject) {
        requestEvents()
    }
    
    @objc func didTapTickets(sender: UIButton) {
        router?.routeToTickets()
    }
    
    @objc func didTapSearch(sender: UIButton) {
        isSearchBarHidden.toggle()
    }
    
    @objc func didTapScreenMode(sender: UIButton) {
        currentScreenMode.toggle()
    }
}
