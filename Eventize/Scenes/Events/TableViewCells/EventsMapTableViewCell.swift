//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit
import MapKit

protocol EventsMapDisplayLogic: AnyObject {
    func displayEvents(viewModel: Events.EventList.ViewModel)
    func setMenuInteraction(_ interaction: UIContextMenuInteraction)
}

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
    
    private var initialOffsetY: CGFloat = .zero
    private var selectedEvent: Events.EventObject?
    
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

// MARK: - EventsCellDisplayLogic

extension EventsMapTableViewCell: EventsMapDisplayLogic {
    func displayEvents(viewModel: Events.EventList.ViewModel) {
        selectedEvent = viewModel.events.first
        
        guard let selectedEvent else { return }
        
        bannerImageView.setImage(fromUrl: selectedEvent.content.imageUrl, placeholderImage: UIImage(named: "events_banner_\(selectedEvent.eventUuid)"))
        bannerImageView.highlightedImage = bannerImageView.image?.convertToBlackAndWhite()
        
        titleLabel.text = selectedEvent.content.title
        addressLabel.text = selectedEvent.content.subtitle
        priceLabel.text = selectedEvent.content.price?.asCurrency
        extraInfoLabel.text = selectedEvent.content.info
        
        updateBottomInfoStackView(with: selectedEvent.content.extraBottomInfo)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setMenuInteraction(_ interaction: UIContextMenuInteraction) {
        customBackgroundView.addInteraction(interaction)
    }
}

// MARK: - Private API

private extension EventsMapTableViewCell {
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
        imageView.highlightedImage = imageView.image?.convertToBlackAndWhite()
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
        mapHeightConstraint.constant = 450
        
        selectedEventLabel.text = "Evento selecionado:"
        
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        bannerImageView.contentMode = .scaleAspectFill
        
        customSheetBackgroundView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        fakeExpandabilityIndicator.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 1.5)
    }
}
