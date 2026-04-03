//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 03.04.2026.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
