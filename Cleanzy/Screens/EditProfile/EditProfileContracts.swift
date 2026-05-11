//
//  EditProfileContracts.swift
//  Cleanzy
//

import Foundation

// MARK: - EditProfileViewProtocol

protocol EditProfileViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: EditProfilePresenterProtocol! { get set }

    func populateFields(name: String, email: String, location: String)
}

// MARK: - EditProfileInteractorInputProtocol

protocol EditProfileInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: EditProfileInteractorOutputProtocol? { get set }

    func saveProfile(name: String, email: String, location: String)
}

// MARK: - EditProfileInteractorOutputProtocol

protocol EditProfileInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didSaveProfileSuccess()
    func didSaveProfileFailure(with message: String)
}

// MARK: - EditProfilePresenterProtocol

protocol EditProfilePresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: EditProfileViewProtocol? { get set }
    var interactor: EditProfileInteractorInputProtocol? { get set }
    var router: EditProfileRouterProtocol? { get set }

    func didTapSave(name: String, email: String, location: String)
    func didTapBack()
}

// MARK: - EditProfileRouterProtocol

protocol EditProfileRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: EditProfilePresenterProtocol? { get set }

    func navigateBack()
}

// MARK: - EditProfileBuilderProtocol

protocol EditProfileBuilderProtocol: AnyObject {
    static func createModule() -> EditProfileViewController
}
