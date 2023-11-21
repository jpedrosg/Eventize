//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import UIKit

struct ImageMocks {
    static func randomEventImage() -> UIImage {
        let randomIndex = Int.random(in: 1...6)
        let imageName = "fallback_event_image_\(randomIndex)"
        return UIImage(named: imageName)!
    }
}
