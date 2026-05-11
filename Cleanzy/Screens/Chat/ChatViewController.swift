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
    private var allItems: [ChatItem] = []
    private var filteredItems: [ChatItem] = []
    private var isSearching = false

    // MARK: - UI

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Ara..."
        sb.searchBarStyle = .minimal
        sb.delegate = self
        sb.backgroundImage = UIImage()
        sb.searchTextField.backgroundColor = UIColor(red: 0.93, green: 0.94, blue: 0.96, alpha: 1.0)
        sb.searchTextField.layer.cornerRadius = 12
        sb.searchTextField.clipsToBounds = true
        sb.searchTextField.font = .systemFont(ofSize: 15)
        return sb
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.rowHeight = 76
        tv.showsVerticalScrollIndicator = false
        tv.register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.reuseIdentifier)
        return tv
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
}

// MARK: - Objective-C

@objc private extension ChatViewController {
    func composeTapped() { }
}

// MARK: - Helpers

private extension ChatViewController {
    func showDeleteConfirmation(for indexPath: IndexPath) {
        let index = indexPath.row
        let chatName = isSearching ? filteredItems[index].userName : allItems[index].userName

        let yesAction = UIAlertAction(title: "Evet, Sil", style: .destructive) { [weak self] _ in
            guard let self else { return }
            let item = self.isSearching ? self.filteredItems[index] : self.allItems[index]
            guard let fullIndex = self.allItems.firstIndex(where: { $0.id == item.id }) else { return }
            self.presenter?.didConfirmDeleteChat(at: fullIndex)
        }
        let noAction = UIAlertAction(title: "Hayır", style: .cancel)

        let alertModel = AlertModel(
            title: "Sohbeti Sil",
            message: "\(chatName) ile olan sohbeti silmek istediğinize emin misiniz?",
            actions: [yesAction, noAction]
        )
        AlertManager.shared.showAlert(with: alertModel, from: self)
    }
}

// MARK: - Private Setup

private extension ChatViewController {
    func setupUI() {
        view.backgroundColor = .white

        navigationItem.title = "Sohbetler"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]

        let composeButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(composeTapped)
        )
        composeButton.tintColor = .accent
        navigationItem.rightBarButtonItem = composeButton

        view.addSubviews([searchBar, tableView])

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(4)
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(44)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - ChatViewProtocol

extension ChatViewController: ChatViewProtocol {
    func displayChats(_ items: [ChatItem]) {
        allItems = items
        filteredItems = items
        tableView.reloadData()
    }

    func deleteChat(at fullIndex: Int) {
        guard fullIndex < allItems.count else { return }
        let deletedItem = allItems[fullIndex]
        allItems.remove(at: fullIndex)

        if isSearching {
            if let filteredIndex = filteredItems.firstIndex(where: { $0.id == deletedItem.id }) {
                filteredItems.remove(at: filteredIndex)
                tableView.deleteRows(at: [IndexPath(row: filteredIndex, section: 0)], with: .left)
            }
        } else {
            filteredItems = allItems
            tableView.deleteRows(at: [IndexPath(row: fullIndex, section: 0)], with: .left)
        }
    }

    func showLoading() { }
    func hideLoading() { }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(
            with: AlertModel(title: alertModel.title, message: alertModel.message),
            from: self
        )
    }
}

// MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isSearching ? filteredItems.count : allItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatListCell.reuseIdentifier, for: indexPath
        ) as? ChatListCell else { return UITableViewCell() }
        let item = isSearching ? filteredItems[indexPath.row] : allItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectChat(at: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self else { completion(false); return }
            self.showDeleteConfirmation(for: indexPath)
            completion(false)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = UIColor(red: 0.95, green: 0.25, blue: 0.25, alpha: 1.0)

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

// MARK: - UISearchBarDelegate

extension ChatViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredItems = allItems
        } else {
            isSearching = true
            filteredItems = allItems.filter {
                $0.userName.localizedCaseInsensitiveContains(searchText) ||
                $0.lastMessage.localizedCaseInsensitiveContains(searchText)
            }
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredItems = allItems
        tableView.reloadData()
    }
}

#Preview {
    UINavigationController(rootViewController: ChatBuilder.createModule())
}
