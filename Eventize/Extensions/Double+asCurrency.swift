//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

extension Double {
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
