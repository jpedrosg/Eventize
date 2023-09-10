//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

protocol EventsCellDisplayLogic: AnyObject {
    func display(viewModel: Events.EventList.CellViewModel)
}

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var customBackgroundView: UIView!
    
    // Top
    @IBOutlet weak var bannerImageStackView: UIImageView!
    
    // Leading
    @IBOutlet weak var leadingInfoStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    // Trailing
    @IBOutlet weak var trailingInfoStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    
    // Bottom
    @IBOutlet weak var bottomInfoStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.backgroundColor = .systemBackground
    }
}

// MARK: - EventsCellDisplayLogic

extension EventsTableViewCell: EventsCellDisplayLogic {
    func display(viewModel: Events.EventList.CellViewModel) {
        // Top
        bannerImageStackView.image = viewModel.image
        bannerImageStackView.highlightedImage = bannerImageStackView.image?.convertToBlackAndWhite()
        
        // Leading
        titleLabel.text = viewModel.title
        locationLabel.text = viewModel.address
        
        // Trailing
        priceLabel.text = viewModel.price.asCurrency
        extraLabel.text = viewModel.extraInfo
        
        // Bottom
        bottomInfoStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        if let labels = viewModel.labels, !labels.isEmpty {
            bottomInfoStackView.isHidden = false
            
            let spacerView = UILabel()
            for (index, label) in labels.enumerated() {
                guard index <= 2 else {
                    spacerView.text = "..."
                    break
                }
                
                let labelsStackView = labelsStackView(with: label)
                bottomInfoStackView.addArrangedSubview(labelsStackView)
            }
            bottomInfoStackView.addArrangedSubview(spacerView)
        } else {
            bottomInfoStackView.isHidden = true
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - Private API

private extension EventsTableViewCell {
    func labelsStackView(with label: Events.EventList.CellViewModel.Label) -> UIStackView {
        let labelsStackView = UIStackView(frame: .zero)
        labelsStackView.alignment = .fill
        labelsStackView.distribution = .fillProportionally
        
        let stackViewImageView = UIImageView(frame: .zero)
        stackViewImageView.image = label.image ?? UIImage(systemName: "checkmark.circle.fill")
        stackViewImageView.highlightedImage = stackViewImageView.image?.convertToBlackAndWhite()
        stackViewImageView.contentMode = .scaleAspectFit
        stackViewImageView.translatesAutoresizingMaskIntoConstraints = false
        stackViewImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        stackViewImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        labelsStackView.addArrangedSubview(stackViewImageView)
        
        let stackViewLabel = UILabel(frame: .zero)
        stackViewLabel.text = label.text
        labelsStackView.addArrangedSubview(stackViewLabel)
        
        return labelsStackView
    }
    
    func setupViews() {
        // Background
        customBackgroundView.addRoundedCornersAndShadow()
        bannerImageStackView.addRoundedCorners(for: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        
        // Top
        bannerImageStackView.contentMode = .scaleAspectFill
    }
}
