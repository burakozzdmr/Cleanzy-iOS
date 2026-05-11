//
//  EditProfileRouter.swift
//  Cleanzy
//

import UIKit

// MARK: - EditProfileRouter

final class EditProfileRouter {
    weak var viewController: UIViewController?
    weak var presenter: EditProfilePresenterProtocol?
}

// MARK: - EditProfileRouterProtocol

extension EditProfileRouter: EditProfileRouterProtocol {
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
