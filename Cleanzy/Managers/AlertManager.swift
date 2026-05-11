//
//  AlertManager.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 10.11.2025.
//

import UIKit

// MARK: - AlertManager

final class AlertManager {
    static let shared = AlertManager()
    
    private init() { }
}

// MARK: - Publics

extension AlertManager {
    func showAlert(with alertModel: AlertModel, from viewController: UIViewController) {
        let alertController = UIAlertController(title: alertModel.title, message: alertModel.message, preferredStyle: .alert)
        alertModel.actions.forEach { alertController.addAction($0) }
        
        viewController.present(alertController, animated: true)
    }
}
