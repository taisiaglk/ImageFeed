//
//  ProfileViewPresenterSpy.swift
//  Image FeedTests
//
//  Created by Тася Галкина on 08.01.2024.
//

@testable import ImageFeed
import Foundation


final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    var profileData = Profile(decoded: ProfileResult(username: "Ivanov",
                                                     firstName: "Ivan",
                                                     lastName: "Ivanovich",
                                                     bio: "lalala"))
    var viewDidLoadCalled = false
    var profileImageCheck = false
    var logoutCheck = false
    
    
    func getProfileImageURL() -> URL? {
        profileImageCheck = true
        return nil
    }
    
    func getProfileDetails() -> ImageFeed.Profile? {
        let profile = profileData
        return profile
    }
    
    func cleanAndSwitchToSplashView() {
        logoutCheck = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}
