//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

extension UIView {
    func addRoundedCornersAndShadow() {
        let cornerRadius: CGFloat = 10
        let shadowColor: UIColor = UIColor.black
        let shadowOpacity: Float = 0.2
        let shadowOffset: CGSize = CGSize(width: 0, height: 2)
        let shadowRadius: CGFloat = 4
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
    }
    
    func addRoundedCorners(for corners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.maskedCorners = corners
    }
}