//
//  ChatBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import UIKit

// MARK: - ChatBuilder

final class ChatBuilder { }

// MARK: - ChatBuilderProtocol

extension ChatBuilder: ChatBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = ChatViewController()
        let interactor = ChatInteractor()
        let presenter = ChatPresenter()
        let router = ChatRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        router.viewController = view

        return view
    }
}
