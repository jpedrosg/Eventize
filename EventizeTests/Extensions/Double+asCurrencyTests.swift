//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import XCTest
@testable import Eventize

class DoubleCurrencyFormattingTests: XCTestCase {
    
    func testAsCurrency_WithPositiveValue_ShouldFormatCorrectly() {
        // Arrange
        let positiveValue: Double = 1234.56
        
        // Act
        let formattedCurrency = positiveValue.asCurrency
        
        // Assert
        XCTAssertEqual(formattedCurrency, "R$ 1.234,56")
    }
    
    func testAsCurrency_WithNegativeValue_ShouldFormatCorrectly() {
        // Arrange
        let negativeValue: Double = -789.12
        
        // Act
        let formattedCurrency = negativeValue.asCurrency
        
        // Assert
        XCTAssertEqual(formattedCurrency, "-R$ 789,12")
    }
    
    func testAsCurrency_WithZeroValue_ShouldFormatCorrectly() {
        // Arrange
        let zeroValue: Double = 0.0
        
        // Act
        let formattedCurrency = zeroValue.asCurrency
        
        // Assert
        XCTAssertEqual(formattedCurrency, "R$ 0,00")
    }
    
    func testAsCurrency_WithLargeValue_ShouldFormatCorrectly() {
        // Arrange
        let largeValue: Double = 123456789.0
        
        // Act
        let formattedCurrency = largeValue.asCurrency
        
        // Assert
        XCTAssertEqual(formattedCurrency, "R$ 123.456.789,00")
    }
}

