//
//  CustomersService.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - CustomersServiceProtocol

protocol CustomersServiceProtocol {
    func getCustomerList(request: GetCustomerListRequestModel) -> AnyPublisher<CustomerListSuccessResponse, NetworkError>
    func getCustomerByID(request: GetCustomerByIDRequestModel) -> AnyPublisher<CustomerSuccessResponse, NetworkError>
}

// MARK: - CustomersService

final class CustomersService: CustomersServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
}

// MARK: - Methods

extension CustomersService {
    func getCustomerList(request: GetCustomerListRequestModel) -> AnyPublisher<CustomerListSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: CustomerListSuccessResponse.self)
    }

    func getCustomerByID(request: GetCustomerByIDRequestModel) -> AnyPublisher<CustomerSuccessResponse, NetworkError> {
        networkManager.executeRequest(with: request, as: CustomerSuccessResponse.self)
    }
}
