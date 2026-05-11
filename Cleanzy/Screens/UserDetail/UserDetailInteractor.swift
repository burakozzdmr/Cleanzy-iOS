//
//  UserDetailInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Combine
import Foundation

// MARK: - UserDetailInteractor

final class UserDetailInteractor {
    weak var presenter: UserDetailInteractorOutputProtocol?
    private let cleanersService: CleanersServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    init(cleanersService: CleanersServiceProtocol = CleanersService()) {
        self.cleanersService = cleanersService
    }
}

// MARK: - UserDetailInteractorInputProtocol

extension UserDetailInteractor: UserDetailInteractorInputProtocol {
    func fetchCleanerDetail(cleanerID: Int) {
        cleanersService.getCleanerByID(request: GetCleanerByIDRequestModel(cleanerID: cleanerID))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.presenter?.didFailFetchingDetail(with: error.networkErrorMessage)
                }
            } receiveValue: { [weak self] response in
                self?.presenter?.didFetchCleanerDetail(response.data)
            }
            .store(in: &cancellables)
    }
}
