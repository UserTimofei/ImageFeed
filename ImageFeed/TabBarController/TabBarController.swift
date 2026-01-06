import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            print("⚠️ Не удалось загрузить ImagesListViewController из Storyboard!")
            return
        }
        
        let imagesListPresenter = ImagesListPresenter(photoService: ImagesListService.shared)
        imagesListViewController.configure(with: imagesListPresenter)
        
        let profileViewController = ImageFeed.ProfileViewController()
        
        let profilePresenter = ProfilePresenter(
            profileService: ProfileService.shared,
            imageService: ProfileImageService.shared,
            logoutService: ProfileLogoutService.shared,
            authStorage: OAuth2TokenStorage.shared
        )
        profileViewController.configure(with: profilePresenter)
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
