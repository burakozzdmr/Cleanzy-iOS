//
//  ProfileRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import UIKit

// MARK: - ProfileRouter

final class ProfileRouter {
    weak var presenter: ProfilePresenterProtocol?
    weak var viewController: UIViewController?
}

// MARK: - ProfileRouterProtocol

extension ProfileRouter: ProfileRouterProtocol {
    func navigateToLogin() {
        let loginVC = LoginBuilder.createModule()
        guard let window = viewController?.view.window else { return }
        window.rootViewController = UINavigationController(rootViewController: loginVC)
        UIView.transition(with: window, duration: 0.35, options: .transitionCrossDissolve, animations: nil)
    }

    func navigateToEditProfile() {
        let editVC = EditProfileBuilder.createModule()
        viewController?.navigationController?.pushViewController(editVC, animated: true)
    }

    func navigateToPaymentMethods() {
        let payVC = PaymentMethodsBuilder.createModule()
        viewController?.navigationController?.pushViewController(payVC, animated: true)
    }
}
