//
//  LoginRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

// MARK: - LoginRouter

final class LoginRouter {
    weak var presenter: LoginPresenterProtocol?
}

// MARK: - LoginRouterProtocol

extension LoginRouter: LoginRouterProtocol {
    func loginToHomeScreen() {
        guard let currentView = presenter?.view else { return }
        self.push(currentViewController: currentView, targetViewController: TabBarController(), animated: true)
    }
    
    func loginToForgotPasswordScreen() {
        guard let currentView = presenter?.view else { return }
        self.push(currentViewController: currentView, targetViewController: ForgotPasswordBuilder.createModule(), animated: true)
    }
    
    func loginToRegisterScreen() {
        guard let currentView = presenter?.view else { return }
        self.push(currentViewController: currentView, targetViewController: RegisterBuilder.createModule(), animated: true)
    }
}
