//
//  SplashInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 7.11.2025.
//

import Combine
import Foundation

// MARK: - SplashInteractor

final class SplashInteractor {
    weak var presenter: SplashInteractorOutputProtocol?

    private let profileService: ProfileServiceProtocol
    private var cancellables: Set<AnyCancellable> = .init()

    /// Splash animasyonunun görünmesi için minimum bekleme süresi (saniye)
    private let minimumDisplayDuration: TimeInterval = 1.5

    init(profileService: ProfileServiceProtocol = ProfileService()) {
        self.profileService = profileService
    }
}

// MARK: - SplashInteractorInputProtocol

extension SplashInteractor: SplashInteractorInputProtocol {

    func checkAuthStatus() {
        guard let token = KeychainManager.shared.accessToken, !token.isEmpty else {
            // Token hiç yok → belirli süre bekle → Login
            scheduleFailure()
            return
        }

        guard let userId = KeychainManager.shared.userId else {
            // Token var ama userId kaydedilmemiş → belirli süre bekle → Home (optimistic)
            scheduleSuccess()
            return
        }

        // Token + userId var → backend'e sorarak doğrula.
        // minDelay ile network isteğini zip'le; ikisi de bitince karar ver.
        let minDelay = Timer.publish(every: minimumDisplayDuration, on: .main, in: .common)
            .autoconnect()
            .first()
            .map { _ in () }
            .eraseToAnyPublisher()

        let validation = profileService
            .getProfile(request: GetProfileRequestModel(userId: userId))
            .map { _ in true }
            .catch { [weak self] error -> AnyPublisher<Bool, Never> in
                // 401/403 → token geçersiz, oturumu temizle
                switch error {
                case .unauthorized, .forbidden:
                    KeychainManager.shared.clearSession()
                    return Just(false).eraseToAnyPublisher()
                default:
                    // Offline / sunucu hatası → token'ı silme, iyimser geç
                    return Just(true).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()

        Publishers.Zip(minDelay, validation)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, isValid in
                if isValid {
                    self?.presenter?.didPassAuthCheck()
                } else {
                    self?.presenter?.didFailAuthCheck()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers

private extension SplashInteractor {
    func scheduleSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + minimumDisplayDuration) { [weak self] in
            self?.presenter?.didPassAuthCheck()
        }
    }

    func scheduleFailure() {
        DispatchQueue.main.asyncAfter(deadline: .now() + minimumDisplayDuration) { [weak self] in
            self?.presenter?.didFailAuthCheck()
        }
    }
}
