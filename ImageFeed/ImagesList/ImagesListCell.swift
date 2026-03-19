//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by ALEXANDER BUTYGIN on 12.03.2026.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
