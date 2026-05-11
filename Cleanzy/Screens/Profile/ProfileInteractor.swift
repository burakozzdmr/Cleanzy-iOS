//
//  ProfileInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - ProfileInteractor

final class ProfileInteractor {
    weak var presenter: ProfileInteractorOutputProtocol?
}

// MARK: - ProfileInteractorInputProtocol

extension ProfileInteractor: ProfileInteractorInputProtocol {
    func fetchUserInfo() {
        let name = KeychainManager.shared.userName ?? "Kullanıcı"
        presenter?.didFetchUserInfo(name: name, memberType: "Standart Üye")
    }
}
