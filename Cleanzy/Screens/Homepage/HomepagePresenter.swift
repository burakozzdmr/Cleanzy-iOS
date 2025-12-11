//
//  HomepagePresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import Foundation

// MARK: - HomepagePresenter

final class HomepagePresenter {
    weak var view: HomepageViewProtocol?
    var interactor: HomepageInteractorInputProtocol?
    var router: HomepageRouterProtocol?
}

// MARK: - HomepagePresenterProtocol

extension HomepagePresenter: HomepagePresenterProtocol {
    
}

// MARK: - HomepageInteractorOutputProtocol

extension HomepagePresenter: HomepageInteractorOutputProtocol {
    
}
