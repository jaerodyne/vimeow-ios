//
//  CustomTabBarViewController.swift
//  ViMeow
//
//  Created by Jillian Somera on 2/2/17.
//  Copyright © 2017 Jillian Somera. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
//    let animal = AnimalModel()
//    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNextCondensed-Regular", size: 10)!], for: .normal)
    }
}
