//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Тася Галкина on 10.01.2024.
//

import Foundation
import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListService { get }
    var photosName: [Photo] { get set }
    
    func viewDidLoad()
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func updateTableViewAnimated()
}

final class ImagesListPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    let imagesListService = ImagesListService.shared
    var photosName: [Photo] = []
    private var imagesListServiceObserver: NSObjectProtocol?
    
    
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        var photo = photosName[indexPath.row]
        
        let newIsLiked = !photo.isLiked
        
        UIBlockingProgressHUD.show()
        
        imagesListService.changeLike(photoId: photo.id, isLike: newIsLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                photo.isLiked = newIsLiked
                self.photosName[indexPath.row] = photo
                cell.setIsLiked(entryValue: newIsLiked)
                
                UserDefaults.standard.set(newIsLiked, forKey: photo.id)
                
                UIBlockingProgressHUD.dismiss()
            case .failure:
                self.view?.showAlert()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photosName.count
        let newCount = imagesListService.photos.count
        photosName = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
}



