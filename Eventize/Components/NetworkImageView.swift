//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import UIKit

/// A custom `UIImageView` subclass that allows loading images from network URLs.
class NetworkImageView: UIImageView {
    
    /// The URL of the image to be loaded.
    private var imageUrl: String?
    
    // MARK: - Public Methods
    
    /// Sets the image of the `NetworkImageView` from a given URL.
    ///
    /// - Parameter imageUrl: The URL of the image to be loaded.
    /// - Parameter backingImage: The UIImage to be set as backing on failure.
    func setImage(fromUrl imageUrl: String?, backingImage: UIImage? = nil, completion: (() -> Void)? = nil) {
        self.imageUrl = imageUrl
        
        // Clear the current image
        image = nil
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.image = backingImage
            completion?()
            return
        }
        
        // Use your NetworkManager to fetch and set the image
        NetworkManager.fetchImage(from: url, callerName: String(describing: self)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure:
                    self?.image = backingImage
                }
            }
            
            completion?()
        }
    }
}
