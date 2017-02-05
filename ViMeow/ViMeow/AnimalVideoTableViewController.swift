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
    
    var vidId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if let webView = webView {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            let height = webView.bounds.size.height

            self.view.addSubview(webView)
            self.view.bringSubview(toFront: webView)

            webView.scrollView.isScrollEnabled = false

            let embededHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(width)' height='\(height)' src='http://www.youtube.com/embed/\(vidId)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
            
            // Load your webView with the HTML we just set up
            webView.loadHTMLString(embededHTML, baseURL: Bundle.main.bundleURL)
        }
        
    }

}
