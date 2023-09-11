//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//



import UIKit

extension UIView {
    func addTopAndBottomSeparators(lineHeight: CGFloat = 1.0, lineColor: UIColor = .separator) {
        let topLineView = UIView()
        let bottomLineView = UIView()

        // Set up the top line
        topLineView.backgroundColor = lineColor
        topLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLineView)

        // Set up the bottom line
        bottomLineView.backgroundColor = lineColor
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLineView)

        // Add constraints for the top line
        topLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topLineView.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true

        // Add constraints for the bottom line
        bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomLineView.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true
    }
}
