import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    
    private let userDefaults = UserDefaults.standard
    
    
    private let tokenKey = "token"
    
    var token: String? {
        get {
            return userDefaults.string(forKey: tokenKey)
        }
        set {
            userDefaults.set(newValue, forKey: tokenKey)
        }
    }
}

