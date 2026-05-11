//
//  CreateMeetContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - CreateMeetViewProtocol

protocol CreateMeetViewProtocol: BaseViewProtocol, AnyObject {
    var presenter: CreateMeetPresenterProtocol! { get set }

    func updateTotalPrice(_ formatted: String)
    func reloadExtraServices(_ items: [ExtraServiceItem])
}

// MARK: - CreateMeetInteractorInputProtocol

protocol CreateMeetInteractorInputProtocol: BaseInteractorInputProtocol, AnyObject {
    var presenter: CreateMeetInteractorOutputProtocol? { get set }

    func createJob(request: AddJobRequestModel)
}

// MARK: - CreateMeetInteractorOutputProtocol

protocol CreateMeetInteractorOutputProtocol: BaseInteractorOutputProtocol, AnyObject {
    func didCreateJobSuccess(_ job: JobResponseModel)
    func didCreateJobFailure(with message: String)
}

// MARK: - CreateMeetPresenterProtocol

protocol CreateMeetPresenterProtocol: BasePresenterProtocol, AnyObject {
    var view: CreateMeetViewProtocol? { get set }
    var interactor: CreateMeetInteractorInputProtocol? { get set }
    var router: CreateMeetRouterProtocol? { get set }

    func didSelectDate(_ date: Date)
    func didSelectTime(_ time: String)
    func didSelectHouseSize(_ size: HouseSize)
    func didToggleExtraService(at index: Int)
    func didChangeAddress(_ address: String)
    func didTapConfirm()
    func didTapBack()
}

// MARK: - CreateMeetRouterProtocol

protocol CreateMeetRouterProtocol: BaseRouterProtocol, AnyObject {
    var presenter: CreateMeetPresenterProtocol? { get set }

    func navigateBack()
    func navigateToConfirmation(with item: AppointmentConfirmItem)
}

// MARK: - CreateMeetBuilderProtocol

protocol CreateMeetBuilderProtocol: AnyObject {
    static func createModule(cleanerID: Int, hourlyRate: Double) -> CreateMeetViewController
}
