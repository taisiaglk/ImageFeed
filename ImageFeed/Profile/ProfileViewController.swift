import Foundation
import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func goToSplashScreen()
    func setAvatar()
    func setProfileImage()
    func setNamelabel()
    func setNickName()
    func setDescription()
    func setLogOutButton()
    func observeProfileImage()
    func updateProfileDetails()
    func showAlert()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    private let token = OAuth2TokenStorage()
    
    private var nameLabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .ypWhite
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private var nickLabel = {
        let nickLabel = UILabel()
        nickLabel.textColor = .gray
        nickLabel.font = .boldSystemFont(ofSize: 13)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        return nickLabel
    }()
    
    private var profileDescription = {
        let profileDescription = UILabel()
        profileDescription.textColor = .white
        profileDescription.font = .boldSystemFont(ofSize: 13)
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        return profileDescription
    }()
    
    private var profileImageView = {
        let profileImageView = UIImageView(image: UIImage(named: "avatar"))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        return profileImageView
    }()
    
    private var logOutButton = {
        let logOutButton = UIButton()
        logOutButton.setImage(UIImage(named: "Exit_button"), for: .normal)
        logOutButton.tintColor = .ypRed
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    func setAvatar() {
        guard let url = presenter?.getProfileImageURL() else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 70, backgroundColor: .clear)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "person.crop.circle.fill.png"),
            options: [.processor(processor),
                      .cacheSerializer(FormatIndicatedCacheSerializer.png)]
        )
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
        //presenter?.view = self
        presenter = ProfileViewPresenter(view: self)
        presenter?.viewDidLoad()
        }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
    }
    
     func setProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
      func setNamelabel() {
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
      func setNickName() {
        view.addSubview(nickLabel)
        nickLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        nickLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
      func setDescription() {
        view.addSubview(profileDescription)
        profileDescription.leadingAnchor.constraint(equalTo: nickLabel.leadingAnchor).isActive = true
        profileDescription.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8).isActive = true
        profileDescription.numberOfLines = 0
        profileDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
      func setLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        logOutButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        
    }
    
      func updateProfileDetails() {
        guard let profile = presenter?.getProfileDetails() else { return }
        nameLabel.text = profile.name
        nickLabel.text = profile.name
        profileDescription.text = profile.bio
    }

    func observeProfileImage() {
        profileImageObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    setAvatar()
                }
    }
    
    
    func goToSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
    
    @objc
    func showAlert() {
        let alertModel = AlertModel(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            firstButtonText: "ДА",
            secondButtonText: "НЕТ",
            firstButtonAction: { [weak self] in
                guard let self = self else { return }
                presenter?.cleanAndSwitchToSplashView()
            },
            secondButtonAction: nil
        )
        AlertPresenter.showAlert(alertModel: alertModel, delegate: self)
    }
    
    
}
