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
    
    private let chatsLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Sohbetler"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar: UISearchBar = .init()
        searchBar.delegate = self
        searchBar.placeholder = "Ara..."
        return searchBar
    }()
    
    private lazy var chatsTableView: UITableView = {
        let tableView: UITableView = .init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        return tableView
    }()
    
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
        view.addSubviews([
            chatsLabel,
            searchBar,
            chatsTableView
        ])
    }
    
    func configureLayout() {
        chatsLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(chatsLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(384)
        }
        
        chatsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {
    
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        .init()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        .init()
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
}

// MARK: - UISearchBarDelegate

extension ChatViewController: UISearchBarDelegate {
    
}

#Preview {
    ChatViewController()
}
