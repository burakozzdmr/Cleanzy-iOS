//
//  SendCodeRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 14.11.2025.
//

import UIKit

// MARK: - SendCodeRouter

final class SendCodeRouter {
    weak var presenter: SendCodePresenterProtocol?
}

// MARK: - SendCodeRouterProtocol

extension SendCodeRouter: SendCodeRouterProtocol {
    func sendCodeToLoginScreen() {
        guard let currentView = presenter?.view else { return }
        self.popToRoot(currentView, animated: true)
    }
}
