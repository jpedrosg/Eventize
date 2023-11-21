//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//

import UIKit

protocol EventsCellInteractions: AnyObject {
    func setFavorite(_ event: Events.EventObject)
    func removeFavorite(_ event: Events.EventObject)
}

protocol EventsCellDisplayLogic: AnyObject {
    func displayEventCell(viewModel: Events.EventList.CellViewModel, isFilteredByFavorites: Bool, isSearching: Bool)
    func setMenuInteraction(_ interaction: UIContextMenuInteraction)
    func setListener(_ listener: EventsCellInteractions)
}

final class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var bannerImageView: NetworkImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bottomInfosStackView: UIStackView!
    private let placeholderImage: UIImage = ImageMocks.randomEventImage()
    
    private var viewModel: Events.EventList.CellViewModel?
    weak var listener: EventsCellInteractions?
    
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
    
    @IBAction func didTapFavoriteButton(_ sender: Any) {
        HapticFeedbackHelper.shared.impactFeedback(.rigid)
        
        guard let event = viewModel?.event else { return }
        
        if event.isFavorite {
            listener?.removeFavorite(event)
        } else {
            listener?.setFavorite(event)
        }
    }
}

// MARK: - EventsCellDisplayLogic

extension EventsTableViewCell: EventsCellDisplayLogic {
    func displayEventCell(viewModel: Events.EventList.CellViewModel, isFilteredByFavorites: Bool, isSearching: Bool) {
        self.viewModel = viewModel
        
        bannerImageView.setImage(fromUrl: viewModel.event.content.imageUrl, placeholderImage: placeholderImage) { imageView in
            DispatchQueue.main.async {
                imageView.highlightedImage = imageView.image?.convertToBlackAndWhite()
                self.favoriteButton.tintColor = isFilteredByFavorites ? Colors.accentColor : (imageView.image == nil ? .label : .secondarySystemBackground)
            }
        }
        
        titleLabel.text = viewModel.event.content.title
        locationLabel.text = viewModel.event.content.subtitle
        priceLabel.text = viewModel.event.content.price?.asCurrency
        infoLabel.text = viewModel.event.content.info
        favoriteButton.setImage(viewModel.event.isFavorite ? Images.heartFilled : Images.heartEmpty, for: .normal)
        titleLabel.textColor = isSearching ? Colors.accentColor : .label
        updateBottomInfoStackView(with: viewModel.event.content.extraBottomInfo)
        
        titleLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        locationLabel.setContentHuggingPriority(.required, for: .vertical)
        
        favoriteButton.accessibilityLabel = Accessibility.favoriteButton
        favoriteButton.accessibilityHint = viewModel.event.isFavorite ? Accessibility.removeFromFavoritesHint : Accessibility.addToFavoritesHint
        
        layoutSubviews()
    }
    
    func setMenuInteraction(_ interaction: UIContextMenuInteraction) {
        customBackgroundView.addInteraction(interaction)
    }
    
    func setListener(_ listener: EventsCellInteractions) {
        self.listener = listener
    }
}

// MARK: - Private API

private extension EventsTableViewCell {
    typealias Strings = Constants.Strings
    typealias Images = Constants.Images
    typealias Colors = Constants.Colors
    typealias Accessibility = Constants.Accessibility
    
    enum Constants {
        enum Accessibility {
            static let favoriteButton = "Favorito"
            static let addToFavoritesHint = "Adiciona evento aos favoritos."
            static let removeFromFavoritesHint = "Remove evento dos favoritos."
        }
        
        enum Images {
            static let heartEmpty: UIImage = .init(systemName: "heart")!
            static let heartFilled: UIImage = .init(systemName: "heart.fill")!
            static let checkmarkCircle: UIImage = .init(systemName: "checkmark.circle.fill")!
        }
        
        enum Colors {
            static let accentColor: UIColor = .init(named: "AccentColor")!
        }
        
        enum Strings {
            static let eventsBannerPrefix: String = "events_banner_"
        }
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
        imageView.setImage(fromUrl: bottomInfo.imageUrl, placeholderImage: Images.checkmarkCircle)
        imageView.highlightedImage = imageView.image?.convertToBlackAndWhite()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
