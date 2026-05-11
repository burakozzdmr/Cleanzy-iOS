//
//  ServiceCleanersInteractor.swift
//  Cleanzy
//

import Combine
import Foundation

final class ServiceCleanersInteractor {
    weak var presenter: ServiceCleanersInteractorOutputProtocol?
    private let cleanersService: CleanersServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(cleanersService: CleanersServiceProtocol = CleanersService()) {
        self.cleanersService = cleanersService
    }
}

extension ServiceCleanersInteractor: ServiceCleanersInteractorInputProtocol {
    func fetchCleaners(for service: CleaningService) {
        cleanersService.getCleanerList(request: GetCleanerListRequestModel())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingCleaners(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                // Client-side filter by service
                let filtered = response.data.filter { cleaner in
                    cleaner.services?.contains(service) ?? false
                }
                self?.presenter?.didFetchCleaners(filtered)
            }
            .store(in: &cancellables)
    }
}
