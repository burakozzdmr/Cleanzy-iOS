//
//  LoginInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import Combine
import Foundation

// MARK: - LoginInteractor

final class LoginInteractor {
    weak var presenter: LoginInteractorOutputProtocol?
    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - LoginInteractorInputProtocol

extension LoginInteractor: LoginInteractorInputProtocol {
    func sendLoginRequest(with email: String, and password: String, as userTypeIndex: Int) {
        
    }
}
