//
//  PrepareContentPresenter.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 13.11.2025.
//

import Foundation

// MARK: - PrepareContentPresenter

final class PrepareContentPresenter {
    weak var view: PrepareContentViewProtocol?
    var interactor: PrepareContentInteractorInputProtocol?
    var router: PrepareContentRouterProtocol?
    
    private var progressTimer: Timer?
    private var currentProgress: Float = 0.0
    private let progressIncrement: Float = 0.1
    private let totalDuration: TimeInterval = 10.0
    private let updateInterval: TimeInterval = 1.0
}

// MARK: - PrepareContentPresenterProtocol

extension PrepareContentPresenter: PrepareContentPresenterProtocol {
    func viewDidLoad() {
        startProgressAnimation()
    }
    
    func didFinishPreparedContent() {
        progressTimer?.invalidate()
        progressTimer = nil
        router?.prepareContentToHomeScreen()
    }
}

// MARK: - Privates

private extension PrepareContentPresenter {
    func startProgressAnimation() {
        currentProgress = 0.0
        view?.updateProgress(currentProgress)
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            self.currentProgress += self.progressIncrement
            
            if self.currentProgress >= 1.0 {
                self.currentProgress = 1.0
                self.view?.updateProgress(self.currentProgress)
                self.didFinishPreparedContent()
            } else {
                self.view?.updateProgress(self.currentProgress)
            }
        }
    }
}

// MARK: - PrepareContentInteractorOutputProtocol

extension PrepareContentPresenter: PrepareContentInteractorOutputProtocol { }
