//
//  ProfileViewControllerSpy.swift
//  Image FeedTests
//
//  Created by Тася Галкина on 08.01.2024.
//

import Foundation
import UIKit
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    
    var setAvatarCheck = false
    var setProfileImageCheck = false
    
    func goToSplashScreen() {
        setAvatarCheck = true
    }
    
    func setAvatar() {
        setProfileImageCheck = true
    }
    
    func setProfileImage() {
         
    }
    
    func setNamelabel() {
         
    }
    
    func setNickName() {
         
    }
    
    func setDescription() {
         
    }
    
    func setLogOutButton() {
         
    }
    
    func observeProfileImage() {
         
    }
    
    func updateProfileDetails() {
         
    }
    
    func showAlert() {
         
    }
    
}
