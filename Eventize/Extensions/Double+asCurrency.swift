//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import Foundation

/// An extension to format a `Double` value as a currency string.
extension Double {
    
    /// Returns a currency-formatted string representation of the `Double` value.
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
