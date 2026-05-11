//
//  EditProfilePresenter.swift
//  Cleanzy
//

import Foundation

// MARK: - EditProfilePresenter

final class EditProfilePresenter {
    weak var view: EditProfileViewProtocol?
    var interactor: EditProfileInteractorInputProtocol?
    var router: EditProfileRouterProtocol?
}

// MARK: - EditProfilePresenterProtocol

extension EditProfilePresenter: EditProfilePresenterProtocol {
    func viewDidLoad() {
        let name     = KeychainManager.shared.userName ?? ""
        let email    = KeychainManager.shared.userEmail ?? ""
        view?.populateFields(name: name, email: email, location: "")
    }

    func didTapSave(name: String, email: String, location: String) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            view?.showAlert(with: .init(title: "Uyarı", message: "Ad Soyad alanı boş bırakılamaz."))
            return
        }
        view?.showLoading()
        interactor?.saveProfile(name: name, email: email, location: location)
    }

    func didTapBack() {
        router?.navigateBack()
    }
}

// MARK: - EditProfileInteractorOutputProtocol

extension EditProfilePresenter: EditProfileInteractorOutputProtocol {
    func didSaveProfileSuccess() {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Başarılı", message: "Profil bilgileriniz güncellendi."))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.router?.navigateBack()
        }
    }

    func didSaveProfileFailure(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}
