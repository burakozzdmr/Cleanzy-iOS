//
//  HomepageBuilder.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import UIKit

// MARK: - HomepageBuilder

final class HomepageBuilder { }

// MARK: - HomepageBuilderProtocol

extension HomepageBuilder: HomepageBuilderProtocol {
    static func createModule() -> UIViewController {
        let view = HomepageViewController()
        let presenter = HomepagePresenter()
        let interactor = HomepageInteractor()
        let router = HomepageRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return view
    }
}
