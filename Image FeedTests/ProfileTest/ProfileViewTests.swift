//
//  ProfileViewTests.swift
//  Image FeedTests
//
//  Created by Тася Галкина on 08.01.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled) //behaviour verification
    }
    
    func testCleanCheck() {
        //given
        let token = OAuth2TokenStorage()
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        let checker = ProfileViewPresenter(view: viewController)
        
        //when
        presenter.cleanAndSwitchToSplashView()
        checker.cleanAndSwitchToSplashView()
        
        //then
        XCTAssertEqual(token.token, nil)
        XCTAssertTrue(presenter.logoutCheck)
    }
    
    func testProfileDetails() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        guard let profile = presenter.getProfileDetails() else { return }
        
        //then
        XCTAssertEqual(profile.username, "Ivanov")
        XCTAssertEqual(profile.loginName, "@Ivanov")
    }
    
    func testGetImageURL() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = presenter.getProfileImageURL()
        
        //then
        XCTAssertTrue(presenter.profileImageCheck)
    }
}
