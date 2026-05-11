//
//  UserDetailRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import UIKit

// MARK: - UserDetailRouter

final class UserDetailRouter {
    weak var presenter: UserDetailPresenterProtocol?
}

// MARK: - UserDetailRouterProtocol

extension UserDetailRouter: UserDetailRouterProtocol {
    func navigateBack() {
        guard let currentView = presenter?.view else { return }
        pop(currentView, animated: true)
    }

    func navigateToCreateMeet(cleanerID: Int, hourlyRate: Double, cleanerName: String) {
        guard let currentView = presenter?.view else { return }
        let target = CreateMeetBuilder.createModule(cleanerID: cleanerID, hourlyRate: hourlyRate, cleanerName: cleanerName)
        push(currentViewController: currentView, targetViewController: target, animated: true)
    }
}
