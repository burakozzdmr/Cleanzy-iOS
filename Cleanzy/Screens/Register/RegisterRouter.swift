//
//  RegisterRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

// MARK: - RegisterRouter

final class RegisterRouter {
    weak var presenter: RegisterPresenterProtocol?
}

// MARK: - RegisterRouterProtocol

extension RegisterRouter: RegisterRouterProtocol {
    func registerToPrepareContentScreen() {
        guard let currentView = presenter?.view else { return }
        self.push(currentViewController: currentView, targetViewController: PrepareContentBuilder.createModule(), animated: true)
    }
}
