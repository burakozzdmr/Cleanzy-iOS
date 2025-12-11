//
//  ChatPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import Foundation

// MARK: - ChatPresenter

final class ChatPresenter {
    weak var view: ChatViewProtocol?
    var interactor: ChatInteractorInputProtocol?
    var router: ChatRouterProtocol?
}

// MARK: - ChatPresenterProtocol

extension ChatPresenter: ChatPresenterProtocol {
    
}

// MARK: - ChatInteractorOutputProtocol

extension ChatPresenter: ChatInteractorOutputProtocol {
    
}
