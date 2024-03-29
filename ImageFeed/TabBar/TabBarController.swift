//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Тася Галкина on 25.12.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        imageListViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        profileViewController.configure(ProfileViewPresenter(view: profileViewController))
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
