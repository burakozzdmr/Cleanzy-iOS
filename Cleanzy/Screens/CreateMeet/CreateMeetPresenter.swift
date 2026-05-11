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

    func didToggleExtraService(at index: Int) {
        extraServices[index].isEnabled.toggle()
        view?.reloadExtraServices(extraServices)
        recalculatePrice()
    }

    func didTapConfirm() {
        view?.showLoading()
        // Randevu API endpoint hazır olduğunda burası interactor'a taşınacak.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            self.view?.hideLoading()
            let item = AppointmentConfirmItem.build(
                houseSize: selectedHouseSize,
                date: selectedDate,
                timeSlot: selectedTime
            )
            self.router?.navigateToConfirmation(with: item)
        }
    }

    func didTapBack() {
        router?.navigateBack()
    }
}

// MARK: - CreateMeetInteractorOutputProtocol

extension CreateMeetPresenter: CreateMeetInteractorOutputProtocol { }

// MARK: - Private

private extension CreateMeetPresenter {
    func recalculatePrice() {
        let base = hourlyRate * selectedHouseSize.priceMultiplier
        let extras = extraServices.filter(\.isEnabled).reduce(0) { $0 + $1.price }
        let total = Int(base) + extras
        view?.updateTotalPrice("₺\(total)")
    }
}
