//
//  HomepageViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import SnapKit
import UIKit

final class HomepageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let userImageView: UIImageView = {
        let imageView: UIImageView = .init()
        imageView.image = .init()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    
    private let greetingLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Merhaba, Burak"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var notificationsButton: UIButton = {
        let button: UIButton = .init()
        
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "bell.fill")
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .accent
        config.cornerStyle = .capsule
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        config.preferredSymbolConfigurationForImage = imageConfig
        
        button.configuration = config
        button.backgroundColor = .lightGray.withAlphaComponent(0.25)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(notificationsTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let searchView: SearchBarView = .init()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        searchView.addGestureRecognizer(tapGesture)
        return searchView
    }()
    
    private let listHeaderLabel: UILabel = {
        let label: UILabel = .init()
        label.text = "Popüler Temizlik Uzmanları"
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var allUsersButton: UIButton = {
        let button: UIButton = .init(type: .system)
        button.setTitle("Tümü", for: .normal)
        button.setTitleColor(.accent, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        return button
    }()
    
    private let headerStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var userListCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
        flowLayout.itemSize = CGSize(width: 400, height: 144)
        
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var presenter: HomepagePresenterProtocol!
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.hidesBackButton = true
    }
}

// MARK: - Objective-C Methods

@objc private extension HomepageViewController {
    func notificationsTapped() { }
    
    func searchTapped() { }
}

// MARK: - Privates

private extension HomepageViewController {
    func setupUI() {
        addViews()
        configureLayout()
        
        view.backgroundColor = .white
    }
    
    func addViews() {
        view.addSubviews([
            userImageView,
            greetingLabel,
            notificationsButton,
            searchBarView,
            headerStackView,
            userListCollectionView
        ])
        
        headerStackView.addArrangedSubview(listHeaderLabel)
        headerStackView.addArrangedSubview(allUsersButton)
    }
    
    func configureLayout() {
        userImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }
        
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(userImageView.snp.trailing).offset(16)
        }
        
        notificationsButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(32)
        }
        
        searchBarView.snp.makeConstraints {
            $0.top.equalTo(notificationsButton.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(360)
            $0.height.equalTo(48)
        }
        
        headerStackView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().offset(16)
        }
        
        userListCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - HomepageViewProtocol

extension HomepageViewController: HomepageViewProtocol {
    
}

// MARK: - UISearchBarDelegate

extension HomepageViewController: UISearchBarDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension HomepageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        .init()
    }
}

// MARK: - UICollectionViewDelegate

extension HomepageViewController: UICollectionViewDelegate {
    
}

#Preview {
    HomepageViewController()
}
