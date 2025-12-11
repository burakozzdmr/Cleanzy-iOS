//
//  ProfileViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 11.12.2025.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ProfilePresenterProtocol!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Privates

private extension ProfileViewController {
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

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    
}
