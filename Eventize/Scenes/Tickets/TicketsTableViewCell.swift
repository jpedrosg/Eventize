//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

protocol TicketsViewCellInteractions: AnyObject {
    func validateTicket(_ ticket: Tickets.TicketObject)
}

protocol TicketsViewCellDisplayLogic: AnyObject {
    func displayTicket(viewModel: Tickets.TicketList.CellViewModel)
    func setListener(_ listener: TicketsViewCellInteractions)
}

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
        guard let viewModel else { return }
        
        listener?.validateTicket(viewModel.ticket)
    }
}

// MARK: - TicketsViewCellDisplayLogic

extension TicketsTableViewCell: TicketsViewCellDisplayLogic {
    func displayTicket(viewModel: Tickets.TicketList.CellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.ticket.title
        quantityLabel.text = "\(viewModel.ticket.quantity ?? 1)x"
        dateLabel.text = ISO8601DateFormatter().date(from: viewModel.ticket.date)?.formatted(date: .numeric, time: .omitted)
        descriptionLabel.text = viewModel.ticket.description
        
        if viewModel.ticket.isValid {
            eventImageView.setImage(fromUrl: viewModel.ticket.imageUrl, placeholderImage: .init(named: "events_banner_\(viewModel.ticket.eventUuid)"))
            
            setValidState()
        } else {
            eventImageView.setImage(fromUrl: viewModel.ticket.imageUrl, placeholderImage: .init(named: "events_banner_\(viewModel.ticket.eventUuid)"), asBlackAndWhite: true)
            
            setInvalidState()
        }
    }
    
    func setListener(_ listener: TicketsViewCellInteractions) {
        self.listener = listener
    }
}


// MARK: - Private

private extension TicketsTableViewCell {
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
        eventImageView.alpha = 0.55
        dateIconImageView.alpha = 0.55
        titleLabel.alpha = 0.55
        descriptionLabel.alpha = 0.55
        
        dateIconImageView.tintColor = .label
        backgroundContainerView.backgroundColor = .systemBackground.withAlphaComponent(0.55)
        checkinButton.setTitle("VALIDADO", for: .normal)
        checkinButton.isEnabled = false
        lineCropFrontStackView.arrangedSubviews.forEach { subview in
            subview.addRoundedCorners(for: [])
            subview.backgroundColor = .secondarySystemBackground
        }
    }
    
    func setValidState() {
        eventImageView.alpha = 1
        dateIconImageView.alpha = 1
        titleLabel.alpha = 1
        descriptionLabel.alpha = 1
        
        dateIconImageView.tintColor = .init(named: "AccentColor")
        backgroundContainerView.backgroundColor = .systemBackground
        checkinButton.setTitle("VALIDAR", for: .normal)
        checkinButton.isEnabled = true
        lineCropFrontStackView.arrangedSubviews.enumerated().forEach { index, subview in
            subview.addRoundedCorners(for: .all)
            subview.backgroundColor = index % 2 != 0 ? .secondarySystemBackground : .systemBackground
        }
    }
}
