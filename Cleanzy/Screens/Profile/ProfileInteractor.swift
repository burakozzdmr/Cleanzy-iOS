//
//  ProfileInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Combine
import Foundation

// MARK: - ProfileInteractor

final class ProfileInteractor {
    weak var presenter: ProfileInteractorOutputProtocol?
    private let profileService: ProfileServiceProtocol
    private let authService: AuthServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(
        profileService: ProfileServiceProtocol = ProfileService(),
        authService: AuthServiceProtocol = AuthService()
    ) {
        self.profileService = profileService
        self.authService    = authService
    }
}

// MARK: - ProfileInteractorInputProtocol

extension ProfileInteractor: ProfileInteractorInputProtocol {
    func fetchUserInfo() {
        guard let userId = KeychainManager.shared.userId else {
            let fallbackName = KeychainManager.shared.userName ?? "Kullanıcı"
            presenter?.didFetchUserInfo(name: fallbackName, memberType: "Standart Üye")
            return
        }

        profileService.getProfile(request: GetProfileRequestModel(userId: userId))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingUserInfo(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                let d          = response.data
                let name       = d.fullName ?? KeychainManager.shared.userName ?? "Kullanıcı"
                let role       = d.role ?? KeychainManager.shared.userRole ?? "CUSTOMER"
                let memberType = role == "CLEANER" ? "Temizlikçi" : "Standart Üye"
                if let n = d.fullName { KeychainManager.shared.saveUserName(n) }
                if let e = d.email    { KeychainManager.shared.saveUserEmail(e) }
                if let r = d.role     { KeychainManager.shared.saveUserRole(r) }
                self?.presenter?.didFetchUserInfo(name: name, memberType: memberType)
            }
            .store(in: &cancellables)
    }

    func logout() {
        authService.logout(request: LogoutRequestModel())
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                KeychainManager.shared.clearSession()
                self?.presenter?.didLogoutSuccess()
            }
            .store(in: &cancellables)
    }
}
