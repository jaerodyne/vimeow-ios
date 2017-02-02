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
    var searchText: String = "Cats"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.getVideos(searchText: searchText)
        
    }
    
//    @IBAction func searchAction(_ sender: Any) {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchBar.delegate = self
//        searchController.searchBar.text = searchText
//        searchController.searchBar.isTranslucent = false
//        searchController.searchBar.barTintColor = UIColor(red: 50/255.5, green: 60/255.5, blue: 72/255.5, alpha: 1.0)
//        self.present(searchController, animated: true, completion: nil)
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchController.resignFirstResponder()
//        searchController.dismiss(animated: true, completion: nil)
//        searchText = searchBar.text!
//        
//        segmentedAction()
//    }
//    
    
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

}

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if segmentedControl.selectedSegmentIndex == 1 {
//            performSegue(withIdentifier: "showVideo2", sender: self)
//        } else if segmentedControl.selectedSegmentIndex == 0 {
//            performSegue(withIdentifier: "showPlaylistForChannel", sender: self)
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segmentedControl.selectedSegmentIndex == 1 {
//            if segue.identifier == "showVideo2" {
//                let vc = segue.destination as! VideoDetailsTableViewController
//                let indexPath = tableView.indexPathForSelectedRow!
//                vc.vidId = videosArray[indexPath.row].id
//                vc.vidTitle = videosArray[indexPath.row].title
//                vc.vidDescription = videosArray[indexPath.row]._description
//            }
//        } else if segmentedControl.selectedSegmentIndex == 0 {
//            if segue.identifier == "showPlaylistForChannel" {
//                let vc = segue.destination as! ChannelVideosTableViewController
//                let indexPath = tableView.indexPathForSelectedRow!
//                vc.channelId = channelArray[indexPath.row].channelId
//            }
//        }
//    }
//    


