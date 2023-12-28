import UIKit

class ImagesListViewController: UIViewController{
    
    
    @IBOutlet private var tableView: UITableView!
    
    private var photosName: [Photo] = []
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
        imagesListService.fetchPhotosNextPage()
    }
    private func updateImage() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            if let url = imagesListService.photos[indexPath.row].largeImageURL,
               let imageURL = URL(string: url) {
                viewController.imageURL = imageURL
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let url = imagesListService.photos[indexPath.row].thumbImageURL,
           let imageURL = URL(string: url) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(
                with: imageURL,
                placeholder: UIImage(named: "Stub")) { [weak self] _ in
                    guard let self = self else { return }
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            if let date = imagesListService.photos[indexPath.row].createdAt {
                cell.dateLabel.text = dateFormatter.string(from: date as Date)
            } else {
                cell.dateLabel.text = ""
            }
            let like = imagesListService.photos[indexPath.row].isLiked
            cell.setIsLiked(entryValue: like)
        }
    }
    
    
    func updateTableViewAnimated() {
        let oldCount = photosName.count
        let newCount = imagesListService.photos.count
        photosName = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = imagesListService.photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photosName[indexPath.row]
        // Покажем лоадер
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success:
                // Синхронизируем массив картинок с сервисом
                self.photosName = self.imagesListService.photos
                // Изменим индикацию лайка картинки
                cell.setIsLiked(entryValue: self.photosName[indexPath.row].isLiked)
                // Уберём лоадер
                UIBlockingProgressHUD.dismiss()
            case .failure:
                self.showAlert()
                // Уберём лоадер
                UIBlockingProgressHUD.dismiss()
                // Покажем, что что-то пошло не так
                // TODO: Показать ошибку с использованием UIAlertController
            }
        }
    }
    
    private func showAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось лайкнуть",
            buttonText: "ОК",
            buttonAction: { [weak self] in
                guard let self = self else {
                    return
                }
            }
        )
        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }
    
}



