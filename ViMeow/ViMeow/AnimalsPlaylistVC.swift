//
//  AnimalPlaylistVC.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/19/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwiftRandom

class AnimalPlaylistVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,SearchModelDelegate, VideoThumbnailCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var videosArray = [Animal]()
    var model = AnimalModel()
    var searchController: UISearchController!
    var favoriteVideos = [[String: Any]]()
    var favButtons = [VideoThumbnailCell]()
    var randomCollection = ["Funny Animals", "Cute Animals", "Cute Baby Animals", "Viral Animal Videos", "Funny Pets"]

    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        
        //display logo
        let titleView = UIView(frame: CGRect(0, 0, 120, 30))
        let titleImageView = UIImageView(image: UIImage(named: "ViMeow Logo"))
        titleImageView.frame = CGRect(0, 0, titleView.frame.width, titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        
        //show appropriate views for tab bar item
        let tbc = tabBarController as! CustomTabBarViewController
        if tbc.selectedIndex == 0 {
            model.getVideos(searchText: "Cats")
        } else if tbc.selectedIndex == 1 {
            model.getVideos(searchText: "Dogs")
        } else if tbc.selectedIndex == 2{
//            get random animal videos
            model.getVideos(searchText: randomCollection[0..<randomCollection.count].randomItem()!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //implement pull to refresh
        let tbc = tabBarController as! CustomTabBarViewController
        collectionView.es_addPullToRefresh {
            //set favorite button images back to no fill
            for cell in self.favButtons {
                cell.favoriteBtn.setImage(UIImage(named:"favorites-icon-no-fill"), for: .normal)
            }
            self.favButtons = []
            if tbc.selectedIndex == 0 {
                self.model.getVideos(searchText: "Cats")
            } else if tbc.selectedIndex == 1 {
                self.model.getVideos(searchText: "Dogs")
            } else if tbc.selectedIndex == 2{
                self.model.getVideos(searchText: self.randomCollection[0..<self.randomCollection.count].randomItem()!)
            }

            self.collectionView.es_stopPullToRefresh()
            //delay time to make animation smoother
            usleep(300000)
            self.collectionView.reloadData()
        }
    }
    
    func dataAreReady() {
        self.videosArray = model.animalVideos
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource protocol

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath as IndexPath) as! VideoThumbnailCell
        
        // set delegate to call custom method in buttonTapped()
        cell.delegate = self

        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        let urlString = videosArray[indexPath.row].thumbnailUrl
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    if let data = data {
                        cell.thumbnailImage.image = UIImage(data: data)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        })
        task.resume()
        return cell
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            let vc = segue.destination as! AnimalVideoTableViewController
            if let cell = sender as? VideoThumbnailCell {
                let indexPath = collectionView!.indexPath(for: cell)
                vc.vidId = videosArray[(indexPath?.row)!].id
                vc.vidTitle = videosArray[(indexPath?.row)!].title
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as! HeaderCollectionReusableView

        let tbc = tabBarController as! CustomTabBarViewController
        if tbc.selectedIndex == 0 {
            header.imageView.image = UIImage(named: "cat-header")
        } else if tbc.selectedIndex == 1 {
            header.imageView.image = UIImage(named: "dog-header")
        } else if tbc.selectedIndex == 2{
    //            get random animal videos
            header.imageView.image = UIImage(named: "animals")
        }

        return header
    }
    
    func buttonTapped(cell: VideoThumbnailCell) {
        
        guard let indexPath = self.collectionView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        let favoriteVideo = videosArray[indexPath.row] as NSObject
        if (cell.favoriteBtn.currentImage?.isEqual(UIImage(named:"favorites-icon")))! {
            //add favorite button to array to keep track of favorites for reset upon pull to refresh
            favButtons.append(cell)
            //  Do whatever you need to do with the indexPath
            let favoriteVideoDict = ["title": (favoriteVideo).value(forKeyPath: "title") as! String, "description": (favoriteVideo).value(forKeyPath: "_description") as! String, "thumbnailUrl": (favoriteVideo).value(forKeyPath: "thumbnailUrl") as! String, "id": (favoriteVideo).value(forKeyPath: "id") as! String, "dateAdded": Date()] as [String : Any]
            PlistManager.sharedInstance.addNewItemWithKey(key: (favoriteVideo).value(forKeyPath: "id") as! String, value: favoriteVideoDict as AnyObject)
            //get dict value and throw it into array as new value
            favoriteVideos.append(PlistManager.sharedInstance.getValueForKey(key: (favoriteVideo).value(forKeyPath: "id") as! String) as! [String : Any])
            PlistManager.sharedInstance.saveValue(value: favoriteVideos as AnyObject, forKey: "Favorites")
        } else if (cell.favoriteBtn.currentImage?.isEqual(UIImage(named:"favorites-icon-no-fill")))! {
            //remove from favoriteVideos
            let unfavoritedVideo = (favoriteVideo).value(forKeyPath: "id") as! String
            for (index, var favorite) in favoriteVideos.enumerated() {
                if unfavoritedVideo == favorite["id"] as! String {
                    favoriteVideos.remove(at: index)
                }
            }
            //remove from plist
            PlistManager.sharedInstance.removeItemForKey(key: videosArray[indexPath.row].id)
        }
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}
