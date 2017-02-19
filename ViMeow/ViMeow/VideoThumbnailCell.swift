//
//  VideoThumbnailCell.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/19/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

protocol VideoThumbnailCellDelegate: class {
    func buttonTapped(cell: VideoThumbnailCell)
}

class VideoThumbnailCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var delegate: VideoThumbnailCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    var pressed = false
    
    @IBAction func favoriteBtnTapped(sender: UIButton) {
        if pressed {
            sender.setImage(UIImage(named:"favorites-icon-no-fill"), for: .normal)
            pressed = false
        } else {
            sender.setImage(UIImage(named:"favorites"), for: .normal)
            pressed = true
        }
        self.delegate?.buttonTapped(cell: self)
    }
    
}
