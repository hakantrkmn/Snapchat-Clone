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
        let upload = createNav(with: "Upload", and: UIImage(systemName: "house"), vc: UploadVC())
        let settings = createNav(with: "Settings", and: UIImage(systemName: "house"), vc: SettingsVC())

        self.setViewControllers([feed,upload,settings], animated: true)
        // Do any additional setup after loading the view.
    }
    

    func createNav(with title : String , and image : UIImage? , vc : UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title + "Controller"
        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)
        return nav
    }

}
