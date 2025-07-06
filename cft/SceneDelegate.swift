//
//  SceneDelegate.swift
//  cft
//
//  Created by Георгий Асеев on 01.07.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootVC: UIViewController
        if UserSession.shared.isRegistered {
            rootVC = MainViewController()
        } else {
            rootVC = RegistrationViewController()
        }
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
    }
}

