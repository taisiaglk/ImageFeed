import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageObserver: NSObjectProtocol?
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setProfileImage()
        setNamelabel()
        setNickName()
        setDescription()
        setLogOutButton()
        updateProfileDetails()
        updateAvatar()
        observeProfileImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func setNamelabel() {
        view.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setNickName() {
        view.addSubview(nickLabel)
        nickLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        nickLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setDescription() {
        view.addSubview(profileDescription)
        profileDescription.leadingAnchor.constraint(equalTo: nickLabel.leadingAnchor).isActive = true
        profileDescription.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 8).isActive = true
        profileDescription.numberOfLines = 0
        profileDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    private func setLogOutButton() {
        view.addSubview(logOutButton)
        logOutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    }
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        nameLabel.text = profile.name
        nickLabel.text = profile.name
        profileDescription.text = profile.bio
    }
    
    private func updateAvatar() {
        
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
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
    
    private func observeProfileImage() {
        profileImageObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
    }
}




