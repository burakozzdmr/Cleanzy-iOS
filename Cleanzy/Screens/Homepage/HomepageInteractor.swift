//
//  HomepageInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import Combine
import Foundation

// MARK: - HomepageInteractor

final class HomepageInteractor {
    weak var presenter: HomepageInteractorOutputProtocol?
    private let cleanersService: CleanersServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(cleanersService: CleanersServiceProtocol = CleanersService()) {
        self.cleanersService = cleanersService
    }
}

// MARK: - HomepageInteractorInputProtocol

extension HomepageInteractor: HomepageInteractorInputProtocol {
    func fetchCleaners() {
        cleanersService.getCleanerList(request: GetCleanerListRequestModel())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingCleaners(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                self?.presenter?.didFetchCleaners(response.data)
            }
            .store(in: &cancellables)
    }
}
