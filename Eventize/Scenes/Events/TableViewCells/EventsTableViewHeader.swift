//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

protocol EventsCellListener: AnyObject {
    func didTapHeader()
}

protocol EventsHeaderDisplayLogic: AnyObject {
    func displayEventHeader(viewModel: Events.EventList.HeaderViewModel)
    func setListener(_ listener: EventsCellListener)
}

final class EventsTableViewHeader: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    weak var listener: EventsCellListener?
    
    static let headerHeight: CGFloat = 60.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - EventsHeaderDisplayLogic

extension EventsTableViewHeader: EventsHeaderDisplayLogic {
    func displayEventHeader(viewModel: Events.EventList.HeaderViewModel) {
        guard let address = viewModel.address else { return }
        
        titleLabel.text = Strings.title
        addressLabel.text = address
    }
    
    func setListener(_ listener: EventsCellListener) {
        self.listener = listener
    }
}


// MARK: - Private API

private extension EventsTableViewHeader {
    typealias Strings = Constants.Strings
    
    enum Constants {
        enum Strings {
            static let title: String = "Procurando eventos perto de:"
        }
    }
    
    func setupViews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        self.contentView.superview?.addTopAndBottomSeparators()
    }
    
    @objc func didTapView() {
        HapticFeedbackHelper.shared.impactFeedback(.medium)
        
        listener?.didTapHeader()
    }
}
