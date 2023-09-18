//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// Protocol for handling interactions in the TicketsTableViewCell.
protocol TicketsViewCellInteractions: AnyObject {
    func validateTicket(_ ticket: Tickets.TicketObject)
}

/// Protocol for displaying ticket information in the TicketsTableViewCell.
protocol TicketsViewCellDisplayLogic: AnyObject {
    func displayTicket(viewModel: Tickets.TicketList.CellViewModel)
    func setListener(_ listener: TicketsViewCellInteractions)
}

/// Custom table view cell for displaying ticket information.
class TicketsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventImageView: NetworkImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var backgroundContainerView: UIView!
    @IBOutlet weak var lineCropBackStackView: UIStackView!
    @IBOutlet weak var lineCropFrontStackView: UIStackView!
    @IBOutlet weak var dateIconImageView: UIImageView!
    
    var viewModel: Tickets.TicketList.CellViewModel?
    weak var listener: TicketsViewCellInteractions?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    @IBAction func didTapCheckin(_ sender: UIButton) {
        HapticFeedbackHelper.shared.impactFeedback(.heavy)
        guard let viewModel = viewModel else { return }
        listener?.validateTicket(viewModel.ticket)
    }
}

// MARK: - TicketsViewCellDisplayLogic

extension TicketsTableViewCell: TicketsViewCellDisplayLogic {
    func displayTicket(viewModel: Tickets.TicketList.CellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.ticket.title
        if let quantity = viewModel.ticket.quantity {
            quantityLabel.text = "\(quantity)x"
            quantityLabel.accessibilityLabel = quantity > 1 ? "\(quantity) ingressos" : "\(quantity) ingresso"
        }
        dateLabel.text = ISO8601DateFormatter().date(from: viewModel.ticket.date)?.formatted(date: .numeric, time: .omitted)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none

        if let date = ISO8601DateFormatter().date(from: viewModel.ticket.date) {
            dateLabel.accessibilityLabel = dateFormatter.string(from: date)
        }
        
        
        descriptionLabel.text = viewModel.ticket.description
        
        if viewModel.ticket.isValid {
            eventImageView.setImage(fromUrl: viewModel.ticket.imageUrl, placeholderImage: .init(named: "events_banner_\(viewModel.ticket.eventUuid)"))
            setValidState()
        } else {
            eventImageView.setImage(fromUrl: viewModel.ticket.imageUrl, placeholderImage: .init(named: "events_banner_\(viewModel.ticket.eventUuid)"), asBlackAndWhite: true)
            setInvalidState()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        layoutSubviews()
    }
    
    func setListener(_ listener: TicketsViewCellInteractions) {
        self.listener = listener
    }
}

// MARK: - Private API

private extension TicketsTableViewCell {
    
    // MARK: - Constants
    
    enum Constants {
        static let titleLabelAlpha: CGFloat = 0.55
        static let dateIconImageViewAlpha: CGFloat = 0.55
        static let checkinButtonTitleValidado = "VALIDADO"
        static let checkinButtonTitleValidar = "VALIDAR"
        static let mapHeight: CGFloat = 450
    }
    
    func setupViews() {
        lineCropBackStackView.arrangedSubviews.forEach { subview in
            subview.addRoundedCorners(for: .all, radius: subview.frame.height / 2)
        }
        
        lineCropFrontStackView.arrangedSubviews.forEach { subview in
            subview.addRoundedCorners(for: .all, radius: subview.frame.height / 2)
        }
        
        eventImageView.addRoundedCorners(for: .all)
        backgroundContainerView.addRoundedCorners(for: .all)
    }
    
    func setInvalidState() {
        eventImageView.alpha = Constants.titleLabelAlpha
        dateIconImageView.alpha = Constants.dateIconImageViewAlpha
        titleLabel.alpha = Constants.titleLabelAlpha
        descriptionLabel.alpha = Constants.titleLabelAlpha
        
        dateIconImageView.tintColor = .label
        backgroundContainerView.backgroundColor = .systemBackground.withAlphaComponent(Constants.titleLabelAlpha)
        checkinButton.setTitle(Constants.checkinButtonTitleValidado, for: .normal)
        checkinButton.isEnabled = false
        lineCropFrontStackView.arrangedSubviews.forEach { subview in
            subview.addRoundedCorners(for: [])
            subview.backgroundColor = .secondarySystemBackground
        }
        
        accessibilityValue = "Validado"
    }
    
    func setValidState() {
        eventImageView.alpha = 1
        dateIconImageView.alpha = 1
        titleLabel.alpha = 1
        descriptionLabel.alpha = 1
        
        dateIconImageView.tintColor = .init(named: "AccentColor")
        backgroundContainerView.backgroundColor = .systemBackground
        checkinButton.setTitle(Constants.checkinButtonTitleValidar, for: .normal)
        checkinButton.isEnabled = true
        lineCropFrontStackView.arrangedSubviews.enumerated().forEach { index, subview in
            subview.addRoundedCorners(for: .all)
            subview.backgroundColor = index % 2 != 0 ? .secondarySystemBackground : .systemBackground
        }
        
        accessibilityValue = "Válido"
        checkinButton.accessibilityHint = "Toque para validar tickets"
    }
}
