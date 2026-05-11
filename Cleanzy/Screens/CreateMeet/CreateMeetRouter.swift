//
//  CreateMeetRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import UIKit

// MARK: - CreateMeetRouter

final class CreateMeetRouter {
    weak var presenter: CreateMeetPresenterProtocol?
}

// MARK: - CreateMeetRouterProtocol

extension CreateMeetRouter: CreateMeetRouterProtocol {
    func navigateBack() {
        guard let currentView = presenter?.view else { return }
        pop(currentView, animated: true)
    }
}
