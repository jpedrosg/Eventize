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
        addressLabel.text = viewModel.address
    }
    
    func setListener(_ listener: EventsCellListener) {
        self.listener = listener
    }
}


// MARK: - Private API

private extension EventsTableViewHeader {
    func setupViews() {
        titleLabel.text = "Procurando eventos perto de:"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        
        let scale = UIScreen.main.scale // Get the screen scale factor
        let lineHeight: CGFloat = 1.0 / scale // Adjust the line height based on scale
        let bottomLineView = UIView(frame: CGRect(x: 0, y: Self.headerHeight - lineHeight, width: UIScreen.main.bounds.width, height: lineHeight))
        let topLineView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: lineHeight))
        bottomLineView.backgroundColor = .separator
        topLineView.backgroundColor = .separator
        self.contentView.superview!.addSubview(topLineView)
        self.contentView.superview!.addSubview(bottomLineView)
    }
    
    @objc func didTapView() {
        listener?.didTapHeader()
    }
}
