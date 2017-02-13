//
//  VideoTableViewCell.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/1/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

protocol VideoTableViewCellDelegate: class {
    func buttonTapped(cell: VideoTableViewCell)
}

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    var delegate: VideoTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    var pressed = false
    
    @IBAction func favoriteBtnTapped(sender: UIButton) {
        if pressed {
            sender.setImage(UIImage(named:"favorites-icon-no-fill.png"), for: .normal)
            pressed = false
            unmarkedAsFavorite()
        } else {
            sender.setImage(UIImage(named:"favorites.png"), for: .normal)
            pressed = true
            self.delegate?.buttonTapped(cell: self)
        }
    }
    
    var count = 0
    
    func unmarkedAsFavorite() {
        count+=1
    }
}
