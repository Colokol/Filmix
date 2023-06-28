//
//  ViewController.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 28.06.23.
//

import UIKit

class TabBarViewController: UITabBarController {




    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: ComingSoonViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadViewController())

        vc1.tabBarItem.image = UIImage(systemName: "house.circle")
        vc2.tabBarItem.image = UIImage(systemName: "eye.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.circle")

        vc1.tabBarItem.title = "Home"
        vc2.tabBarItem.title = "Cooming"
        vc3.tabBarItem.title = "Search"
        vc4.tabBarItem.title = "Download"

        //setViewControllers([vc1,vc2,vc3,vc4], animated: true)
    }


}

