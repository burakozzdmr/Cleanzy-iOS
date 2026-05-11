//
//  SearchInteractor.swift
//  Cleanzy
//

import Combine
import Foundation

final class SearchInteractor {
    weak var presenter: SearchInteractorOutputProtocol?
    private let cleanersService: CleanersServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(cleanersService: CleanersServiceProtocol = CleanersService()) {
        self.cleanersService = cleanersService
    }
}

extension SearchInteractor: SearchInteractorInputProtocol {
    func fetchAllCleaners() {
        cleanersService.getCleanerList(request: GetCleanerListRequestModel())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetching(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                self?.presenter?.didFetchCleaners(response.data)
            }
            .store(in: &cancellables)
    }
}
