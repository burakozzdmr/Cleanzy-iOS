//
//  CreateMeetBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 4.05.2026.
//

import UIKit

// MARK: - CreateMeetBuilder

final class CreateMeetBuilder { }

// MARK: - CreateMeetBuilderProtocol

extension CreateMeetBuilder: CreateMeetBuilderProtocol {
    static func createModule(cleanerID: Int, hourlyRate: Double) -> CreateMeetViewController {
        let view = CreateMeetViewController()
        let presenter = CreateMeetPresenter(cleanerID: cleanerID, hourlyRate: hourlyRate)
        let interactor = CreateMeetInteractor()
        let router = CreateMeetRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter

        return view
    }
}
