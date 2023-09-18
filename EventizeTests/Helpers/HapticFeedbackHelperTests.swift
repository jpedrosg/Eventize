//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import XCTest
@testable import Eventize

class HapticFeedbackHelperTests: XCTestCase {
    
    func testNotificationFeedback() {
        // Arrange
        let helper = HapticFeedbackHelper.shared
        
        // Act
        helper.trigger(.error)
        
        // No assertion is needed since we can't directly verify the feedback, but this ensures no runtime error.
    }
    
    func testSelectionFeedback() {
        // Arrange
        let helper = HapticFeedbackHelper.shared
        
        // Act
        helper.selectionFeedback()
        
        // No assertion is needed since we can't directly verify the feedback, but this ensures no runtime error.
    }
    
    func testImpactFeedback() {
        // Arrange
        let helper = HapticFeedbackHelper.shared
        
        // Act
        helper.impactFeedback(.heavy)
        
        // No assertion is needed since we can't directly verify the feedback, but this ensures no runtime error.
    }
}

