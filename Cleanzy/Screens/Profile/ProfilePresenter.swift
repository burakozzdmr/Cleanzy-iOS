//
//  ProfilePresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - ProfilePresenter

final class ProfilePresenter {
    var view: ProfileViewProtocol?
    var interactor: ProfileInteractorInputProtocol?
    var router: ProfileRouterProtocol?
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    
}

// MARK: - ProfileInteractorOutputProtocol

extension ProfilePresenter: profileInteractorOutputProtocol {
    
}
