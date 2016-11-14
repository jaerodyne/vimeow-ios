//
//  VideoPlaylistVC.swift
//  ViMeow
//
//  Created by Jillian Somera on 11/13/16.
//  Copyright © 2016 Jillian Somera. All rights reserved.
//

import UIKit
import Alamofire

class VideoPlaylistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoCell {
            
            //            grabs object in the array
            let video = videos[indexPath.row]
            
            cell.updateUI(video: video)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let video = videos[indexPath.row]
        
        performSegue(withIdentifier: "VideoVC", sender: video)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoVC {
            if let video = sender as? Video {
                destination.video = video
            }
        }
    }
}
