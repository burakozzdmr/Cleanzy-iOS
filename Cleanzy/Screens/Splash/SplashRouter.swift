//
//  SplashRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

// MARK: - SplashRouter

final class SplashRouter {
    weak var presenter: SplashPresenterProtocol?
}

// MARK: - SplashRouterProtocol

extension SplashRouter: SplashRouterProtocol {

    func splashToLogin() {
        transition(to: UINavigationController(rootViewController: LoginBuilder.createModule()))
    }

    func splashToHome() {
        transition(to: TabBarController())
    }
}

// MARK: - Private

private extension SplashRouter {
    func transition(to rootVC: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = scene.window else { return }
        window.rootViewController = rootVC
        UIView.transition(with: window, duration: 0.45, options: .transitionCrossDissolve, animations: nil)
    }
}
