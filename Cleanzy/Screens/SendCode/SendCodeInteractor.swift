//
//  SendCodeInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 14.11.2025.
//

import Foundation

// MARK: - SendCodeInteractor

final class SendCodeInteractor {
    weak var presenter: SendCodeInteractorOutputProtocol?
}

// MARK: - SendCodeInteractorInputProtocol

extension SendCodeInteractor: SendCodeInteractorInputProtocol { }
