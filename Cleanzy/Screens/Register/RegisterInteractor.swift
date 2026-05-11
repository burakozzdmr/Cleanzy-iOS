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
                KeychainManager.shared.saveUserId(data.userId)
                KeychainManager.shared.saveUserName(data.fullName)
                KeychainManager.shared.saveUserEmail(data.email)
                KeychainManager.shared.saveUserRole(data.role)
                self?.presenter?.didRegisterSuccess()
            }
            .store(in: &cancellables)
    }
}
