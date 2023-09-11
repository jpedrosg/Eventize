//
//  Copyright © Uber Technologies, Inc. All rights reserved.
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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    weak var listener: EventsCellListener?
    
    static var headerHeight: CGFloat = 60.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - EventsHeaderDisplayLogic

extension EventsTableViewHeader: EventsHeaderDisplayLogic {
    func displayEventHeader(viewModel: Events.EventList.HeaderViewModel) {
        guard let address = viewModel.address else { return }
        
        titleLabel.text = "Procurando eventos perto de:"
        addressLabel.text = address
    }
    
    func setListener(_ listener: EventsCellListener) {
        self.listener = listener
    }
}


// MARK: - Private API

private extension EventsTableViewHeader {
    func setupViews() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        self.contentView.superview?.addTopAndBottomSeparators()
    }
    
    @objc func didTapView() {
        listener?.didTapHeader()
    }
}
