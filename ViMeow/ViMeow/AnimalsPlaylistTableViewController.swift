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
            self.navigationItem.titleView = setTitle(title: "ViMeow", subtitle: "Cats Cats Cats")
        } else if tbc.selectedIndex == 1 {
            model.getVideos(searchText: "Dogs")
            self.navigationItem.titleView = setTitle(title: "ViMeow", subtitle: "Dogs Dogs Dogs")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        
        let tbc = tabBarController as! CustomTabBarViewController
        if tbc.selectedIndex == 0 {
            model.getVideos(searchText: "Cats")
            self.navigationItem.titleView = setTitle(title: "ViMeow", subtitle: "Cats Cats Cats")
        } else if tbc.selectedIndex == 1 {
            model.getVideos(searchText: "Dogs")
            self.navigationItem.titleView = setTitle(title: "ViMeow", subtitle: "Dogs Dogs Dogs")
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
    
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(0, -2, 0, 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.init(red: 56/255.0, green: 185/255.0, blue: 67/255.0, alpha: 255/255.0)
        titleLabel.font = UIFont(name: "AvenirNextCondensed-Bold", size: 16)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.init(red: 56/255.0, green: 185/255.0, blue: 67/255.0, alpha: 255/255.0)
        subtitleLabel.font =  UIFont(name: "AvenirNextCondensed-Regular", size: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        return titleView
    }

}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
}

