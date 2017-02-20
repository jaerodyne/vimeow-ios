//
//  AnimalsPlaylistVCViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/19/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class AnimalsPlaylistVCViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    private var _video: Video!
    
    var video: Video {
        get {
            return _video
        } set {
            _video = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.loadHTMLString(video.videoURL, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
