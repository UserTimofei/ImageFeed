//
//  SceneDelegate.swift
//  ImageFeed
//
//  Created by Timofei Kirichenko on 04.10.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlerUserLogout),
            name: .userDidLogout,
            object: nil)
        
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)  
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
    }
    
    @objc private func handlerUserLogout() {
        
            // Очистка токена
            //OAuth2TokenStorage.shared.token = nil
            OAuth2TokenStorage.shared.clearToken()
            // Устанавливаем SplashViewController как root — как при первом запуске
            guard let window = window else { return }

            let splashVC = SplashViewController()
            window.rootViewController = splashVC
            window.makeKeyAndVisible()
    }
}

