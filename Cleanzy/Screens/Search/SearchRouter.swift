//
//  SearchRouter.swift
//  Cleanzy
//

import UIKit

final class SearchRouter {
    weak var viewController: UIViewController?
    weak var presenter: SearchPresenterProtocol?
}

extension SearchRouter: SearchRouterProtocol {
    func navigateToDetail(cleanerID: Int) {
        let detailVC = UserDetailBuilder.createModule(with: cleanerID)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
