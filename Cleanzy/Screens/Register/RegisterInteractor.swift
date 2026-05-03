//
//  RegisterInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import Combine
import Foundation

// MARK: - RegisterInteractor

final class RegisterInteractor {
    weak var presenter: RegisterInteractorOutputProtocol?
    private var cancellables: Set<AnyCancellable> = .init()
    
}

// MARK: - RegisterInteractorInputProtocol

extension RegisterInteractor: RegisterInteractorInputProtocol {
    func sendRegisterRequest(with email: String, and password: String, as userTypeIndex: Int) {
        
    }
}
