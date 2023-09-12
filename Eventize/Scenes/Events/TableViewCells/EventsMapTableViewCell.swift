//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit
import MapKit

// MARK: - EventsMapInteractions Protocol

protocol EventsMapInteractions: AnyObject {
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
    
    private var listener: EventsMapInteractions?
    private var viewModel: Events.EventList.ViewModel?
    private var selectedEvent: Events.EventObject? {
        didSet {
            guard let event = selectedEvent else { return }
            bannerImageView.setImage(fromUrl: event.content.imageUrl, placeholderImage: UIImage(named: "events_banner_\(event.eventUuid)"))
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
    private var userCoordinate: CLLocationCoordinate2D?
    
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
        guard let coordinate = viewModel.coordinate else { return }
        userCoordinate = viewModel.coordinate
        
        mapView.setRegion(.init(center: coordinate, span: .init(latitudeDelta: 0.085, longitudeDelta: 0.085)), animated: true)
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
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = .add
        
        annotationView?.scalesLargeContentImage = true
        annotationView?.largeContentImage = UIImage(named: "events_banner_\(0)")
        annotationView?.largeContentTitle = annotation.title ?? ""
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        self.selectedEvent = viewModel?.events.filterEvent(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
    }
}

// MARK: - Private API

private extension EventsMapTableViewCell {
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
            
            if index == 2 {
                spacerView.text = "..."
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
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
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
        
        mapHeightConstraint.constant = 450
        selectedEventLabel.text = "Evento selecionado:"
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        bannerImageView.contentMode = .scaleAspectFill
        
        customSheetBackgroundView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 20)
        fakeExpandabilityIndicator.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 1.5)
    }
    
    func setRegionToSelectedEvent() {
        if let latitude = selectedEvent?.content.latitude,
           let longitude = selectedEvent?.content.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            if let annotation = mapView.annotations(in: .init(origin: .init(coordinate), size: .init(width: 1, height: 1))).first as? MKAnnotation {
                mapView.selectedAnnotations = [annotation]
            }
            mapView.setRegion(.init(center: coordinate, span: .init(latitudeDelta: 0.075, longitudeDelta: 0.075)), animated: true)
        }
    }
    
    @objc func didTapEvent() {
        guard let selectedEvent else { return }
        listener?.routeToEvent(selectedEvent)
    }
}
