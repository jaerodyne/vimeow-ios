//
//  AnimalsPlaylistTableViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/1/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class AnimalsPlaylistTableViewController: UITableViewController, SearchModelDelegate, UISearchBarDelegate, VideoTableViewCellDelegate {
    
    @IBOutlet var tableview: UITableView!

    var videosArray = [Animal]()
    var model = AnimalModel()
    var searchController: UISearchController!
    var favoriteVideos = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        let titleView = UIView(frame: CGRect(0, 0, 120, 30))
        let titleImageView = UIImageView(image: UIImage(named: "ViMeow Logo"))
        titleImageView.frame = CGRect(0, 0, titleView.frame.width, titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        
        let tbc = tabBarController as! CustomTabBarViewController
        if tbc.selectedIndex == 0 {
            model.getVideos(searchText: "Cats")
        } else if tbc.selectedIndex == 1 {
            model.getVideos(searchText: "Dogs")
        }

    }
    
    //get rid of whitespace before and after tableview cells
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -40, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return videosArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as! VideoTableViewCell
        
            //make custom cell functions accessible
            cell.delegate = self
        
            cell.videoTitleLabel.text = videosArray[indexPath.row].title
            
            let urlString = videosArray[indexPath.row].thumbnailUrl
            let url = URL(string: urlString)
            let session = URLSession.shared
            let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async(execute: {
                    if error == nil {
                        if let data = data {
                            cell.videoImageView.image = UIImage(data: data)
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            })
            task.resume()
            return cell
        }
    
    func buttonTapped(cell: VideoTableViewCell) {
        
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
//        favoriteVideos.removeAll()
        
        let favoriteVideo = videosArray[indexPath.row] as NSObject
        
        //if count is odd, button is toggled favorite
        //if count is even, button is removed as favorite
        if cell.count % 2 == 0 {
//            print(favoriteVideos)
//            print((favoriteVideo).value(forKeyPath: "title") as! String)
//            favoriteVideos.indexOf(.remove
//            favoriteVideos
            PlistManager.sharedInstance.removeItemForKey(key: videosArray[indexPath.row].id)
        } else {
            //  Do whatever you need to do with the indexPath
            let favoriteVideoDict = ["title": (favoriteVideo).value(forKeyPath: "title") as! String, "description": (favoriteVideo).value(forKeyPath: "_description") as! String, "thumbnailUrl": (favoriteVideo).value(forKeyPath: "thumbnailUrl") as! String, "id": (favoriteVideo).value(forKeyPath: "id") as! String, "dateAdded": Date()] as [String : Any]
            PlistManager.sharedInstance.addNewItemWithKey(key: (favoriteVideo).value(forKeyPath: "id") as! String, value: favoriteVideoDict as AnyObject)
            //get dict value and throw it into array as new value
            favoriteVideos.append(PlistManager.sharedInstance.getValueForKey(key: (favoriteVideo).value(forKeyPath: "id") as! String) as! [String : Any])
            PlistManager.sharedInstance.saveValue(value: favoriteVideos as AnyObject, forKey: "Favorites")
        }
    }
    
    
    func dataAreReady() {
        self.videosArray = model.animalVideos
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(videosArray[indexPath.row].title)
        performSegue(withIdentifier: "showVideo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVideo" {
            let vc = segue.destination as! AnimalVideoTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            vc.vidTitle = videosArray[indexPath.row].title
            vc.vidDescription = videosArray[indexPath.row]._description
            vc.vidId = videosArray[indexPath.row].id
        }
    }
    
    //write function to save favorite videos array to plist
    //delete duplicates
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

