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
        let expectedRole = userTypeIndex == 0 ? "CUSTOMER" : "CLEANER"
        let request = LoginRequestModel(email: email, password: password)

        authService.login(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didLoginFailure(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                let data = response.data

                // Rol uyuşmazlığı kontrolü
                if let returnedRole = data.role, returnedRole != expectedRole {
                    let expected = expectedRole == "CUSTOMER" ? "Müşteri" : "Temizlikçi"
                    self?.presenter?.didLoginFailure(
                        with: "Bu hesap \(expected) olarak kayıtlı değil. Lütfen doğru hesap türünü seçin."
                    )
                    return
                }

                KeychainManager.shared.saveAccessToken(data.accessToken)
                if let userId = data.userId  { KeychainManager.shared.saveUserId(userId) }
                if let name   = data.fullName { KeychainManager.shared.saveUserName(name) }
                if let email  = data.email    { KeychainManager.shared.saveUserEmail(email) }
                if let role   = data.role     { KeychainManager.shared.saveUserRole(role) }
                self?.presenter?.didLoginSuccess()
            }
            .store(in: &cancellables)
    }
}
