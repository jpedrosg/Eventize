//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest
import SnapshotTesting
@testable import Eventize

class UIViewSeparatorsExtensionTests: XCTestCase {

    func testAddTopAndBottomSeparators() {
        // Arrange
        let backgroundView = UIView(frame: .init(origin: .zero, size: .init(width: 500, height: 500)))
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 300, height: 200)))
        view.center = backgroundView.center
        view.backgroundColor = .gray
        backgroundView.backgroundColor = .white
        backgroundView.addSubview(view)
        let lineHeight: CGFloat = 2.0
        let lineColor: UIColor = .red // You can change this to your desired color
        
        // Act
        view.addTopAndBottomSeparators(lineHeight: lineHeight, lineColor: lineColor)
        
        // Assert
        assertSnapshot(matching: backgroundView, as: .image)
    }
}
