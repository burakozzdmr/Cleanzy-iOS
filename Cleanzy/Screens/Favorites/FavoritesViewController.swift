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

    private var items: [FavoriteItem] = []

    // MARK: - UI

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 16, left: 20, bottom: 24, right: 20)
        let itemWidth = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: itemWidth, height: 88)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(HomepageCleanerCell.self, forCellWithReuseIdentifier: HomepageCleanerCell.reuseIdentifier)
        return cv
    }()

    private let emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true
        return v
    }()

    private let emptyIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.slash"))
        iv.tintColor = UIColor.systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let emptyTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Henüz Favori Yok"
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        l.textColor = UIColor(red: 0.30, green: 0.32, blue: 0.36, alpha: 1.0)
        l.textAlignment = .center
        return l
    }()

    private let emptySubtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Beğendiğiniz temizlikçileri favorilere ekleyerek\nburadan kolayca ulaşabilirsiniz."
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = UIColor.systemGray
        l.textAlignment = .center
        l.numberOfLines = 0
        return l
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }
}

// MARK: - Private Setup

private extension FavoritesViewController {
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)

        navigationItem.title = "Favorilerim"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 28, weight: .bold)
        ]

        emptyStateView.addSubviews([emptyIconView, emptyTitleLabel, emptySubtitleLabel])
        view.addSubviews([collectionView, emptyStateView])

        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        emptyStateView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
        }

        emptyIconView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }

        emptyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyIconView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }

        emptySubtitleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - FavoritesViewProtocol

extension FavoritesViewController: FavoritesViewProtocol {
    func displayFavorites(_ items: [FavoriteItem]) {
        self.items = items
        emptyStateView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func showEmptyState() {
        items = []
        collectionView.isHidden = true
        emptyStateView.isHidden = false
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

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomepageCleanerCell.reuseIdentifier,
            for: indexPath
        ) as? HomepageCleanerCell else { return UICollectionViewCell() }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItem(at: indexPath.item)
    }
}

#Preview {
    UINavigationController(rootViewController: FavoritesBuilder.createModule())
}
