//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - EventsDisplayLogic Protocol

protocol EventsDisplayLogic: AnyObject {
    func displayEvents(viewModel: Events.EventList.ViewModel)
    func displayAddress(viewModel: Events.Address.ViewModel)
}

// MARK: - EventsViewController Class

final class EventsViewController: UITableViewController, EventsDisplayLogic {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Private Properties
    
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
    
    private var currentGeolocation: GeoLocation?
    private var currentCoordinate: CLLocationCoordinate2D?
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
    
    private var isFilteredByFavorites: Bool = false {
        didSet {
            setupNavigationItem()
        }
    }
    
    private var isSearchBarHidden: Bool = false {
        didSet {
            searchBar.text = nil
            setupNavigationItem()
            interactor?.filterEvents(request: .init(isFavorite: isFilteredByFavorites))
            
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
    
    // MARK: - Object Lifecycle
    
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
    
    // MARK: - View Lifecycle
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor?.filterEvents(request: .init(searchTerm: searchBar.text, isFavorite: isFilteredByFavorites))
    }
    
    // MARK: - Request Data from EventsInteractor
    
    func requestEvents() {
        searchBar.text = nil
        interactor?.fetchEvents(request: .init(address: currentGeolocation?.name, isFavorite: false))
    }
    
    func requestLocation() {
        interactor?.fetchLocation()
    }
    
    // MARK: - Display ViewModel from EventsPresenter
    
    func displayEvents(viewModel: Events.EventList.ViewModel) {
        self.viewModel = viewModel
        
        if viewModel.events.count == .zero {
            // Switches back to list when the result is empty.
            currentScreenMode = .list
        }
        
        setupNavigationItem()
        tableView.reloadData()
    }
    
    func displayAddress(viewModel: Events.Address.ViewModel) {
        currentCoordinate = viewModel.coordinate
        currentGeolocation = viewModel.geolocation
        
        requestEvents()
        tableView.reloadData()
    }
}

// MARK: - EventsCellListener

extension EventsViewController: EventsCellListener {
    func didTapHeader() {
        // TODO: Allow entering address in the future.
    }
}

// MARK: - UITableViewDelegate + UITableViewDataSource

extension EventsViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.headerReuseIdentifier, for: .init())
        
        if let headerCell = cell as? EventsHeaderDisplayLogic, let addressName = currentGeolocation?.name {
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
        let numberOfEvents = viewModel?.events.count ?? .zero
        
        if currentScreenMode == .list {
            return numberOfEvents
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
                eventsCell.setListener(self)
                eventsCell.displayEventCell(viewModel: .init(event: event), isFilteredByFavorites: isFilteredByFavorites, isSearching: !isSearchBarHidden)
                eventsCell.setMenuInteraction(interaction)
            }
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Self.mapReuseIdentifier, for: indexPath)
            
            if let mapCell = cell as? EventsMapDisplayLogic, let viewModel {
                mapCell.displayAddress(viewModel: .init(geolocation: currentGeolocation, coordinate: currentCoordinate))
                mapCell.displayEvents(viewModel: viewModel)
                mapCell.setListener(self)
                mapCell.setMenuInteraction(interaction)
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentScreenMode == .list {
            HapticFeedbackHelper.shared.impactFeedback(.light)
            interactor?.selectEvent(at: indexPath.row)
            router?.routeToEvent()
        }
        
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
            if self.currentScreenMode == .list {
                // Converts point from the view Y to tableView relative Y positions.
                let point = self.tableView.convert(location, from: interaction.view)
                guard let indexPath = self.tableView.indexPathForRow(at: point) else { return nil }
                
                self.interactor?.selectEvent(at: indexPath.row)
            }
            return self.router?.previewEvent()
        })
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            // Route to Event when previewed context menu is tapped on.
            HapticFeedbackHelper.shared.impactFeedback(.light)
            self.router?.routeToEvent(animator.previewViewController as? EventViewController)
        }
    }
}

// MARK: - EventsCellInteractions

extension EventsViewController: EventsCellInteractions {
    func setFavorite(_ event: Events.EventObject) {
        interactor?.setFavorite(event)
    }
    
    func removeFavorite(_ event: Events.EventObject) {
        interactor?.removeFavorite(event)
    }
}

// MARK: - EventsMapInteractions

extension EventsViewController: EventsMapInteractions {
    func selectEvent(_ event: Events.EventObject) {
        interactor?.selectEvent(event)
        tableView.reloadData()
        tableView.scrollToRow(at: .init(row: .zero, section: .zero), at: .bottom, animated: true)
    }
    
    func deselectEvent() {
        tableView.scrollToRow(at: .init(row: .zero, section: .zero), at: .top, animated: true)
    }
    
    func routeToEvent(_ event: Events.EventObject) {
        HapticFeedbackHelper.shared.impactFeedback(.light)
        router?.routeToEvent()
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
        
        let favoriteButton = UIBarButtonItem(image: isFilteredByFavorites ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"))
        favoriteButton.target = self
        favoriteButton.action = #selector(didTapFavorite)
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: isSearchBarHidden ? "magnifyingglass.circle" : "magnifyingglass.circle.fill"))
        searchButton.target = self
        searchButton.action = #selector(didTapSearch)
        
        let screenModeButton = UIBarButtonItem(image: UIImage(systemName: currentScreenMode == .list ? "tablecells.fill" : "map.fill"))
        screenModeButton.target = self
        screenModeButton.action = #selector(didTapScreenMode)
        
        var buttons: [UIBarButtonItem] = [ticketsButton, searchButton, screenModeButton]
        
        if currentScreenMode == .list {
            buttons.append(favoriteButton)
        } else {
            buttons = [ticketsButton, searchButton, screenModeButton]
        }
        
        self.navigationItem.setRightBarButtonItems(buttons, animated: true)
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
        
        interactor?.filterEvents(request: .init(searchTerm: searchBar.text, isFavorite: isFilteredByFavorites))
    }
    
    @objc func refresh(sender: AnyObject) {
        requestEvents()
    }
    
    @objc func didTapTickets(sender: UIButton) {
        HapticFeedbackHelper.shared.impactFeedback(.medium)
        
        router?.routeToTickets()
    }
    
    @objc func didTapSearch(sender: UIButton) {
        HapticFeedbackHelper.shared.impactFeedback(.light)
        
        isSearchBarHidden.toggle()
    }
    
    @objc func didTapScreenMode(sender: UIButton) {
        HapticFeedbackHelper.shared.impactFeedback(.medium)
        
        currentScreenMode.toggle()
    }
    
    @objc func didTapFavorite() {
        HapticFeedbackHelper.shared.impactFeedback(.light)
        
        isFilteredByFavorites.toggle()
        interactor?.filterEvents(request: .init(searchTerm: searchBar.text, isFavorite: isFilteredByFavorites))
    }
}
