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
    
    private lazy var searchController: UISearchController = {
        let searchController: UISearchController = .init()
        searchController.searchBar.placeholder = "Ara..."
        searchController.searchResultsUpdater = self
        return searchController
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
    
        navigationItem.title = "Sohbetler"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationItem.searchController = searchController
    }
    
    func addViews() {
        view.addSubviews([
            chatsTableView
        ])
    }
    
    func configureLayout() {
        chatsTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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

// MARK: - UISearchResultsUpdating

extension ChatViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

#Preview {
    ChatViewController()
}
