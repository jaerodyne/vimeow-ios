//
//  FavoriteTableViewCell.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/11/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    //create outlets for labels
    @IBOutlet weak var favoriteVideoTitleLabel: UILabel!
    @IBOutlet weak var favoriteVideoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
