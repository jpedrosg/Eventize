//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest
import SnapshotTesting
@testable import Eventize

class UIViewStylingExtensionTests: XCTestCase {

    func testAddRoundedCornersAndShadow() {
        // Arrange
        let backgroundView = UIView(frame: .init(origin: .zero, size: .init(width: 500, height: 500)))
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 300, height: 200)))
        view.center = backgroundView.center
        view.backgroundColor = .gray
        backgroundView.backgroundColor = .white
        backgroundView.addSubview(view)
        
        // Act
        view.addRoundedCornersAndShadow()
        
        // Assert
        assertSnapshot(matching: backgroundView, as: .image)
    }
    
    func testAddRoundedCornersForSpecificCorners() {
        // Arrange
        let backgroundView = UIView(frame: .init(origin: .zero, size: .init(width: 500, height: 500)))
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 300, height: 200)))
        view.center = backgroundView.center
        view.backgroundColor = .gray
        backgroundView.backgroundColor = .white
        backgroundView.addSubview(view)
        let corners: CACornerMask = .all
        let cornerRadius: CGFloat = 15
        
        // Act
        view.addRoundedCorners(for: corners, radius: cornerRadius)
        
        // Assert
        assertSnapshot(matching: backgroundView, as: .image)
    }
}

