//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit
import CoreImage

/// An extension to convert a UIImage to a black and white (grayscale) version.
extension UIImage {
    
    /// Converts the image to black and white (grayscale).
    ///
    /// - Returns: A black and white version of the image, or nil if the conversion fails.
    func convertToBlackAndWhite() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey) // Set saturation to 0 to make it grayscale

        if let outputImage = filter?.outputImage {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return nil
    }
}
