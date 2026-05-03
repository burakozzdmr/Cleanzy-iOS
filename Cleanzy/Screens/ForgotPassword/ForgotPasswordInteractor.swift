//
//  ForgotPasswordInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import Combine
import Foundation

// MARK: - ForgotPasswordInteractor

final class ForgotPasswordInteractor {
    weak var presenter: ForgotPasswordInteractorOutputProtocol?
    private var cancellables: Set<AnyCancellable> = .init()
}

// MARK: - ForgotPasswordInteractorInputProtocol

extension ForgotPasswordInteractor: ForgotPasswordInteractorInputProtocol {
    func sendCodeRequest(for emailText: String) {

    }
}
