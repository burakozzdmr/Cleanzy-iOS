//
//  ChatInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import Foundation

// MARK: - ChatInteractor

final class ChatInteractor {
    weak var presenter: ChatInteractorOutputProtocol?
}

// MARK: - ChatInteractorInputProtocol

extension ChatInteractor: ChatInteractorInputProtocol {
    
}
