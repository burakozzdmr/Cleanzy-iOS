//
//  AppointmentsRouter.swift
//  Cleanzy
//

import UIKit

// MARK: - AppointmentsRouter

final class AppointmentsRouter {
    weak var viewController: UIViewController?
    weak var presenter: AppointmentsPresenterProtocol?
}

// MARK: - AppointmentsRouterProtocol

extension AppointmentsRouter: AppointmentsRouterProtocol { }
