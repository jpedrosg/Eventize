import UIKit
import MapKit

// MARK: - EventsMapInteractions Protocol

protocol EventsMapInteractions: AnyObject {
    func deselectEvent()
    func selectEvent(_ event: Events.EventObject)
    func routeToEvent(_ event: Events.EventObject)
}

// MARK: - EventsMapDisplayLogic Protocol

protocol EventsMapDisplayLogic: AnyObject {
    func displayAddress(viewModel: Events.Address.ViewModel)
    func displayEvents(viewModel: Events.EventList.ViewModel)
    func setMenuInteraction(_ interaction: UIContextMenuInteraction)
    func setListener(_ listener: EventsMapInteractions)
}

// MARK: - EventsMapTableViewCell Class

final class EventsMapTableViewCell: UITableViewCell {

    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customSheetTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedEventLabel: UILabel!
    @IBOutlet weak var fakeExpandabilityIndicator: UIView!
    @IBOutlet weak var customSheetBackgroundView: UIView!
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var bannerImageView: NetworkImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var bottomInfosStackView: UIStackView!
    
    // MARK: - Private Properties
    
    private var listener: EventsMapInteractions?
    private var viewModel: Events.EventList.ViewModel?
    private var userCoordinate: CLLocationCoordinate2D?
    private var selectedEvent: Events.EventObject? {
        didSet {
            guard let event = selectedEvent else { return }
            bannerImageView.setImage(fromUrl: event.content.imageUrl, placeholderImage: UIImage(named: Constants.eventBannerImageName(event.eventUuid)))
            titleLabel.text = event.content.title
            addressLabel.text = event.content.subtitle
            priceLabel.text = event.content.price?.asCurrency
            extraInfoLabel.text = event.content.info
            updateBottomInfoStackView(with: event.content.extraBottomInfo)
            
            setNeedsLayout()
            layoutIfNeeded()
            
            listener?.selectEvent(event)
        }
    }
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .systemBackground
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = .systemBackground
    }
}

// MARK: - EventsMapDisplayLogic

extension EventsMapTableViewCell: EventsMapDisplayLogic {
    func displayEvents(viewModel: Events.EventList.ViewModel) {
        guard self.viewModel != viewModel else {
            setRegionToSelectedEvent()
            return
        }
        self.viewModel = viewModel
        
        selectedEvent = viewModel.events.first
        updateMapAnnotations(viewModel)
    }
    
    func displayAddress(viewModel: Events.Address.ViewModel) {
        guard let coordinate = viewModel.coordinate,
              userCoordinate?.latitude != coordinate.latitude
                && userCoordinate?.longitude != coordinate.longitude else { return }
        userCoordinate = coordinate
        
        mapView.setRegion(.init(center: coordinate,
                                span: .init(latitudeDelta: Constants.userAddressRegionFocusDelta,
                                            longitudeDelta: Constants.userAddressRegionFocusDelta)), animated: true)
    }
    
    func setMenuInteraction(_ interaction: UIContextMenuInteraction) {
        customBackgroundView.addInteraction(interaction)
    }
    
    func setListener(_ listener: EventsMapInteractions) {
        self.listener = listener
    }
}

// MARK: - MKMapViewDelegate

extension EventsMapTableViewCell: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationViewIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationViewIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.markerTintColor = UIColor(named: "AccentColor")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        self.selectedEvent = viewModel?.events.filterEvent(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        listener?.deselectEvent()
    }
}

// MARK: - Private Extension

private extension EventsMapTableViewCell {
    // MARK: - Constants
    
    private enum Constants {
        static let eventBannerImageNamePrefix = "events_banner_"
        static let eventAddressRegionFocusDelta: CGFloat = 0.075
        static let userAddressRegionFocusDelta: CGFloat = 0.085
        static let extraLatitudeToCenterPin: CGFloat = 0.005
        static let annotationViewIdentifier: String = "annotationViewIdentifier"
        static let selectedEventLabelText = "Evento selecionado:"
        static let mapHeight: CGFloat = 450
        static let fakeExpandabilityIndicatorRadius: CGFloat = 1.5
        static let customSheetBackgroundRadius: CGFloat = 20
        static let eventInfoImageWidth: CGFloat = 22
        static let eventInfoImageHeight: CGFloat = 16
        
