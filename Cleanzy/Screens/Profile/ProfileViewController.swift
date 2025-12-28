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
    
    private let userPhotoImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .init(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 48
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Muhammet Burak Özdemir"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let userAuthStateLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Doğrulanmamış Üye"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .systemRed
        return label
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView: UITableView = .init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
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
        navigationItem.title = "Profil"
    }
    
    func addViews() {
        view.addSubviews([
            userPhotoImageView,
            userNameLabel,
            userAuthStateLabel,
            profileTableView
        ])
    }
    
    func configureLayout() {
        userPhotoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(96)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userPhotoImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        userAuthStateLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(144)
            $0.height.equalTo(32)
        }
        
        profileTableView.snp.makeConstraints {
            $0.top.equalTo(userAuthStateLabel.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        .init()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        .init()
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
}

#Preview {
    ProfileViewController()
}
