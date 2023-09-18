//
//  Copyright © JJG Technologies, Inc. All rights reserved.
//


import UIKit

/// A custom `UIImageView` subclass that allows loading images from network URLs.
class NetworkImageView: UIImageView {
    
    /// The URL of the image to be loaded.
    private var imageUrl: String?
    
    /// The UIImage without converting to B&W.
    private var rawImage: UIImage?
    
    // MARK: - Public Methods
    
    /// Sets the image of the `NetworkImageView` from a given URL.
    ///
    /// - Parameter imageUrl: The URL of the image to be loaded.
    /// - Parameter placeholderImage: The UIImage to be set as backing on failure.
    func setImage(fromUrl imageUrl: String?, placeholderImage: UIImage? = nil, asBlackAndWhite: Bool = false, completion: ((NetworkImageView) -> Void)? = nil) {
        self.imageUrl = imageUrl
        
        // Clear the current image
        image = asBlackAndWhite ? placeholderImage?.convertToBlackAndWhite() : placeholderImage
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            rawImage = image
            self.image = asBlackAndWhite ? placeholderImage?.convertToBlackAndWhite() : placeholderImage
            completion?(self)
            return
        }
        
        // Use your NetworkManager to fetch and set the image
        NetworkManager.fetchImage(from: url, callerName: String(describing: self)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.rawImage = image
                    self?.image = asBlackAndWhite ? image.convertToBlackAndWhite() : image
                case .failure:
                    self?.rawImage = placeholderImage
                    self?.image = asBlackAndWhite ? placeholderImage?.convertToBlackAndWhite() : placeholderImage
                }
            }
            
            completion?(self ?? .init())
        }
    }
}
