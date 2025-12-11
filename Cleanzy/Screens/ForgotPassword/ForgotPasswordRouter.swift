//
//  ForgotPasswordRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import UIKit

// MARK: - ForgotPasswordRouter

final class ForgotPasswordRouter {
    weak var presenter: ForgotPasswordPresenterProtocol?
}

// MARK: - ForgotPasswordRouterProtocol

extension ForgotPasswordRouter: ForgotPasswordRouterProtocol {
    func forgotPasswordToSendCodeScreen() {
        guard let currentView = presenter?.view else { return }
        self.push(currentViewController: currentView, targetViewController: SendCodeBuilder.createModule(), animated: true)
    }
}
