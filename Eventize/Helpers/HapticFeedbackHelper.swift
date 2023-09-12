//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

class HapticFeedbackHelper {
    static let shared = HapticFeedbackHelper()
    private init() { }
    
    func trigger(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackType)
    }
    
    func selectionFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    func impactFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