        static func eventBannerImageName(_ eventUuid: String) -> String {
            return "events_banner_\(eventUuid)"
        }
    }
    
    // MARK: - Helper Methods
    
    func updateMapAnnotations(_ viewModel: Events.EventList.ViewModel) {
        removeAllAnnotations()
        for event in viewModel.events {
            let pin = MKPointAnnotation()
            pin.title = event.content.title
            pin.subtitle = event.content.subtitle
            if let latitude = event.content.latitude,
               let longitude = event.content.longitude {
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            mapView.addAnnotation(pin)
        }
    }
    
    func removeAllAnnotations() {
        let annotations = mapView.annotations.filter {
            $0 !== self.mapView.userLocation
        }
        mapView.removeAnnotations(annotations)
    }
    
    func updateBottomInfoStackView(with bottomInfo: [Events.EventObject.EventContent.BottomInfo]?) {
        bottomInfosStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        guard let bottomInfos = bottomInfo, !bottomInfos.isEmpty else {
            bottomInfosStackView.isHidden = true
            return
        }
        
        let spacerView = UILabel()
        for (index, bottomInfo) in bottomInfos.prefix(3).enumerated() {
            let bottomInfoStackView = createBottomInfoStackView(with: bottomInfo)
            bottomInfosStackView.addArrangedSubview(bottomInfoStackView)
            
            if index == bottomInfos.prefix(3).count - 1 {
                bottomInfosStackView.addArrangedSubview(spacerView)
            }
        }
        bottomInfosStackView.isHidden = false
    }
    
    func createBottomInfoStackView(with bottomInfo: Events.EventObject.EventContent.BottomInfo) -> UIStackView {
        let bottomInfoStackView = UIStackView()
        bottomInfoStackView.alignment = .fill
        bottomInfoStackView.distribution = .fillProportionally
        
        let imageView = NetworkImageView()
        imageView.setImage(fromUrl: bottomInfo.imageUrl, placeholderImage: UIImage(systemName: "checkmark.circle.fill")!)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: Constants.eventInfoImageHeight).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.eventInfoImageWidth).isActive = true
        bottomInfoStackView.addArrangedSubview(imageView)
        
        let textLabel = UILabel()
        textLabel.text = bottomInfo.text
        textLabel.font = .preferredFont(forTextStyle: .headline)
        bottomInfoStackView.addArrangedSubview(textLabel)
        
        return bottomInfoStackView
    }
    
    func setupViews() {
        mapView.delegate = self
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapEvent))
        customBackgroundView.addGestureRecognizer(gestureRecognizer)
        customBackgroundView.isUserInteractionEnabled = true
        
        mapHeightConstraint.constant = Constants.mapHeight
        selectedEventLabel.text = Constants.selectedEventLabelText
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        bannerImageView.contentMode = .scaleAspectFill
        
        customSheetBackgroundView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: Constants.customSheetBackgroundRadius)
        fakeExpandabilityIndicator.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: Constants.fakeExpandabilityIndicatorRadius)
    }
    
    func setRegionToSelectedEvent() {
        if let latitude = selectedEvent?.content.latitude,
           let longitude = selectedEvent?.content.longitude {
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude + Constants.extraLatitudeToCenterPin, longitude: longitude)
            if let annotation = mapView.annotations(in: .init(origin: .init(coordinate),
                                                              size: .init(width: 1, height: 1))).first as? MKAnnotation {
                mapView.selectedAnnotations = [annotation]
            }
            mapView.setRegion(.init(center: coordinate, span: .init(latitudeDelta: Constants.eventAddressRegionFocusDelta, longitudeDelta: Constants.eventAddressRegionFocusDelta)), animated: true)
        }
    }
    
    @objc func didTapEvent() {
        guard let selectedEvent = selectedEvent else { return }
        listener?.routeToEvent(selectedEvent)
    }
}
