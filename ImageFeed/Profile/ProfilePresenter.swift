import Foundation

 public protocol ProfilePresenterProtocol {
    var view: ProfileViewProtocol? { get set }
    func viewDidLoad()
    func logoutButtonTapped()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let imageService: ProfileImageServiceProtocol
    private let logoutService: ProfileLogoutServiceProtocol
    private let authStorage: AuthStorageProtocol
    
    init(
        profileService: ProfileServiceProtocol, imageService: ProfileImageServiceProtocol, logoutService: ProfileLogoutServiceProtocol, authStorage: AuthStorageProtocol
    ) {
        self.profileService = profileService
        self.imageService = imageService
        self.logoutService = logoutService
        self.authStorage = authStorage
    }
    
    func viewDidLoad() {
        print("🟢 ProfilePresenter.viewDidLoad called")
        guard let tokenDI = authStorage.tokenDI else {
            print("🔴 No token found")
            view?.showLoadingPlaceholder()
            return
        }
        view?.showLoadingPlaceholder()
        profileService.fetchProfile(tokenDI) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    print("✅ Profile loaded: \(profile)")
                    self?.view?.showProfile(profile)
                    self?.loadAvatar(for: profile.username)
                case .failure(let error):
                    print("❌ Failed to load profile: \(error.localizedDescription)")
                    self?.view?.showLoadingPlaceholder()
                }
            }
        }
    }
    
    private func loadAvatar(for username: String) {
        imageService.fetchProfileImageURL(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let urlString):
                    if let url = URL(string: urlString) {
                        self?.view?.showAvatar(url: url)
                    }
                case .failure:
                    self?.view?.showAvatar(url: nil)
                }
            }
        }
    }
    
    func logoutButtonTapped() {
        view?.showLogoutAlert { [weak self] confirmed in
            if confirmed {
                self?.logoutService.logout()
            }
        }
    }
    
}
