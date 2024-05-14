//
//  TabBarController.swift
//  NewsApp
//
//  Created by Eren Aşkın on 13.05.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
    }

    private func setupTabBar(){
        let home = self.createNav(with: "News", and: UIImage(systemName: "newspaper"), vc: ViewController())
        let favorites = self.createNav(with: "Favorites", and: UIImage(systemName: "star.fill"), vc: FavoritesViewController())
        self.setViewControllers([home,favorites], animated: true)
    }
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: vc)
        
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        nav.viewControllers.first?.navigationItem.title = title
        return nav
    }
}
