//
//  AnimalVideoTableViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/2/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class AnimalVideoTableViewController: UITableViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDescription: UITextView!
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var vidTitle: String!
    var vidDescription: String = ""
    var vidId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //display logo
        let titleView = UIView(frame: CGRect(0, 0, 120, 30))
        let titleImageView = UIImageView(image: UIImage(named: "ViMeow Logo"))
        titleImageView.frame = CGRect(0, 0, titleView.frame.width, titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
    }

    override func viewDidAppear(_ animated: Bool) {
        
        videoTitleLabel.text = vidTitle
//        videoDescription.text = vidDescription
//        videoDescription.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
        if let webView = webView {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            let height = webView.bounds.size.height

            self.view.addSubview(webView)
            self.view.bringSubview(toFront: webView)

            webView.scrollView.isScrollEnabled = false

            let embeddedHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(width)' height='\(height)' src='http://www.youtube.com/embed/\(vidId)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
            
            // Load your webView with the HTML we just set up
            webView.loadHTMLString(embeddedHTML, baseURL: Bundle.main.bundleURL)
        }
        
    }

}
