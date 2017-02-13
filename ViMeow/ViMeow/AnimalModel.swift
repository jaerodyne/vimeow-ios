//
//  AnimalModel.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/1/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit
import Alamofire

//lets LastVideosVC know that all videos have been collected in the array and are ready
protocol SearchModelDelegate {
    func dataAreReady()
}

class AnimalModel: NSObject {
    
    private var channelId: String = "UCBJycsmduvYEL83R_U4JriQ"
    private var API_KEY = "AIzaSyAJ7h6mfpzCkaomGO3BTevEgPXCcRtzwJ0"
    private var url = "https://www.googleapis.com/youtube/v3/search"
    private var nextPageToken = ""
    
    //save user default for playlist
    let myDefaults = UserDefaults.standard
    let currentPageToken = ""
    
    var animalVideos = [Animal]()
    var delegate: SearchModelDelegate!
    
    func getVideos(searchText: String) {
        
        //get current page token
        if self.myDefaults.string(forKey: currentPageToken) != nil {
            self.nextPageToken = self.myDefaults.string(forKey: currentPageToken)!
        }
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: ["part": "snippet", "key": API_KEY, "q": searchText, "type": "video", "maxResults": "5", "pageToken": nextPageToken], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let jsonResult = response.result.value as? NSDictionary  {
                
                self.nextPageToken = jsonResult["nextPageToken"] as! String

                var videosResult = [Animal]()
                
                for video in jsonResult["items"] as! NSArray {
                    
                    let videoObj = Animal()
                    
                    videoObj.title = (video as! NSObject).value(forKeyPath: "snippet.title") as! String
                    videoObj._description = (video as! NSObject).value(forKeyPath: "snippet.description") as! String
                    
                    if (video as! NSObject).value(forKeyPath: "id.videoId") != nil {
                        videoObj.id = (video as! NSObject).value(forKeyPath: "id.videoId") as! String
                    }
                    
                    // get the best thumbnail for video
                    if (video as! NSObject).value(forKeyPath: "snippet.thumbnails.high.url") != nil {
                        videoObj.thumbnailUrl = (video as! NSObject).value(forKeyPath: "snippet.thumbnails.high.url") as! String
                    } else if (video as! NSObject).value(forKeyPath: "snippet.thumbnails.medium.url") != nil {
                        videoObj.thumbnailUrl = (video as! NSObject).value(forKeyPath: "snippet.thumbnails.medium.url") as! String
                    } else if (video as! NSObject).value(forKeyPath: "snippet.thumbnails.default.url") != nil {
                        videoObj.thumbnailUrl = (video as! NSObject).value(forKeyPath: "snippet.thumbnails.default.url") as! String
                    }
                    videosResult.append(videoObj)
                }
                //set the current page token to the next page token to pull up a different playlist of videos
                self.myDefaults.set(self.nextPageToken, forKey: self.currentPageToken)
                self.animalVideos = videosResult
                if self.delegate != nil {
                    self.delegate.dataAreReady()
                }
            }
        }
    }
}
