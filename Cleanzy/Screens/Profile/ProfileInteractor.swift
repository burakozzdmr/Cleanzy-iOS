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
    private var cancellables: Set<AnyCancellable> = .init()

    init(profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
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

        let request = GetProfileRequestModel(userId: userId)

        profileService.getProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingUserInfo(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                let data = response.data
                let name = data.fullName ?? KeychainManager.shared.userName ?? "Kullanıcı"
                let role = data.role ?? KeychainManager.shared.userRole ?? "CUSTOMER"
                let memberType = role == "CLEANER" ? "Temizlikçi" : "Standart Üye"
                self?.presenter?.didFetchUserInfo(name: name, memberType: memberType)
            }
            .store(in: &cancellables)
    }
}
