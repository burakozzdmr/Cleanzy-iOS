//
//  ProfilePresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import Foundation

// MARK: - ProfilePresenter

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorInputProtocol?
    var router: ProfileRouterProtocol?
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchUserInfo()
    }

    func didTapRow(_ row: ProfileRow) {
        switch row {
        case .editProfile:
            router?.navigateToEditProfile()
        case .paymentMethods:
            router?.navigateToPaymentMethods()
        case .logout:
            KeychainManager.shared.clearSession()
            router?.navigateToLogin()
        default:
            break
        }
    }
}

// MARK: - ProfileInteractorOutputProtocol

extension ProfilePresenter: ProfileInteractorOutputProtocol {
    func didFetchUserInfo(name: String, memberType: String) {
        view?.hideLoading()
        view?.displayUserInfo(name: name, memberType: memberType)
    }

    func didFailFetchingUserInfo(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
