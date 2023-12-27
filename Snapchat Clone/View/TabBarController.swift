//
//  TabBarController.swift
//  Snapchat Clone
//
//  Created by Hakan Türkmen on 23.12.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let feed = createNav(with: "Feed", and: UIImage(systemName: "house"), vc: FeedVC())
        let upload = createNav(with: "Upload", and: UIImage(systemName: "square.and.arrow.up"), vc: UploadVC())
        let settings = createNav(with: "Settings", and: UIImage(systemName: "gear"), vc: SettingsVC())
        self.tabBar.tintColor = .black
        self.setViewControllers([feed,upload,settings], animated: true)
    }
    

    func createNav(with title : String , and image : UIImage? , vc : UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }

}
