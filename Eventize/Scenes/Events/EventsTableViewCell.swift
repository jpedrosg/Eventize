//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

protocol EventsCellDisplayLogic: AnyObject {
    func display(viewModel: Events.EventList.CellViewModel)
    func setMenuInteraction(_ interaction: UIContextMenuInteraction)
}

final class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var customBackgroundView: UIView!
    
    // Top
    @IBOutlet weak var bannerImageStackView: NetworkImageView!
    
    // Leading
    @IBOutlet weak var leadingInfoStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // Trailing
    @IBOutlet weak var trailingInfoStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    
    // Bottom
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
    func display(viewModel: Events.EventList.CellViewModel) {
        
        // Top
        bannerImageStackView.setImage(fromUrl: viewModel.event.content.imageUrl, backingImage: UIImage(named: "events_banner_\(viewModel.event.eventUuid)"))
        bannerImageStackView.highlightedImage = bannerImageStackView.image?.convertToBlackAndWhite()
        
        // Leading
        titleLabel.text = viewModel.event.content.title
        locationLabel.text = viewModel.event.content.subtitle
        
        // Trailing
        priceLabel.text = viewModel.event.content.price?.asCurrency
        extraLabel.text = viewModel.event.content.info
        
        // Bottom
        bottomInfosStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        if let bottomInfos = viewModel.event.content.extraBottomInfo, !bottomInfos.isEmpty {
            bottomInfosStackView.isHidden = false
            
            let spacerView = UILabel()
            for (index, bottomInfo) in bottomInfos.enumerated() {
                guard index <= 2 else {
                    spacerView.text = "..."
                    break
                }
                
                let bottomInfoStackView = extraBottomInfoStackView(with: bottomInfo)
                bottomInfosStackView.addArrangedSubview(bottomInfoStackView)
            }
            bottomInfosStackView.addArrangedSubview(spacerView)
        } else {
            bottomInfosStackView.isHidden = true
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setMenuInteraction(_ interaction: UIContextMenuInteraction) {
        customBackgroundView.addInteraction(interaction)
    }
}

// MARK: - Private API

private extension EventsTableViewCell {
    func extraBottomInfoStackView(with bottomInfo: Events.EventObject.EventContent.BottomInfo) -> UIStackView {
        let bottomInfoStackView = UIStackView(frame: .zero)
        bottomInfoStackView.alignment = .fill
        bottomInfoStackView.distribution = .fillProportionally
        
        let stackViewImageView = NetworkImageView(frame: .zero)
        stackViewImageView.setImage(fromUrl: bottomInfo.imageUrl, backingImage: .init(systemName: "checkmark.circle.fill")!)
        stackViewImageView.highlightedImage = stackViewImageView.image?.convertToBlackAndWhite()
        stackViewImageView.contentMode = .scaleAspectFit
        stackViewImageView.translatesAutoresizingMaskIntoConstraints = false
        stackViewImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        stackViewImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        bottomInfoStackView.addArrangedSubview(stackViewImageView)
        
        let stackViewLabel = UILabel(frame: .zero)
        stackViewLabel.text = bottomInfo.text
        stackViewLabel.font = .preferredFont(forTextStyle: .headline)
        bottomInfoStackView.addArrangedSubview(stackViewLabel)
        
        return bottomInfoStackView
    }
    
    func setupViews() {
        // Background
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageStackView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        // Top
        bannerImageStackView.contentMode = .scaleAspectFill
    }
}
