//
//  SendCodeBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 14.11.2025.
//

import UIKit

final class SendCodeBuilder { }

// MARK: - SendCodeBuilderProtocol

extension SendCodeBuilder: SendCodeBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = SendCodeViewController()
        let interactor = SendCodeInteractor()
        let presenter = SendCodePresenter()
        let router = SendCodeRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}
