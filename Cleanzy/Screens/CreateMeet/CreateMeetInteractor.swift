//
//  CreateMeetInteractor.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import Foundation

// MARK: - CreateMeetInteractor

final class CreateMeetInteractor {
    weak var presenter: CreateMeetInteractorOutputProtocol?
}

// MARK: - CreateMeetInteractorInputProtocol

extension CreateMeetInteractor: CreateMeetInteractorInputProtocol { }
