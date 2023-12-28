import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    weak var delegate: ImagesListCellDelegate?
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    
    @IBAction func likeButtonClick(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
        feedbackGenerator.notificationOccurred(.success)
    }
    
    func setIsLiked(entryValue: Bool) {
        let image = entryValue ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(image, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImage.kf.cancelDownloadTask()
    }
}
