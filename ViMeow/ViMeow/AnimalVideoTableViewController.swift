//
//  AnimalVideoTableViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/2/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit
import Alamofire

class AnimalVideoTableViewController: UITableViewController {
    
    private var API_KEY = "AIzaSyAJ7h6mfpzCkaomGO3BTevEgPXCcRtzwJ0"
    private var url = "https://www.googleapis.com/youtube/v3/videos"
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoDescription: UITextView!
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
        
        getLongDescription()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        videoTitleLabel.text = vidTitle
        videoDescription.text = vidDescription
        videoDescription.scrollRangeToVisible(NSRange(location: 0, length: 0))
        
        if let webView = webView {
            let bounds = UIScreen.main.bounds
            let width = bounds.size.width
            let height = webView.bounds.size.height

            self.view.addSubview(webView)
            self.view.bringSubview(toFront: webView)

            webView.scrollView.isScrollEnabled = false

             let embeddedHTML = "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(width)' height='\(height)' src='http://www.youtube.com/embed/\(vidId)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
            
            //let embeddedHTML = "<html><head><style type=\"text/css\">body {background-color: transparent; color: white;}</style></head><body style=\"margin:0\"><iframe frameBorder=\"0\" height=\"" + String(describing: height) + "\"width=\"" + String(describing: width) + "\" src=\"http://www.youtube.com/embed/" + vidId + "?autoplay=1&showinfo=0&modestbranding=1&frameborder=0&rel=0\"></iframe></body></html>"
            
            // Load your webView with the HTML we just set up
            webView.loadHTMLString(embeddedHTML, baseURL: Bundle.main.bundleURL)
        }
        
    }
    
    //TODO: Refactor logic into model so it isn't in the controller
    //Youtube's API has a limitation where running a search doesn't give you the full description and instead returns a truncated string. You have to make another request once you have the video's id, pulling from the videos route in the Youtube API in order to get the full description. WHY
    func getLongDescription() {
        Alamofire.request(url, method: HTTPMethod.get, parameters: ["part": "snippet", "key": API_KEY, "id": vidId], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let jsonResult = response.result.value as? NSDictionary  {
                
                for video in jsonResult["items"] as! NSArray {
                    
                    self.vidDescription = (video as AnyObject).value(forKeyPath: "snippet.description") as! String
                }
            }
        }
    }
}
