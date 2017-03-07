//
//  HeaderCollectionReusableView.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/19/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var tabTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func viewDidLayoutSubviews() {
        tabTitle.font = tabTitle.font.withSize(32)
    }
}
