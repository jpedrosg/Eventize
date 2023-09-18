//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// An extension to provide common styling to UIView elements such as adding rounded corners and shadows.
extension UIView {
    
    /// Adds rounded corners and a shadow to the view.
    func addRoundedCornersAndShadow() {
        let cornerRadius: CGFloat = 10
        let shadowColor: UIColor = UIColor.black
        let shadowOpacity: Float = 0.3
        let shadowOffset: CGSize = CGSize(width: 0, height: 4)
        let shadowRadius: CGFloat = 6
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    /// Adds rounded corners to specified corners of the view.
    ///
    /// - Parameter corners: The corners to which rounded corners should be applied.
    func addRoundedCorners(for corners: CACornerMask, radius: CGFloat = 10) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = corners
    }
}

extension CACornerMask {
    static let all: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
}
