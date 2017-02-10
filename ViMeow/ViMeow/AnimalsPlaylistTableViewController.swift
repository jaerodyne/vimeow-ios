//
//  AnimalsPlaylistTableViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/1/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class AnimalsPlaylistTableViewController: UITableViewController, SearchModelDelegate, UISearchBarDelegate {

    var videosArray = [Animal]()
    var model = AnimalModel()
    var searchController: UISearchController!
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        let tbc = tabBarController as! CustomTabBarViewController
        if tbc.selectedIndex == 0 {
            model.getVideos(searchText: "Cats")
        } else if tbc.selectedIndex == 1 {
            model.getVideos(searchText: "Dogs")
//            self.navigationItem.titleView = setTitle(title: "ViMeow", subtitle: "Dogs Dogs Dogs")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
//        imageView.contentMode = .scaleAspectFit
//        imageView.center = UINavigationBar().center
//        
//        let image = UIImage(named: "ViMeow Logo")
//        imageView.image = image
//        
//        navigationItem.titleView = imageView
//        
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
    
    
    func dataAreReady() {
        self.videosArray = model.animalVideos
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

