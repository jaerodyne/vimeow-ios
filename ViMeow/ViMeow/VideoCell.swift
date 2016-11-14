//
//  VideoCell.swift
//  ViMeow
//
//  Created by Jillian Somera on 11/13/16.
//  Copyright © 2016 Jillian Somera. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var videoPreviewImage: UIImageView!
    
    @IBOutlet weak var videoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(video: Video) {
        videoTitle.text = video.videoTitle
        //        TODO: set image url
        let url = URL(string: video.imageURL)!
        
        //        gives you a block on a certain type of thread
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.global().sync {
                    self.videoPreviewImage.image = UIImage(data: data)
                }
            } catch {
                //                handle the error
                //                print("Wrong URL")
            }
        }
        
    }
}
