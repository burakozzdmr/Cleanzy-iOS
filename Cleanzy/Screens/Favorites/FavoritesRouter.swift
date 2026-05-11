//
//  FavoritesRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import UIKit

// MARK: - FavoritesRouter

final class FavoritesRouter {
    weak var presenter: FavoritesPresenterProtocol?
    weak var viewController: UIViewController?
}

// MARK: - FavoritesRouterProtocol

extension FavoritesRouter: FavoritesRouterProtocol {
    func navigateToDetail(cleanerID: Int) {
        let detailVC = UserDetailBuilder.createModule(with: cleanerID)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
