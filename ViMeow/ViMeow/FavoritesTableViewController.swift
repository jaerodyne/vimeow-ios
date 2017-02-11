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

    override func viewDidLoad() {
        super.viewDidLoad()

        //display logo
        let titleView = UIView(frame: CGRect(0, 0, 120, 30))
        let titleImageView = UIImageView(image: UIImage(named: "ViMeow Logo"))
        titleImageView.frame = CGRect(0, 0, titleView.frame.width, titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
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
        
        let urlString = favoriteVideos[indexPath.row].thumbnailUrl
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
