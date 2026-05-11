//
//  BaseContracts.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 8.11.2025.
//

import UIKit

// MARK: - Protocols

protocol BaseViewProtocol: UIViewController {
    func showLoading()
    func hideLoading()
    func showAlert(with alertModel: AlertModel)
}

protocol BaseInteractorInputProtocol: AnyObject {
    
}

protocol BaseInteractorOutputProtocol: AnyObject {
    
}

protocol BasePresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func viewDidAppear()
    func viewDidDisappear()
}

protocol BaseRouterProtocol: AnyObject {
    func push(currentViewController: UIViewController, targetViewController: UIViewController, animated: Bool)
    func pop(_ viewController: UIViewController, animated: Bool)
    func popToRoot(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
}

protocol BaseBuilderProtocol: AnyObject {
    static func createModule() -> UIViewController
}

// MARK: - Extensions

extension BasePresenterProtocol {
    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewWillDisappear() { }
    func viewDidAppear() { }
    func viewDidDisappear() { }
}

extension BaseRouterProtocol {
    func push(currentViewController: UIViewController, targetViewController: UIViewController, animated: Bool) {
        currentViewController.navigationController?.pushViewController(targetViewController, animated: animated)
    }
    
    func pop(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popViewController(animated: animated)
    }
    
    func popToRoot(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationController?.popToRootViewController(animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) { }
    
    func dismiss(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        viewController.dismiss(animated: animated, completion: completion)
    }
}

extension BaseViewProtocol {
    func showLoading() { }
    func hideLoading() { }
    func showAlert(with alertModel: AlertModel) { }
}
