//
//  FavoritesTableViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/10/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    var favoriteVideos = [Animal]()
    
    func readPropertyList() {
        var format = PropertyListSerialization.PropertyListFormat.xml
        var plistData:[String:AnyObject] = [:]
        let plistPath:String?  = Bundle.main.path(forResource: "./Favorites", ofType: "plist")!
        let plistXML = FileManager.default.contents(atPath: plistPath!)!
        do {
            plistData = try PropertyListSerialization.propertyList(from: plistXML,                                                                             options: .mutableContainersAndLeaves, format: &format) as! [String:AnyObject]
            let tempArr = plistData["Favorites"] as! NSArray
            
            for video in tempArr {
                let favorite = Animal()
                favorite.title = (video as! NSObject).value(forKeyPath: "title") as! String
                favorite._description = (video as! NSObject).value(forKeyPath: "description") as! String
                favorite.thumbnailUrl = (video as! NSObject).value(forKeyPath: "thumbnailUrl") as! String
                favorite.id = (video as! NSObject).value(forKeyPath: "id") as! String
                favoriteVideos.append(favorite)
                print("favs \(favoriteVideos)")
            }
        } catch {
            print("Error reading plist: \(error), format: \(format)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //display logo
        let titleView = UIView(frame: CGRect(0, 0, 120, 30))
        let titleImageView = UIImageView(image: UIImage(named: "ViMeow Logo"))
        titleImageView.frame = CGRect(0, 0, titleView.frame.width, titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        
//        readPropertyList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favoriteVideos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        cell.favoriteVideoTitleLabel.text = favoriteVideos[indexPath.row].title
        
//        var favoriteVideo = favoriteVideos[indexPath.row] as NSObject
//        if let myFavorites = PlistManager.sharedInstance.getValueForKey(key: favoriteVideos[indexPath.row].id) {
//            print("myFavorites")
//            
//            print(myFavorites)
//                }
        
//        var urlString = PlistManager.sharedInstance.getValueForKey(key: favoriteVideos[indexPath.row].thumbnailUrl)
//            .replacingOccurrences(of: "\r\n", with: " ")
            //remove \r\n from end of urlString, like why does this exist?
//            urlString = String(urlString.characters.filter { !" \n\t\r".characters.contains($0) })
        //let url = URL(string: urlString)
        var urlString = favoriteVideos[indexPath.row].thumbnailUrl.replacingOccurrences(of: "\r\n", with: " ")
        //remove \r\n from end of urlString, like why does this exist?
        urlString = String(urlString.characters.filter { !" \n\t\r".characters.contains($0) })
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    if let data = data {
                        cell.favoriteVideoImageView.image = UIImage(data: data)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        })
        task.resume()
        return cell

    }

    
    // MARK: - Navigation

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(favoriteVideos[indexPath.row].title)
        performSegue(withIdentifier: "showFavorite", sender: self)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavorite" {
            let vc = segue.destination as! AnimalVideoTableViewController
            let indexPath = tableView.indexPathForSelectedRow!
            vc.vidTitle = favoriteVideos[indexPath.row].title
            vc.vidDescription = favoriteVideos[indexPath.row]._description
            vc.vidId = favoriteVideos[indexPath.row].id
        }
    }

}
