//
//  CreateMeetPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - CreateMeetPresenter

final class CreateMeetPresenter {
    weak var view: CreateMeetViewProtocol?
    var interactor: CreateMeetInteractorInputProtocol?
    var router: CreateMeetRouterProtocol?

    private let cleanerID: Int
    private let hourlyRate: Double

    private var selectedDate: Date?
    private var selectedTime: String?
    private var selectedHouseSize: HouseSize = .medium
    private var extraServices: [ExtraServiceItem] = ExtraServiceItem.defaultList
    private var address: String = ""

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    init(cleanerID: Int, hourlyRate: Double) {
        self.cleanerID = cleanerID
        self.hourlyRate = hourlyRate
    }
}

// MARK: - CreateMeetPresenterProtocol

extension CreateMeetPresenter: CreateMeetPresenterProtocol {
    func viewDidLoad() {
        view?.reloadExtraServices(extraServices)
        recalculatePrice()
    }

    func didSelectDate(_ date: Date) {
        selectedDate = date
    }

    func didSelectTime(_ time: String) {
        selectedTime = time
    }

    func didSelectHouseSize(_ size: HouseSize) {
        selectedHouseSize = size
        recalculatePrice()
    }

    func didChangeAddress(_ address: String) {
        self.address = address
    }

    func didToggleExtraService(at index: Int) {
        extraServices[index].isEnabled.toggle()
        view?.reloadExtraServices(extraServices)
        recalculatePrice()
    }

    func didTapConfirm() {
        guard let customerID = KeychainManager.shared.userId else {
            view?.showAlert(with: .init(title: "Hata", message: "Oturum bilgisi bulunamadı."))
            return
        }

        let scheduledDate = selectedDate.map { dateFormatter.string(from: $0) } ?? ""
        let scheduledTime = selectedTime ?? ""

        guard !scheduledDate.isEmpty, !scheduledTime.isEmpty else {
            view?.showAlert(with: .init(title: "Uyarı", message: "Lütfen tarih ve saat seçiniz."))
            return
        }

        guard !address.trimmingCharacters(in: .whitespaces).isEmpty else {
            view?.showAlert(with: .init(title: "Uyarı", message: "Lütfen adresinizi giriniz."))
            return
        }

        let enabledExtras = extraServices
            .filter(\.isEnabled)
            .map { $0.title.uppercased().replacingOccurrences(of: " ", with: "_") }

        let request = AddJobRequestModel(
            cleanerID: cleanerID,
            customerID: customerID,
            address: address,
            scheduledDate: scheduledDate,
            scheduledTime: scheduledTime,
            houseSize: selectedHouseSize.rawValue.uppercased().replacingOccurrences(of: "+", with: "_"),
            extraServices: enabledExtras
        )

        view?.showLoading()
        interactor?.createJob(request: request)
    }

    func didTapBack() {
        router?.navigateBack()
    }
}

// MARK: - CreateMeetInteractorOutputProtocol

extension CreateMeetPresenter: CreateMeetInteractorOutputProtocol {
    func didCreateJobSuccess(_ job: JobResponseModel) {
        view?.hideLoading()
        let item = AppointmentConfirmItem.build(
            houseSize: selectedHouseSize,
            date: selectedDate,
            timeSlot: selectedTime
        )
        router?.navigateToConfirmation(with: item)
    }

    func didCreateJobFailure(with message: String) {
        view?.hideLoading()
        view?.showAlert(with: .init(title: "Hata", message: message))
    }
}

// MARK: - Private

private extension CreateMeetPresenter {
    func recalculatePrice() {
        let base   = hourlyRate * selectedHouseSize.priceMultiplier
        let extras = extraServices.filter(\.isEnabled).reduce(0) { $0 + $1.price }
        view?.updateTotalPrice("₺\(Int(base) + extras)")
    }
}
