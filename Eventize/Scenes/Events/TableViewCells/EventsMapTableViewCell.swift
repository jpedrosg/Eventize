//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit
import MapKit

// MARK: - EventsMapInteractions Protocol

protocol EventsMapInteractions: AnyObject {
    func deselectEvent()
    func selectEvent(_ event: Events.EventObject)
    func routeToEvent(_ event: Events.EventObject)
    func setUserLocation(_ newUserCoordinate: CLLocationCoordinate2D)
    func resetUserLocation()
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
    
    // MARK: - Outlets
    
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
    @IBOutlet weak var resetLocationButton: UIButton!
    @IBOutlet weak var bannerImageHeight: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var listener: EventsMapInteractions?
    private var viewModel: Events.EventList.ViewModel?
    private var userCoordinate: CLLocationCoordinate2D?
    private var selectedEvent: Events.EventObject? {
        didSet {
            guard let event = selectedEvent else {
                customBackgroundView.isUserInteractionEnabled = false
                selectedEventLabel.text = Strings.selectedEventEmptyLabelText
                bannerImageView.image = nil
                bannerImageView.backgroundColor = .secondarySystemBackground
                titleLabel.text = nil
                addressLabel.text = nil
                priceLabel.text = nil
                extraInfoLabel.text = nil
                bottomInfosStackView.arrangedSubviews.forEach { subview in
                    subview.removeFromSuperview()
                }
                
                layoutSubviews()
                return
            }
            bannerImageView.backgroundColor = .clear
            customBackgroundView.isUserInteractionEnabled = true
            selectedEventLabel.text = Strings.selectedEventLabelText
            bannerImageView.setImage(fromUrl: event.content.imageUrl, placeholderImage: UIImage(named: Strings.eventBannerImageName(event.eventUuid))) { imageView in
                self.bannerImageHeight.constant = imageView.image == nil ? 0 : Floats.eventBannerImageHeight
            }
            titleLabel.text = event.content.title
            addressLabel.text = event.content.subtitle
            priceLabel.text = event.content.price?.asCurrency
            extraInfoLabel.text = event.content.info
            updateBottomInfoStackView(with: event.content.extraBottomInfo)
            
            setNeedsLayout()
            layoutIfNeeded()
            layoutSubviews()
            
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @IBAction func resetUserLocation(_ sender: UIButton) {
        resetLocationButton.isEnabled = false
        listener?.resetUserLocation()
    }
}

// MARK: - EventsMapDisplayLogic

extension EventsMapTableViewCell: EventsMapDisplayLogic {
    func displayEvents(viewModel: Events.EventList.ViewModel) {
        guard self.viewModel != viewModel else {
            return
        }
        self.viewModel = viewModel
        
        selectedEvent = viewModel.events.first
        updateAccessibility()
        updateMapAnnotations(viewModel)
    }
    
    func displayAddress(viewModel: Events.Address.ViewModel) {
        guard let coordinate = viewModel.coordinate,
              userCoordinate?.latitude != coordinate.latitude
                && userCoordinate?.longitude != coordinate.longitude else { return }
        userCoordinate = coordinate
        
        centerMapOn(coordinate)
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
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Strings.annotationViewIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Strings.annotationViewIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.markerTintColor = Colors.accentColor
        
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
    typealias Strings = Constants.Strings
    typealias Images = Constants.Images
    typealias Floats = Constants.Floats
    typealias Accessibility = Constants.Accessibility
    typealias Colors = Constants.Colors
    
    enum Constants {
        enum Strings {
            static let annotationViewIdentifier: String = "annotationViewIdentifier"
            static let selectedEventLabelText: String = "Evento selecionado:"
            static let selectedEventEmptyLabelText: String = "Nenhum evento selecionado."
            static let eventBannerImageNamePrefix: String = "events_banner_"
            static func eventBannerImageName(_ eventUuid: String) -> String {
                return "events_banner_\(eventUuid)"
            }
        }
        
        enum Floats {
            static let eventAddressRegionFocusDelta: CGFloat = 0.075
            static let userAddressRegionFocusDelta: CGFloat = 0.085
            static let extraLatitudeToCenterPin: CGFloat = 0.005
            static let mapHeight: CGFloat = 450
            static let fakeExpandabilityIndicatorRadius: CGFloat = 1.5
            static let customSheetBackgroundRadius: CGFloat = 20
            static let eventInfoImageWidth: CGFloat = 22
            static let eventBannerImageHeight: CGFloat = 150
        }
        
        enum Colors {
            static let accentColor: UIColor = .init(named: "AccentColor")!
        }
        
        enum Images {
            static let checkmark: UIImage = .init(systemName: "checkmark.circle.fill")!
        }
        
        enum Accessibility {
            static let cellAccessibilityHint: String = "Abre detalhes do evento."
        }
    }
    
    // MARK: - Helper Methods
    
    func updateAccessibility() {
        if let title = selectedEvent?.content.title {
            customBackgroundView.accessibilityLabel = "Evento selecionado: \(title)"
        }
    }
    
    func centerMapOn(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate,
                                        span: .init(latitudeDelta: Floats.userAddressRegionFocusDelta,
                                                    longitudeDelta: Floats.userAddressRegionFocusDelta))
        if mapView.region.center != region.center {
            mapView.setRegion(region, animated: true)
        }
    }
    
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
        imageView.setImage(fromUrl: bottomInfo.imageUrl, placeholderImage: Images.checkmark)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: Floats.eventInfoImageWidth).isActive = true
        bottomInfoStackView.addArrangedSubview(imageView)
        
        let textLabel = UILabel()
        textLabel.text = bottomInfo.text
        textLabel.font = .preferredFont(forTextStyle: .headline)
        bottomInfoStackView.addArrangedSubview(textLabel)
        
        return bottomInfoStackView
    }
    
    func setupViews() {
        mapView.delegate = self
        
        let mapLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(revealRegionDetailsWithLongPressOnMap(sender:)))
        mapView.addGestureRecognizer(mapLongPressGestureRecognizer)
        
        let eventGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapEvent))
        customBackgroundView.addGestureRecognizer(eventGestureRecognizer)
        
        mapHeightConstraint.constant = Floats.mapHeight
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        bannerImageView.contentMode = .scaleAspectFill
        
        customSheetBackgroundView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: Floats.customSheetBackgroundRadius)
        fakeExpandabilityIndicator.addRoundedCorners(for: .all, radius: Floats.fakeExpandabilityIndicatorRadius)
        
        customBackgroundView.isAccessibilityElement = true
        customBackgroundView.accessibilityHint = Accessibility.cellAccessibilityHint
    }
    
    @objc func didTapEvent() {
        HapticFeedbackHelper.shared.selectionFeedback()
        
        guard let selectedEvent = selectedEvent else { return }
        listener?.routeToEvent(selectedEvent)
    }
    
    @objc func revealRegionDetailsWithLongPressOnMap(sender: UILongPressGestureRecognizer) {
        if sender.state != .began { return }
        self.resetLocationButton.isEnabled = true
        HapticFeedbackHelper.shared.impactFeedback(.heavy)
        
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        listener?.setUserLocation(locationCoordinate)
    }
}
