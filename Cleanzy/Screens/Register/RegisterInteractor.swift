//
//  RegisterInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import Combine
import Foundation

// MARK: - RegisterInteractor

final class RegisterInteractor {
    weak var presenter: RegisterInteractorOutputProtocol?
    private let authService: AuthServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
    }
}

// MARK: - RegisterInteractorInputProtocol

extension RegisterInteractor: RegisterInteractorInputProtocol {
    func sendRegisterRequest(fullName: String, email: String, password: String, role: String) {
        let request = RegisterRequestModel(fullName: fullName, email: email, password: password, role: role)

        authService.register(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didRegisterFailure(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                let data = response.data
                KeychainManager.shared.saveAccessToken(data.accessToken)
                if let userId   = data.userId   { KeychainManager.shared.saveUserId(userId) }
                if let name     = data.fullName  { KeychainManager.shared.saveUserName(name) }
                if let email    = data.email     { KeychainManager.shared.saveUserEmail(email) }
                if let role     = data.role      { KeychainManager.shared.saveUserRole(role) }
                self?.presenter?.didRegisterSuccess()
            }
            .store(in: &cancellables)
    }
}
