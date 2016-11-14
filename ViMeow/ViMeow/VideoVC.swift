//
//  VideoVC.swift
//  ViMeow
//
//  Created by Jillian Somera on 11/13/16.
//  Copyright © 2016 Jillian Somera. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {

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
