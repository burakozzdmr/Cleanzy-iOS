//
//  ChatRouter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import UIKit

// MARK: - ChatRouter

final class ChatRouter {
    weak var presenter: ChatPresenterProtocol?
    weak var viewController: UIViewController?
}

// MARK: - ChatRouterProtocol

extension ChatRouter: ChatRouterProtocol {
    func navigateToChatDetail(with item: ChatItem) {
        let detailVC = ChatDetailBuilder.createModule(with: item)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
