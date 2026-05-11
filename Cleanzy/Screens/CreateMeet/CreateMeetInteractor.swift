//
//  CreateMeetInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - CreateMeetInteractor

final class CreateMeetInteractor {
    weak var presenter: CreateMeetInteractorOutputProtocol?
    private let jobsService: JobsServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(jobsService: JobsServiceProtocol = JobsService()) {
        self.jobsService = jobsService
    }
}

// MARK: - CreateMeetInteractorInputProtocol

extension CreateMeetInteractor: CreateMeetInteractorInputProtocol {
    func createJob(request: AddJobRequestModel) {
        jobsService.addJob(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didCreateJobFailure(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                self?.presenter?.didCreateJobSuccess(response.data)
            }
            .store(in: &cancellables)
    }
}
