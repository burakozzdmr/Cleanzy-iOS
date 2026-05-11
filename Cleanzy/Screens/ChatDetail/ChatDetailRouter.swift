//
//  ChatDetailRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import UIKit

// MARK: - ChatDetailRouter

final class ChatDetailRouter {
    weak var presenter: ChatDetailPresenterProtocol?
    weak var viewController: UIViewController?
}

// MARK: - ChatDetailRouterProtocol

extension ChatDetailRouter: ChatDetailRouterProtocol {
    func navigateBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
