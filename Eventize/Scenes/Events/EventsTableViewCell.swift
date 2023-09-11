//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventsCellDisplayLogic: AnyObject {
    func displayEventCell(viewModel: Events.EventList.CellViewModel)
    func setMenuInteraction(_ interaction: UIContextMenuInteraction)
}

final class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var bannerImageView: NetworkImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomInfosStackView: UIStackView!
    
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

extension EventsTableViewCell: EventsCellDisplayLogic {
    func displayEventCell(viewModel: Events.EventList.CellViewModel) {
        bannerImageView.setImage(fromUrl: viewModel.event.content.imageUrl, placeholderImage: UIImage(named: "events_banner_\(viewModel.event.eventUuid)"))
        bannerImageView.highlightedImage = bannerImageView.image?.convertToBlackAndWhite()
        
        titleLabel.text = viewModel.event.content.title
        locationLabel.text = viewModel.event.content.subtitle
        priceLabel.text = viewModel.event.content.price?.asCurrency
        infoLabel.text = viewModel.event.content.info
        
        updateBottomInfoStackView(with: viewModel.event.content.extraBottomInfo)
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setMenuInteraction(_ interaction: UIContextMenuInteraction) {
        customBackgroundView.addInteraction(interaction)
    }
}

// MARK: - Private API

private extension EventsTableViewCell {
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
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        bannerImageView.contentMode = .scaleAspectFill
    }
}
