//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation

/// An extension to safely access elements in a collection using a subscript.
extension Collection {
    
    /// Safely retrieves an element from the collection at the specified index.
    ///
    /// - Parameter index: The index at which to access the element.
    /// - Returns: The element at the specified index, or nil if the index is out of bounds.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
