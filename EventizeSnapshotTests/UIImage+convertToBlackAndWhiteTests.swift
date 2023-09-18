//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest
import SnapshotTesting
@testable import Eventize

class UIImageBlackAndWhiteConversionTests: XCTestCase {

    func testConvertToBlackAndWhite_WithValidImage_ShouldReturnBlackAndWhiteImage() {
        // Arrange
        let originalImage = UIImage(named: "events_banner_1")

        // Act
        let blackAndWhiteImage = originalImage?.convertToBlackAndWhite()
        let imageView = UIImageView(image: blackAndWhiteImage)

        // Assert
        assertSnapshot(of: imageView, as: .image)
    }

    func testConvertToBlackAndWhite_WithNilImage_ShouldReturnNil() {
        // Arrange
        let originalImage: UIImage? = nil

        // Act
        let blackAndWhiteImage = originalImage?.convertToBlackAndWhite()

        // Assert
        XCTAssertNil(blackAndWhiteImage)
    }

    func testConvertToBlackAndWhite_WithGrayscaleImage_ShouldReturnSameImage() {
        // Arrange
        let grayscaleImage = UIImage(named: "events_banner_1_grayscale")

        // Act
        let blackAndWhiteImage = grayscaleImage?.convertToBlackAndWhite()
        let imageView = UIImageView(image: blackAndWhiteImage)

        // Assert
        assertSnapshot(of: imageView, as: .image)
    }

    func testConvertToBlackAndWhite_WithEmptyImage_ShouldReturnNil() {
        // Arrange
        let emptyImage = UIImage()

        // Act
        let blackAndWhiteImage = emptyImage.convertToBlackAndWhite()

        // Assert
        XCTAssertNil(blackAndWhiteImage)
    }
}
