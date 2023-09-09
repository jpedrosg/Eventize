//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
