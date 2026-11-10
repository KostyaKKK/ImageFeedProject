//
//  TabBarController.swift
//  ImageFeedProject
//
//  Created by Константин Кащеев on 24.10.2026.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        imagesListViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_editorial_NoActive")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "tab_editorial_active")?.withRenderingMode(.alwaysOriginal)
        )
            
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: "tab_profile_NoActive")?.withRenderingMode(.alwaysOriginal),
                       selectedImage: UIImage(named: "tab_profile_active")?.withRenderingMode(.alwaysOriginal)
                   )
       self.viewControllers = [imagesListViewController, profileViewController]
       }
        
}
