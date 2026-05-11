//
//  ChatDetailBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.05.2026.
//

import UIKit

// MARK: - ChatDetailBuilder

final class ChatDetailBuilder { }

// MARK: - ChatDetailBuilderProtocol

extension ChatDetailBuilder: ChatDetailBuilderProtocol {
    static func createModule(with item: ChatItem) -> ChatDetailViewController {
        let view = ChatDetailViewController()
        let interactor = ChatDetailInteractor()
        let presenter = ChatDetailPresenter(chatItem: item)
        let router = ChatDetailRouter()

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
