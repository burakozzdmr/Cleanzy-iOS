//
//  AppointmentsInteractor.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - AppointmentsInteractor

final class AppointmentsInteractor {
    weak var presenter: AppointmentsInteractorOutputProtocol?
    private let jobsService: JobsServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(jobsService: JobsServiceProtocol = JobsService()) {
        self.jobsService = jobsService
    }
}

// MARK: - AppointmentsInteractorInputProtocol

extension AppointmentsInteractor: AppointmentsInteractorInputProtocol {
    func fetchMyAppointments() {
        jobsService.getMyJobs(request: GetMyJobsRequestModel())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingAppointments(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                let items = response.data.map { AppointmentItem(from: $0) }
                self?.presenter?.didFetchAppointments(items)
            }
            .store(in: &cancellables)
    }
}
