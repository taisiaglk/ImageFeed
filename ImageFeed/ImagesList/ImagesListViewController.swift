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
        
        guard let imagesListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imagesListCell.delegate = self
        configCell(for: imagesListCell, with: indexPath)
        return imagesListCell
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
                cell.dateLabel.text = dateFormat.string(from: date as Date)
            } else {
                cell.dateLabel.text = ""
            }
            let like = UserDefaults.standard.bool(forKey: imagesListService.photos[indexPath.row].id)
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
        
        let imageInsert = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsert.left - imageInsert.right
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsert.top + imageInsert.bottom
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
                self.showAlert()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    
    private func showAlert() {
        let alertModel = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось лайкнуть",
            firstButtonText: "ОК",
            secondButtonText: nil,
            firstButtonAction: nil,
            secondButtonAction: nil
        )
        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }
}



