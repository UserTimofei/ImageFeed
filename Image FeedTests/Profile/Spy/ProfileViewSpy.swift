@testable import ImageFeed
import Foundation

class ProfileViewSpy: ProfileViewProtocol {
    var presenter: ImageFeed.ProfilePresenterProtocol?
    
    var showLoadingPlaceholderCalled = false
    var showProfileCalled = false
    var lastProfile: Profile?
    var showAvatarCalled = false
    var lastAvatarURL: URL?
    var showLogoutAlertCalled = false
    var logoutAlertCompletion: ((Bool) -> Void)?
    
    func showLoadingPlaceholder() {
        showLoadingPlaceholderCalled = true
    }
    
    func showProfile(_ profile: ImageFeed.Profile) {
        showProfileCalled = true
        lastProfile = profile
    }
    
    func showAvatar(url: URL?) {
        showAvatarCalled = true
        lastAvatarURL = url
    }
    
    func showLogoutAlert(completion: @escaping (Bool) -> Void) {
        showLogoutAlertCalled = true
        logoutAlertCompletion = completion
    }
}
