//
//  PrepareContentRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import UIKit

// MARK: - PrepareContentRouter

final class PrepareContentRouter {
    weak var presenter: PrepareContentPresenterProtocol?
}

// MARK: - PrepareContentRouterProtocol

extension PrepareContentRouter: PrepareContentRouterProtocol {
    func prepareContentToHomeScreen() {
        guard let currentView = presenter?.view else { return }
        self.push(currentViewController: currentView, targetViewController: TabBarController(), animated: true)
    }
}
