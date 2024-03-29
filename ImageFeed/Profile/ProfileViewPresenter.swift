//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Тася Галкина on 08.01.2024.
//

import Foundation

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func getProfileImageURL() -> URL?
    func getProfileDetails() -> Profile?
    func cleanAndSwitchToSplashView()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let token = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    private var profileImageObserver: NSObjectProtocol?
    
    init(view: ProfileViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.setProfileImage()
        view?.setNamelabel()
        view?.setNickName()
        view?.setDescription()
        view?.setLogOutButton()
        view?.updateProfileDetails()
        view?.setAvatar()
        view?.observeProfileImage()
    }
    
    
    func getProfileImageURL() -> URL? {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
    
    func getProfileDetails() -> Profile? {
        guard let profile = profileService.profile else { return nil }
        return profile
    }
    
    func cleanAndSwitchToSplashView() {
        OAuth2Service.clean()
        profileImageService.clean()
        profileService.clean()
        imagesListService.clean()
        token.clean()
        
        view?.goToSplashScreen()
        
    }
    
}

