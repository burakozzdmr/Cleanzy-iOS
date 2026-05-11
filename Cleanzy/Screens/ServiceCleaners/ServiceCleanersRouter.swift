//
//  ServiceCleanersRouter.swift
//  Cleanzy
//

import UIKit

final class ServiceCleanersRouter {
    weak var viewController: UIViewController?
    weak var presenter: ServiceCleanersPresenterProtocol?
}

extension ServiceCleanersRouter: ServiceCleanersRouterProtocol {
    func navigateToDetail(cleanerID: Int) {
        let detailVC = UserDetailBuilder.createModule(with: cleanerID)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
