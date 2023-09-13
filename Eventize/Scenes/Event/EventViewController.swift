//
//  Copyright © JJG Tech, Inc. All rights reserved.
//

import UIKit

protocol EventDisplayLogic: AnyObject {
    func displayEvent(viewModel: Event.EventDetails.ViewModel)
    func displayFavoriteButton()
}

final class EventViewController: UIViewController, EventDisplayLogic {
    
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageBackground: UIView!
    @IBOutlet weak var imageView: NetworkImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var extraLabel: UILabel!
    @IBOutlet weak var aboutTitleLabel: UILabel!
    @IBOutlet weak var aboutContentLabel: UILabel!
    
    var viewModel: Event.EventDetails.ViewModel?
    var interactor: EventBusinessLogic?
    var router: (NSObjectProtocol & EventRoutingLogic & EventDataPassing)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup Clean Code Design Pattern

    private func setup() {
        let viewController = self
        let interactor = EventInteractor()
        let presenter = EventPresenter()
        let router = EventRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchEvent()
    }
    
    // MARK: - Request data from EventInteractor

    func fetchEvent() {
        interactor?.fetchEvent()
        interactor?.fetchDetails()
    }

    // MARK: - Display view model from EventPresenter

    func displayEvent(viewModel: Event.EventDetails.ViewModel) {
        self.viewModel = viewModel
        
        // Top
        imageView.setImage(fromUrl: viewModel.event.content.imageUrl, placeholderImage: UIImage(named: "events_banner_\(viewModel.event.eventUuid)")) {
            self.imageContainerView.isHidden = self.imageView.image == nil
        }
        
        // Leading
        titleLabel.text = viewModel.event.content.title
        addressLabel.text = viewModel.event.content.subtitle
        
        // Trailing
        priceLabel.text = viewModel.event.content.price?.asCurrency
        extraLabel.text = viewModel.event.content.info
        
        // Bottom
        aboutContentLabel.text = viewModel.eventDetails?.description
        titleLabel.text = viewModel.event.content.title
        
        displayFavoriteButton()
    }
    
    func displayFavoriteButton() {
        guard let viewModel else { return }
        
        setupNavigationItem(viewModel.event.isFavorite)
    }
}

// MARK: - UIContextMenuInteractionDelegate

extension EventViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            return self.createContextMenu()
        }
    }
}

// MARK: - Private API

private extension EventViewController {
    func setupView() {
        imageBackground.addRoundedCornersAndShadow()
        
        imageView.addRoundedCorners(for: .all)
        imageView.addInteraction(UIContextMenuInteraction(delegate: self))
        imageView.isUserInteractionEnabled = true
    }
    
    func setupNavigationItem(_ isFavoriteEvent: Bool) {
        let favoriteButton = UIBarButtonItem(image: isFavoriteEvent ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"))
        favoriteButton.target = self
        favoriteButton.action = #selector(didTapFavorite)
        self.navigationItem.setRightBarButton(favoriteButton, animated: true)
    }
    
    func createContextMenu() -> UIMenu {
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            guard let self = self else { return }
            
            // Check if the image exists
            guard let image = self.imageView.image else {
                return
            }
            
            // Implement share functionality for the image here
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
            guard let self = self else { return }
            
            // Check if the image exists
            guard let image = self.imageView.image else {
                return
            }
            
            // Implement copy functionality for the image here
            UIPasteboard.general.image = image
        }
        
        let saveToPhotos = UIAction(title: "Save to Photos", image: UIImage(systemName: "photo")) { [weak self] _ in
            guard let self = self else { return }
            
            // Check if the image exists
            guard let image = self.imageView.image else {
                return
            }
            
            // Attempt to save the image to the device's photo library
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        return UIMenu(title: "", children: [shareAction, copy, saveToPhotos])
    }
    
    // Selector for image saving completion
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle the error if saving fails
            print("Error saving image to photos: \(error.localizedDescription)")
        } else {
            // Handle the success case
            print("Image saved to photos successfully.")
        }
    }
    
    @objc func didTapFavorite() {
        HapticFeedbackHelper.shared.selectionFeedback()
        
        guard let isFavorite = viewModel?.event.isFavorite else { return }
        isFavorite ? interactor?.removeFavorite() : interactor?.setFavorite()
    }
}
