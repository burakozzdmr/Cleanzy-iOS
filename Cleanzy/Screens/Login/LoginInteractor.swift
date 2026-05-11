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
    private let authService: AuthServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
}

// MARK: - LoginInteractorInputProtocol

extension LoginInteractor: LoginInteractorInputProtocol {
    func sendLoginRequest(with email: String, and password: String, as userTypeIndex: Int) {
        let request = LoginRequestModel(email: email, password: password)

        authService.login(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didLoginFailure(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                KeychainManager.shared.saveAccessToken(response.data.accessToken)
                self?.presenter?.didLoginSuccess()
            }
            .store(in: &cancellables)
    }
}
