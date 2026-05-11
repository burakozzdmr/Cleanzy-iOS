//
//  FavoritesInteractor.swift
//  Cleanzy
//

import Combine
import Foundation

// MARK: - FavoritesInteractor

final class FavoritesInteractor {
    var presenter: FavoritesInteractorOutputProtocol?
    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - FavoritesInteractorInputProtocol

extension FavoritesInteractor: FavoritesInteractorInputProtocol {
    func fetchFavorites() {
        FavoritesManager.shared.fetchFavorites()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.presenter?.didFetchFavorites([])
                }
            } receiveValue: { [weak self] items in
                self?.presenter?.didFetchFavorites(items)
            }
            .store(in: &cancellables)
    }
}
