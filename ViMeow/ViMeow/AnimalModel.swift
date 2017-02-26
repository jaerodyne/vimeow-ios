//
//  AnimalModel.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/1/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit
import Alamofire
import SwiftRandom

//lets LastVideosVC know that all videos have been collected in the array and are ready
protocol SearchModelDelegate {
    func dataAreReady()
}

class AnimalModel: NSObject {
    
    private var API_KEY = "AIzaSyAJ7h6mfpzCkaomGO3BTevEgPXCcRtzwJ0"
    private var url = "https://www.googleapis.com/youtube/v3/search"
    private var nextPageToken = ""
    
    //save user default for playlist
    let myDefaults = UserDefaults.standard
    let currentPageToken = ""
    
    var animalVideos = [Animal]()
    var delegate: SearchModelDelegate!

    func getVideos(searchText: String) {
        let randomDate = Randoms.randomDateWithinDaysBeforeToday(3650).iso8601
        //get current page token
        if self.myDefaults.string(forKey: currentPageToken) != nil {
            self.nextPageToken = self.myDefaults.string(forKey: currentPageToken)!
        }
        
        Alamofire.request(url, method: HTTPMethod.get, parameters: ["part": "snippet", "key": API_KEY, "q": searchText, "type": "video", "maxResults": "18", "publishedBefore": randomDate], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
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

//http://stackoverflow.com/questions/28016578/swift-how-to-create-a-date-time-stamp-and-format-as-iso-8601-rfc-3339-utc-tim

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
