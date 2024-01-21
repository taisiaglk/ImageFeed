//
//  ImagesListPresenterSpy.swift
//  Image FeedTests
//
//  Created by Тася Галкина on 21.01.2024.
//

import UIKit
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    var imagesListService: ImageFeed.ImagesListService
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var photosName: [ImageFeed.Photo] = []
    
    var viewDidLoadCalled = false
    var changeLikeCalled = false
    var tableViewUpdateCheck = false
    
    func imagesListCellDidTapLike(_ cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        changeLike(photoId: "123", isLike: false) { _ in }
    }
    
    func updateTableViewAnimated() {
        tableViewUpdateCheck = true
    }
    
    init(imagesListService: ImagesListService) {
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        changeLikeCalled = true
    }
    
}
