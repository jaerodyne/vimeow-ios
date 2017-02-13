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
    
    @IBAction func favoriteBtnTapped(sender: UIButton) {
        self.delegate?.buttonTapped(cell: self)
    }
}
