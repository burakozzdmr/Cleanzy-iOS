//
//  JobsService.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - JobsServiceProtocol

protocol JobsServiceProtocol {
    func getAllJobs(request: GetAllJobsRequestModel) -> AnyPublisher<JobListSuccessResponse, NetworkError>
    func getJobByID(request: GetJobByIDRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError>
    func addJob(request: AddJobRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError>
    func updateJob(request: UpdateJobRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError>
    func deleteJob(request: DeleteJobRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError>
}

// MARK: - JobsService

final class JobsService: JobsServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension JobsService {
    func getAllJobs(request: GetAllJobsRequestModel) -> AnyPublisher<JobListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: JobListSuccessResponse.self)
    }

    func getJobByID(request: GetJobByIDRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: JobSuccessResponse.self)
    }

    func addJob(request: AddJobRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: JobSuccessResponse.self)
    }

    func updateJob(request: UpdateJobRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: JobSuccessResponse.self)
    }

    func deleteJob(request: DeleteJobRequestModel) -> AnyPublisher<JobSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: JobSuccessResponse.self)
    }
}
