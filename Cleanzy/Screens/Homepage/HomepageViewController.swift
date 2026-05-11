//
//  HomepageViewController.swift
//  Cleanzy
//
//  Created by Burak Özdemir on 22.11.2025.
//

import SnapKit
import UIKit

final class HomepageViewController: UIViewController {

    // MARK: - Section

    private enum Section: Int, CaseIterable {
        case services
        case cleaners
    }

    // MARK: - Properties

    var presenter: HomepagePresenterProtocol!

    private var cleanerItems: [HomepageCleanerItem] = []
    private let serviceItems = HomepageServiceItem.all

    private let loadingView: AuthenticationLoadingView = .init()

    // MARK: - Top Header

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        imageView.backgroundColor = UIColor.accent.withAlphaComponent(0.15)
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .accent
        return imageView
    }()

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var notificationsButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "bell.fill")
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .accent
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        button.configuration = config
        button.backgroundColor = UIColor.systemGray5
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(notificationsTapped), for: .touchUpInside)
        return button
    }()

    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
        view.addGestureRecognizer(tap)
        return view
    }()

    // MARK: - Collection View

    private lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomepageServiceCell.self, forCellWithReuseIdentifier: HomepageServiceCell.reuseIdentifier)
        collectionView.register(HomepageCleanerCell.self, forCellWithReuseIdentifier: HomepageCleanerCell.reuseIdentifier)
        collectionView.register(
            HomepageSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomepageSectionHeaderView.reuseIdentifier
        )
        return collectionView
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
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
    func searchTapped() { presenter?.didTapSearch() }
}

// MARK: - Privates

private extension HomepageViewController {
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1.0)
        addViews()
        configureLayout()
    }

    func addViews() {
        view.addSubviews([
            avatarImageView,
            greetingLabel,
            notificationsButton,
            searchBarView,
            mainCollectionView
        ])
    }

    func configureLayout() {
        avatarImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(48)
        }

        greetingLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualTo(notificationsButton.snp.leading).offset(-8)
        }

        notificationsButton.snp.makeConstraints {
            $0.centerY.equalTo(avatarImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(36)
        }

        searchBarView.snp.makeConstraints {
            $0.top.equalTo(avatarImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }

        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBarView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Compositional Layout

    func makeCollectionViewLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .services:  return self?.makeServicesSection()
            case .cleaners:  return self?.makeCleanersSection()
            }
        }
    }

    func makeServicesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(116), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(116), heightDimension: .absolute(132))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 24, trailing: 20)
        section.boundarySupplementaryItems = [makeSectionHeader(height: 44)]
        return section
    }

    func makeCleanersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(84))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 32, trailing: 20)
        section.boundarySupplementaryItems = [makeSectionHeader(height: 48)]
        return section
    }

    func makeSectionHeader(height: CGFloat) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height))
        return NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
}

// MARK: - HomepageViewProtocol

extension HomepageViewController: HomepageViewProtocol {
    func displayCleaners(_ items: [HomepageCleanerItem]) {
        cleanerItems = items
        mainCollectionView.reloadSections(IndexSet(integer: Section.cleaners.rawValue))
    }

    func displayGreeting(_ name: String) {
        greetingLabel.text = "Merhaba, \(name)"
    }

    func showLoading() {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func hideLoading() {
        loadingView.removeFromSuperview()
    }

    func showAlert(with alertModel: AlertModel) {
        AlertManager.shared.showAlert(
            with: AlertModel(title: alertModel.title, message: alertModel.message),
            from: self
        )
    }
}

// MARK: - UICollectionViewDataSource

extension HomepageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .services:  return serviceItems.count
        case .cleaners:  return cleanerItems.count
        case .none:      return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .services:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomepageServiceCell.reuseIdentifier, for: indexPath
            ) as! HomepageServiceCell
            cell.configure(with: serviceItems[indexPath.item])
            return cell

        case .cleaners:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomepageCleanerCell.reuseIdentifier, for: indexPath
            ) as! HomepageCleanerCell
            cell.configure(with: cleanerItems[indexPath.item])
            return cell

        case .none:
            return UICollectionViewCell()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HomepageSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as! HomepageSectionHeaderView

        switch Section(rawValue: indexPath.section) {
        case .services:
            header.configure(title: "Popüler Hizmetler")
        case .cleaners:
            header.configure(title: "Yakındaki Temizlik Uzmanları", actionTitle: "Tümü")
        case .none:
            break
        }
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension HomepageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section) {
        case .cleaners:  presenter?.didSelectCleaner(at: indexPath.item)
        case .services:  presenter?.didSelectService(at: indexPath.item)
        case .none:      break
        }
    }
}

#Preview {
    HomepageViewController()
}
