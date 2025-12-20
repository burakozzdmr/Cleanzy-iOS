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
    
    private lazy var favoritesCollectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = .init()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.itemSize = CGSize(width: 420, height: 144)
        
        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
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
        
        navigationItem.title = "Favorilerim"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    func addViews() {
        view.addSubviews([
            favoritesCollectionView
        ])
    }
    
    func configureLayout() {
        favoritesCollectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        .init()
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    
}

#Preview {
    FavoritesViewController()
}
