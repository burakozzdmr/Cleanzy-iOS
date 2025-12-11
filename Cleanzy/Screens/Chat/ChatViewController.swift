//
//  ChatViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 5.12.2025.
//

import SnapKit
import UIKit

final class ChatViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ChatPresenterProtocol!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK: - Privates

private extension ChatViewController {
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

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {
    
}
