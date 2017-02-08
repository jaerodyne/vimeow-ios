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
    
    var animalVideos = [Animal]()
    var delegate: SearchModelDelegate!
    
    func getVideos(searchText: String) {
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: ["part": "snippet", "key": API_KEY, "q": searchText, "type": "video", "maxResults": "5", "pageToken": nextPageToken], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let jsonResult = response.result.value as? NSDictionary  {
                
                print(jsonResult["nextPageToken"] as! String)
                
                self.nextPageToken = jsonResult["nextPageToken"] as! String
                
//                self.nextPageToken = jsonResult["pageToken"] as! String
//                print("token \(self.nextPageToken)")
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
                
                self.animalVideos = videosResult
                if self.delegate != nil {
                    self.delegate.dataAreReady()
                    print(self.url)
                }
            }
        }
    }
}
