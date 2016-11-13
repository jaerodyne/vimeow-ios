//
//  Video.swift
//  ViMeow
//
//  Created by Jillian Somera on 11/13/16.
//  Copyright © 2016 Jillian Somera. All rights reserved.
//

import Foundation

class Video {
    private var _imageURL: String!
    private var _videoURL: String!
    private var _videoTitle: String!
    
    //    getters
    var imageURL: String {
        return _imageURL
    }
    
    var videoURL: String {
        return _videoURL
    }
    
    var videoTitle: String {
        return _videoTitle
    }
    
    init(imageURL: String, videoURL: String, videoTitle: String){
        _imageURL = imageURL
        _videoURL = videoURL
        _videoTitle = videoTitle
    }
    
    
}
