//
//  FavoritesViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import SnapKit
import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: FavoritesPresenterProtocol!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Privates

private extension FavoritesViewController {
    func setupUI() {
        addViews()
        configureLayout()
        
        view.backgroundColor = .white
    }
    
    func addViews() {
        
    }
    
    func configureLayout() {
        
    }
}

// MARK: - FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    
}
