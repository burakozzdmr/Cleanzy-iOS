//
//  HomepageRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import UIKit

// MARK: - HomepageRouter

final class HomepageRouter {
    weak var presenter: HomepagePresenterProtocol?
    weak var viewController: UIViewController?
}

// MARK: - HomepageRouterProtocol

extension HomepageRouter: HomepageRouterProtocol {
    func navigateToDetail(cleanerID: Int) {
        let detailVC = UserDetailBuilder.createModule(with: cleanerID)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }

    func navigateToServiceCleaners(service: CleaningService) {
        let listVC = ServiceCleanersBuilder.createModule(service: service)
        viewController?.navigationController?.pushViewController(listVC, animated: true)
    }

    func navigateToSearch() {
        let searchVC = SearchBuilder.createModule()
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
