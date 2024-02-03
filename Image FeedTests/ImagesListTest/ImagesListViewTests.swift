//
//  ImagesListViewTests.swift
//  Image FeedTests
//
//  Created by Тася Галкина on 21.01.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: ImagesListService())
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testSetLike() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: ImagesListService())
        viewController.presenter = presenter
        presenter.view = viewController
        let photo = Photo(id: "123", size: CGSize(width: 400, height: 400), createdAt: Date(), welcomeDescription: "testDesc", thumbImageURL: "url1", largeImageURL: "url2", isLiked: false)
        let indexPath = IndexPath(row: 0, section: 0)
        
        let cell = ImagesListCell()
        cell.delegate = viewController
        
        
        //when
        presenter.imagesListCellDidTapLike(cell, indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenter.changeLikeCalled)
    }
    
    func testTableViewUpdate() {
        //given
        let viewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy(imagesListService: ImagesListService())
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.updateTableViewAnimated()
        
        //then
        XCTAssertTrue(presenter.tableViewUpdateCheck)
    }
    
}

