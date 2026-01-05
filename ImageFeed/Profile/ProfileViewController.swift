import UIKit
import Kingfisher

public protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func showLoadingPlaceholder()
    func showProfile(_ profile: Profile)
    func showAvatar(url: URL?)
    func showLogoutAlert(completion: @escaping (Bool) -> Void)
}

final class ProfileViewController:
    UIViewController, ProfileViewProtocol {
    // MARK: - IBOutlets
    private let profilePhotoView = UIImageView()
    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    // MARK: - Dependencies
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("✅ ProfileViewController viewDidLoad called")
        print("presenter = \(String(describing: presenter))")
        setupUI()
        presenter?.viewDidLoad()
        
    }
    
    func configure(with presenter: ProfilePresenterProtocol) {
        guard self.presenter == nil else { return }
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    private func setupUI() {
        print("⚙️ Setting up ProfileViewController UI...")
        logoutButton.addTarget(self, action: #selector(logoutButtonTap), for: .touchUpInside)
        
        view.backgroundColor = UIColor(named: "YP Black")
        
        profilePhotoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePhotoView)
        
        nameLabel.accessibilityIdentifier = "ProfileNameLabel"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        loginLabel.accessibilityIdentifier = "ProfileUsernameLabel"
        loginLabel.textColor = UIColor(named: "YP Gray")
        loginLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        
        descriptionLabel.textColor = UIColor(named: "YP White")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        logoutButton.accessibilityIdentifier = "LogoutButton"
        logoutButton.setImage(UIImage.Image.image(named: "Exit"), for: .normal)
        logoutButton.tintColor = UIColor(named: "YP Red")
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profilePhotoView.widthAnchor.constraint(equalToConstant: 70),
            profilePhotoView.heightAnchor.constraint(equalToConstant: 70),
            profilePhotoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: profilePhotoView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profilePhotoView.centerYAnchor)
        ])
        print("✅ UI setup completed")
    }
    
    @objc
    func logoutButtonTap() {
        presenter?.logoutButtonTapped()
    }
}




extension ProfileViewController {
    
    func showLoadingPlaceholder() {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        nameLabel.text = "Загрузка..."
        loginLabel.text = ""
        descriptionLabel.text = ""
        profilePhotoView.image = placeholderImage
    }
    
    func showProfile(_ profile: Profile) {
        nameLabel.text = profile.name.isEmpty
        ? "Имя не указано"
        : profile.name
        loginLabel.text = profile.loginName.isEmpty
        ? "@неизвестный_пользователь"
        : profile.loginName
        descriptionLabel.text = (profile.bio?.isEmpty ?? true)
        ? "Профиль не заполнен"
        : profile.bio
    }
    
    func showAvatar(url: URL?) {
        
        print("imageUrl: \(String(describing: url))")
        
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profilePhotoView.kf.indicatorType = .activity
        profilePhotoView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]) { result in
                switch result {
                case .success(let value):
                    print(value.image)
                    print(value.cacheType)
                    print(value.source)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func showLogoutAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alertController.view.accessibilityIdentifier = "LogoutConfirmationAlert"
        
        alertController.addAction(UIAlertAction(title: "Да", style: .cancel) { _ in
            completion(true)
        })
        
        
        alertController.addAction(UIAlertAction(title: "Нет", style: .default) { _ in
            completion(false)
        })
        present(alertController, animated: true)
        
    }
    
}


