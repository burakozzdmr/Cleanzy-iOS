//
//  EditProfileInteractor.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - EditProfileInteractor

final class EditProfileInteractor {
    weak var presenter: EditProfileInteractorOutputProtocol?
    private let profileService: ProfileServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
    }
}

// MARK: - EditProfileInteractorInputProtocol

extension EditProfileInteractor: EditProfileInteractorInputProtocol {
    func saveProfile(name: String, email: String, location: String) {
        guard let userId = KeychainManager.shared.userId else {
            presenter?.didSaveProfileFailure(with: "Oturum bilgisi bulunamadı.")
            return
        }

        let request = UpdateProfileRequestModel(userId: userId, fullName: name, email: email, currentLocation: location)

        profileService.updateProfile(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didSaveProfileFailure(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                KeychainManager.shared.saveUserName(response.data.fullName ?? name)
                self?.presenter?.didSaveProfileSuccess()
            }
            .store(in: &cancellables)
    }
}
