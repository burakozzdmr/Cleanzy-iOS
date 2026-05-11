//
//  PaymentMethodsRouter.swift
//  Cleanzy
//

import UIKit

// MARK: - PaymentMethodsRouter

final class PaymentMethodsRouter {
    weak var viewController: UIViewController?
    weak var presenter: PaymentMethodsPresenterProtocol?
}

// MARK: - PaymentMethodsRouterProtocol

extension PaymentMethodsRouter: PaymentMethodsRouterProtocol {
    func presentAddCard(completion: @escaping (PaymentCardItem) -> Void) {
        guard let vc = viewController else { return }
        let addVC = AddCardViewController(completion: completion)
        let nav   = UINavigationController(rootViewController: addVC)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        vc.present(nav, animated: true)
    }
}
